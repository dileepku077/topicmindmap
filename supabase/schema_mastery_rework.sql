-- Astro STEM Labs: fixes the root cause of solved_questions reading 0 for
-- every row, and adds the data function the new centralized mastery
-- calculator (lib/domain/mastery_calculator.dart) reads from.
--
-- ---------------------------------------------------------------------------
-- Root cause
-- ---------------------------------------------------------------------------
-- award_medal(), topic_tier_progress(), and admin_backfill_progress_report()
-- were all changed (see schema_progress_report.sql / schema_progress_report_
-- table.sql) to resolve an attempt's difficulty tier by joining back to
-- questions on (course_code, unit_code, subtopic_code, sort_order) instead
-- of trusting attempts.difficulty directly -- meant to fix MPM2D's
-- Trigonometry/Quadratics showing stale progress after their top tier was
-- retagged 'Hard' -> 'Challenge'/'Advanced'.
--
-- That join assumes a question's sort_order is a stable identity across
-- re-seeds. It isn't: questions_seed.sql deletes and re-inserts an entire
-- course's question bank every time it's run (see its own header comment,
-- "safe to re-run: each course section deletes its own rows first"), and
-- that file has been edited and re-run five times over this app's life
-- (expanding MPM2D to 4 tiers, bringing every subtopic to a minimum
-- question count, a full audit-and-fix pass, importing a 1,600-question
-- bank). Each of those could -- and evidently did -- shift which sort_order
-- number corresponds to which conceptual question. A historical attempt's
-- sort_order no longer lining up with anything in the current questions
-- table means the join silently matches zero rows, which is exactly the
-- "solved_questions is 0 for every record" symptom -- not just on
-- previously-retagged tiers, but everywhere, for any attempt recorded
-- before the most recent re-seed.
--
-- Fix: go back to trusting attempts.difficulty directly (the label
-- submit_answer() stamped at the moment that attempt was made) -- it's
-- immune to re-seeding since it's never re-derived from questions
-- afterward. This reintroduces the narrower original bug (a handful of
-- MPM2D attempts made before the Hard -> Challenge/Advanced split stay
-- counted under 'Hard', which no longer exists as a selectable tier, so
-- they won't count toward Challenge or Advanced going forward) but that
-- is a small, historical, one-course edge case -- vastly preferable to
-- silently zeroing out every student's entire practice history on every
-- re-seed, which is what the join actually did.
--
-- Run after schema_medal_tiers.sql. Safe to re-run.

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

  select m.updated_at into v_last_pass
  from subtopic_mastery m
  where m.student_id = auth.uid()
    and m.course_code = p_course_code
    and m.unit_code = p_unit_code
    and m.subtopic_code = p_subtopic_code;

  v_since := greatest(v_reset_at, v_last_pass);

  -- Back to matching on attempts' own stamped difficulty -- see this
  -- file's header for why the questions-join version of this query was
  -- the actual root cause of solved_questions reading 0 everywhere.
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

  if v_solved < v_total then
    v_earned := 'None';
  elsif v_first_try::numeric / v_total >= 0.9 then
    v_earned := 'Diamond';
  elsif v_first_try::numeric / v_total >= 0.8 then
    v_earned := 'Gold';
  elsif v_first_try::numeric / v_total >= 0.6 then
    v_earned := 'Silver';
  elsif v_first_try::numeric / v_total >= 0.3 then
    v_earned := 'Bronze';
  else
    v_earned := 'None';
  end if;

  insert into topic_progress_report (
    student_id, course_code, unit_code, subtopic_code, difficulty,
    total_questions, solved_questions, first_try_correct, medal, updated_at
  ) values (
    auth.uid(), p_course_code, p_unit_code, p_subtopic_code, p_difficulty,
    v_total, v_solved, v_first_try, v_earned, now()
  )
  on conflict (student_id, course_code, unit_code, subtopic_code, difficulty)
  do update set
    total_questions   = excluded.total_questions,
    solved_questions  = excluded.solved_questions,
    first_try_correct = excluded.first_try_correct,
    medal             = excluded.medal,
    updated_at        = excluded.updated_at;

  if v_solved < v_total then
    return 'None';
  end if;

  select m.medal into v_existing
  from subtopic_mastery m
  where m.student_id = auth.uid()
    and m.course_code = p_course_code
    and m.unit_code = p_unit_code
    and m.subtopic_code = p_subtopic_code;

  v_rank     := case v_earned
                  when 'Diamond' then 4 when 'Gold' then 3
                  when 'Silver' then 2 when 'Bronze' then 1 else 0 end;
  v_had_rank := case coalesce(v_existing, 'None')
                  when 'Diamond' then 4 when 'Gold' then 3
                  when 'Silver' then 2 when 'Bronze' then 1 else 0 end;

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
-- admin_backfill_progress_report(): same fix -- drop the questions join,
-- trust attempts.difficulty. Re-run this after applying the function above
-- to correct every existing topic_progress_report row (they're all
-- currently 0/None because of the bug this file fixes).
-- ---------------------------------------------------------------------------

create or replace function public.admin_backfill_progress_report()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is not null and not is_admin(auth.uid()) then
    raise exception 'Admins only.';
  end if;

  insert into topic_progress_report (
    student_id, course_code, unit_code, subtopic_code, difficulty,
    total_questions, solved_questions, first_try_correct, medal, updated_at
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
      a.course_code,
      a.unit_code,
      a.subtopic_code,
      a.difficulty,
      count(distinct a.sort_order) as solved_q,
      count(distinct a.sort_order) filter (where a.was_first_attempt) as first_try_q
    from attempts a
    left join progress_resets r
      on r.student_id = a.student_id and r.course_code = a.course_code
    where a.was_correct
      and a.source is null
      and (r.reset_at is null or a.answered_at > r.reset_at)
    group by a.student_id, a.course_code, a.unit_code, a.subtopic_code, a.difficulty
  )
  select
    e.student_id,
    t.course_code,
    t.unit_code,
    t.subtopic_code,
    t.difficulty,
    t.total_q,
    coalesce(s.solved_q, 0),
    coalesce(s.first_try_q, 0),
    case
      when coalesce(s.solved_q, 0) < t.total_q then 'None'
      when s.first_try_q::numeric / t.total_q >= 0.9 then 'Diamond'
      when s.first_try_q::numeric / t.total_q >= 0.8 then 'Gold'
      when s.first_try_q::numeric / t.total_q >= 0.6 then 'Silver'
      when s.first_try_q::numeric / t.total_q >= 0.3 then 'Bronze'
      else 'None'
    end,
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
    total_questions   = excluded.total_questions,
    solved_questions  = excluded.solved_questions,
    first_try_correct = excluded.first_try_correct,
    medal             = excluded.medal,
    updated_at        = excluded.updated_at;
end;
$$;

revoke all on function public.admin_backfill_progress_report() from public, anon;
grant execute on function public.admin_backfill_progress_report() to authenticated;

-- ---------------------------------------------------------------------------
-- subtopic_attempt_stats(): raw per-(unit, subtopic, difficulty) attempt
-- counts for the new centralized mastery calculator
-- (lib/domain/mastery_calculator.dart) to consume directly -- attempted,
-- correct (any attempt), and correct-on-first-try, computed straight from
-- attempts (again, matched on attempts.difficulty, not joined to
-- questions, for the same re-seed-safety reason as above). The student's
-- own Progress Report and the practice test's tier picker both compute
-- mastery/medals live from this rather than from topic_progress_report,
-- so their numbers are never stale relative to a table sync -- source data
-- straight through, no cache to fall out of date. topic_progress_report
-- still exists and stays correct (via award_medal()/the backfill above)
-- for admin querying, it's just no longer what the app itself reads.
--
-- "Attempted" here means at least one attempt exists, whether or not it
-- was ever answered correctly (unlike solved_questions elsewhere, which
-- only counts questions answered correctly at least once) -- the new
-- mastery calculation needs real attempted-vs-correct accuracy, not just
-- a finished/not-finished signal.
-- ---------------------------------------------------------------------------

create or replace function public.subtopic_attempt_stats(p_course_code text)
returns table (
  unit_code text,
  subtopic_code text,
  difficulty text,
  attempted int,
  correct int,
  first_try_correct int
)
language sql
security definer
stable
set search_path = public
as $$
  with v_reset as (
    select reset_at
    from progress_resets
    where student_id = auth.uid()
      and course_code = p_course_code
  )
  select
    a.unit_code,
    a.subtopic_code,
    a.difficulty,
    count(distinct a.sort_order)::int as attempted,
    count(distinct a.sort_order) filter (where a.was_correct)::int as correct,
    count(distinct a.sort_order) filter (
      where a.was_correct and a.was_first_attempt
    )::int as first_try_correct
  from attempts a
  left join v_reset r on true
  where a.student_id = auth.uid()
    and a.course_code = p_course_code
    and a.source is null
    and (r.reset_at is null or a.answered_at > r.reset_at)
  group by a.unit_code, a.subtopic_code, a.difficulty;
$$;

revoke all on function public.subtopic_attempt_stats(text) from public, anon;
grant execute on function public.subtopic_attempt_stats(text) to authenticated;
