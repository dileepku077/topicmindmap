-- Astro STEM Labs: persists per-(unit, subtopic, difficulty) practice
-- completion into a real table, so an admin (and later, a parent-facing
-- view) can query a student's progress directly with plain SQL instead of
-- it only existing as a live, recomputed-on-every-page-load RPC result
-- (topic_tier_progress(), schema_progress_report.sql — that RPC keeps
-- working as-is for the student's own Progress Report page; this table is
-- an additional, queryable copy of the same numbers, not a replacement).
--
-- Same shape as topic_tier_progress()'s own output, one row per tier a
-- student has ever made any progress in (not one row per tier that
-- exists — an untouched tier just has no row, same simplification
-- subtopic_mastery already makes).
--
-- Kept up to date going forward by award_medal() (redefined below) itself
-- upserting into this table every time it runs — i.e. every time a
-- student finishes a practice-tier attempt, whether or not that attempt
-- actually completed the tier. No separate "sync" step for the app to
-- remember to call. For every student's *history* before this table
-- existed, run admin_backfill_progress_report() once (safe to re-run any
-- time — e.g. after a bulk progress reset, or just periodically, since it
-- only ever overwrites a row with numbers freshly recomputed from
-- attempts, the real source of truth).
--
-- Run after schema_tier_medals.sql (redefines its award_medal()) and
-- schema_admin.sql (needs is_admin()). Safe to re-run.

create table if not exists public.topic_progress_report (
  student_id       uuid not null references auth.users (id) on delete cascade,
  course_code      text not null,
  unit_code        text not null,
  subtopic_code    text not null,
  difficulty       text not null,
  total_questions  int  not null,
  solved_questions int  not null,
  is_complete      boolean generated always as (solved_questions >= total_questions) stored,
  updated_at       timestamptz not null default now(),
  primary key (student_id, course_code, unit_code, subtopic_code, difficulty)
);

create index if not exists topic_progress_report_student_idx
  on public.topic_progress_report (student_id, course_code);

alter table public.topic_progress_report enable row level security;

-- A student reads only their own rows; an admin reads everyone's — the
-- whole point of this table is letting an admin (Profile & Preferences ->
-- Progress Report today is student-only; an admin-facing per-student view
-- is a natural next step on top of this same table) query across
-- students, which a live-only RPC scoped to auth.uid() could never do.
drop policy if exists "progress report is owner or admin readable" on public.topic_progress_report;
create policy "progress report is owner or admin readable"
  on public.topic_progress_report for select
  using (auth.uid() = student_id or is_admin(auth.uid()));

-- No insert/update/delete policy for anyone, including the owner — every
-- write goes through award_medal() (per-tier, live) or
-- admin_backfill_progress_report() (bulk, historical), both security
-- definer, same "narrow RPC, not a wide table grant" rule every other
-- student-writable table in this app already follows.

-- ---------------------------------------------------------------------------
-- award_medal(): unchanged scoring/medal logic (see schema_tier_medals.sql
-- for the full history of why it's shaped this way) — the only addition is
-- upserting topic_progress_report with the same v_solved/v_total this
-- function already computes for itself, right before the "not finished
-- yet" early return so a partial attempt still updates the stored number
-- rather than only a fully-cleared tier ever touching this table.
-- ---------------------------------------------------------------------------

create or replace function public.award_medal(
  p_course_code   text,
  p_unit_code     text,
  p_subtopic_code text,
  p_difficulty    text
)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_is_pro    boolean;
  v_is_hard   boolean;
  v_reset_at  timestamptz;
  v_last_pass timestamptz;
  v_since     timestamptz;
  v_total     int;
  v_first_try int;
  v_solved    int;
  v_earned    text;
  v_existing  text;
  v_rank      int;
  v_had_rank  int;
begin
  if auth.uid() is null then
    raise exception 'Not signed in.';
  end if;

  select coalesce(
    (select p.subscription_tier = 'pro' from profiles p where p.id = auth.uid()),
    false
  ) into v_is_pro;

  v_is_hard := p_difficulty in ('Hard', 'Challenge', 'Advanced');

  -- Defense in depth, same as submit_answer() -- the UI never lets a free
  -- student pick a locked tier, but this closes the gap for a direct RPC
  -- call.
  if v_is_hard and not v_is_pro then
    raise exception 'This tier requires a Pro subscription.';
  end if;

  select count(*) into v_total
  from questions
  where course_code = p_course_code
    and unit_code = p_unit_code
    and subtopic_code = p_subtopic_code
    and difficulty = p_difficulty;

  if v_total = 0 then
    return 'None';
  end if;

  select r.reset_at into v_reset_at
  from progress_resets r
  where r.student_id = auth.uid() and r.course_code = p_course_code;

  -- When this subtopic last earned/updated a medal. Since that write now
  -- happens per-tier (not just on a whole-subtopic sweep), this window
  -- naturally advances each time a tier is cleared.
  select m.updated_at into v_last_pass
  from subtopic_mastery m
  where m.student_id = auth.uid()
    and m.course_code = p_course_code
    and m.unit_code = p_unit_code
    and m.subtopic_code = p_subtopic_code;

  v_since := greatest(v_reset_at, v_last_pass);

  select count(distinct a.sort_order) filter (where a.was_correct),
         count(distinct a.sort_order) filter (where a.was_correct and a.was_first_attempt)
    into v_solved, v_first_try
  from attempts a
  where a.student_id = auth.uid()
    and a.course_code = p_course_code
    and a.unit_code = p_unit_code
    and a.subtopic_code = p_subtopic_code
    and a.difficulty = p_difficulty
    and (v_since is null or a.answered_at > v_since);

  -- Keep the persisted progress-report row current every time this runs,
  -- complete or not -- an admin/parent looking at this table should see
  -- real partial progress, not just a jump straight from nothing to done.
  insert into topic_progress_report (
    student_id, course_code, unit_code, subtopic_code, difficulty,
    total_questions, solved_questions, updated_at
  ) values (
    auth.uid(), p_course_code, p_unit_code, p_subtopic_code, p_difficulty,
    v_total, v_solved, now()
  )
  on conflict (student_id, course_code, unit_code, subtopic_code, difficulty)
  do update set
    total_questions  = excluded.total_questions,
    solved_questions = excluded.solved_questions,
    updated_at       = excluded.updated_at;

  -- Not finished this tier yet — nothing to award. Shouldn't happen if
  -- this is only called after every question in the tier has been
  -- answered correctly, same caveat as before.
  if v_solved < v_total then
    return 'None';
  end if;

  if v_first_try::numeric / v_total >= 0.9 then
    v_earned := 'Gold';
  elsif v_first_try::numeric / v_total >= 0.7 then
    v_earned := 'Silver';
  else
    v_earned := 'Bronze';
  end if;

  select m.medal into v_existing
  from subtopic_mastery m
  where m.student_id = auth.uid()
    and m.course_code = p_course_code
    and m.unit_code = p_unit_code
    and m.subtopic_code = p_subtopic_code;

  v_rank     := case v_earned when 'Gold' then 3 when 'Silver' then 2 when 'Bronze' then 1 else 0 end;
  v_had_rank := case coalesce(v_existing, 'None')
                  when 'Gold' then 3 when 'Silver' then 2 when 'Bronze' then 1 else 0 end;

  insert into subtopic_mastery (
    student_id, course_code, unit_code, subtopic_code, medal, best_first_try,
    total_questions, hard_first_try, hard_total, times_completed,
    first_earned_at, updated_at
  ) values (
    auth.uid(), p_course_code, p_unit_code, p_subtopic_code,
    v_earned, v_first_try, v_total,
    case when v_is_hard then v_first_try else 0 end,
    case when v_is_hard then v_total else 0 end,
    1, now(), now()
  )
  on conflict (student_id, course_code, unit_code, subtopic_code) do update set
    -- Upward only by medal rank, same guarantee as before: a worse retry,
    -- or acing a smaller/easier tier after a bigger medal is already
    -- banked, never costs the medal or the numbers behind it.
    medal = case
              when v_rank >= v_had_rank then v_earned
              else subtopic_mastery.medal
            end,
    best_first_try = case
              when v_rank >= v_had_rank then v_first_try
              else subtopic_mastery.best_first_try
            end,
    total_questions = case
              when v_rank >= v_had_rank then v_total
              else subtopic_mastery.total_questions
            end,
    hard_first_try = case
              when v_rank >= v_had_rank and v_is_hard then v_first_try
              else subtopic_mastery.hard_first_try
            end,
    hard_total = case
              when v_rank >= v_had_rank and v_is_hard then v_total
              else subtopic_mastery.hard_total
            end,
    times_completed = subtopic_mastery.times_completed + 1,
    updated_at      = now();

  return v_earned;
end;
$$;

revoke all on function public.award_medal(text, text, text, text) from public, anon;
grant execute on function public.award_medal(text, text, text, text) to authenticated;

-- ---------------------------------------------------------------------------
-- admin_backfill_progress_report(): one-time (or periodic) bulk population
-- of topic_progress_report from every student's existing attempts history,
-- for every course a student has ever touched -- so an admin querying this
-- table right after it's created isn't looking at an empty table for
-- every student who practiced before today. Same tier-resolution rule as
-- topic_tier_progress() (schema_progress_report.sql): read each attempt's
-- CURRENT tier from questions, not the difficulty label stamped on the
-- attempt at the time, so a course whose tiers were ever relabeled (see
-- that file's own note on MPM2D's Hard -> Challenge/Advanced retag)
-- backfills correctly too.
-- ---------------------------------------------------------------------------

create or replace function public.admin_backfill_progress_report()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  -- auth.uid() is only ever set when this runs through the app's normal
  -- API layer (a signed-in session's JWT) -- a plain call from the
  -- Supabase SQL editor (or any other direct/superuser DB session) has no
  -- such context at all, auth.uid() reads as null there, and that level
  -- of access is already at least as trusted as being an admin in the
  -- app. Only block the case this CAN distinguish: a signed-in student
  -- calling this RPC directly, bypassing the UI.
  if auth.uid() is not null and not is_admin(auth.uid()) then
    raise exception 'Admins only.';
  end if;

  insert into topic_progress_report (
    student_id, course_code, unit_code, subtopic_code, difficulty,
    total_questions, solved_questions, updated_at
  )
  with engaged as (
    select distinct student_id, course_code from attempts
  ),
  tiers as (
    select course_code, unit_code, subtopic_code, difficulty, count(*) as total_q
    from questions
    group by course_code, unit_code, subtopic_code, difficulty
  ),
  solved as (
    select
      a.student_id,
      q.course_code,
      q.unit_code,
      q.subtopic_code,
      q.difficulty,
      count(distinct a.sort_order) as solved_q
    from attempts a
    join questions q
      on q.course_code = a.course_code
      and q.unit_code = a.unit_code
      and q.subtopic_code = a.subtopic_code
      and q.sort_order = a.sort_order
    left join progress_resets r
      on r.student_id = a.student_id and r.course_code = a.course_code
    where a.was_correct
      and a.source is null
      and (r.reset_at is null or a.answered_at > r.reset_at)
    group by a.student_id, q.course_code, q.unit_code, q.subtopic_code, q.difficulty
  )
  select
    e.student_id,
    t.course_code,
    t.unit_code,
    t.subtopic_code,
    t.difficulty,
    t.total_q,
    coalesce(s.solved_q, 0),
    now()
  from engaged e
  join tiers t on t.course_code = e.course_code
  left join solved s
    on s.student_id = e.student_id
    and s.course_code = t.course_code
    and s.unit_code = t.unit_code
    and s.subtopic_code = t.subtopic_code
    and s.difficulty = t.difficulty
  on conflict (student_id, course_code, unit_code, subtopic_code, difficulty)
  do update set
    total_questions  = excluded.total_questions,
    solved_questions = excluded.solved_questions,
    updated_at       = excluded.updated_at;
end;
$$;

revoke all on function public.admin_backfill_progress_report() from public, anon;
grant execute on function public.admin_backfill_progress_report() to authenticated;
