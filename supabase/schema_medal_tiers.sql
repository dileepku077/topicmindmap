-- Astro STEM Labs: adds a 4th medal tier, Diamond, above Gold, and
-- rebands all four around first-try accuracy instead of the old 3-tier
-- split:
--
--   Bronze    30% - 60% correct on the first try
--   Silver    60% - 80% correct on the first try
--   Gold      80% - 90% correct on the first try
--   Diamond   90% - 100% correct on the first try
--   (below 30%, no medal at all)
--
-- "Correct on the first try" is unchanged as the underlying metric —
-- Silver/Gold already used it (best_first_try / total_questions); this
-- just extends the same idea into four bands with an explicit floor,
-- replacing the old rule where Bronze was awarded just for finishing
-- every question eventually (any number of taps), with no first-try
-- bar at all. Finishing every question in the tier at least once is
-- still required to earn *any* medal (v_solved < v_total still returns
-- 'None' before banding runs) — this only changes which medal (if any)
-- a *completed* pass earns.
--
-- Existing subtopic_mastery rows are reclassified in place below, using
-- the exact same best_first_try/total_questions already on record — no
-- need to ask anyone to retake anything; a past pass that already scored
-- 92% first-try, for instance, becomes Diamond retroactively rather than
-- staying frozen as a Gold earned under the old 90% bar.
--
-- Run after schema_progress_report_table.sql (redefines its
-- award_medal()). Safe to re-run.

alter table public.subtopic_mastery
  drop constraint if exists subtopic_mastery_medal_check;

alter table public.subtopic_mastery
  add constraint subtopic_mastery_medal_check
  check (medal in ('None', 'Bronze', 'Silver', 'Gold', 'Diamond'));

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

  -- Matched to questions on (course, unit, subtopic, sort_order) and
  -- filtered on q.difficulty (current, authoritative), NOT a.difficulty
  -- (a label snapshotted once by submit_answer(), never updated after the
  -- fact) -- see schema_progress_report_table.sql's own comment on this
  -- for the full history (MPM2D's Trigonometry/Quadratics retag).
  select count(distinct a.sort_order) filter (where a.was_correct),
         count(distinct a.sort_order) filter (where a.was_correct and a.was_first_attempt)
    into v_solved, v_first_try
  from attempts a
  join questions q
    on q.course_code = a.course_code
    and q.unit_code = a.unit_code
    and q.subtopic_code = a.subtopic_code
    and q.sort_order = a.sort_order
  where a.student_id = auth.uid()
    and a.course_code = p_course_code
    and a.unit_code = p_unit_code
    and a.subtopic_code = p_subtopic_code
    and q.difficulty = p_difficulty
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

  -- Four bands by first-try accuracy, with an explicit floor: finishing
  -- the tier is no longer enough on its own for Bronze the way it used
  -- to be -- below 30% first-try, this pass earns no medal at all, same
  -- as an incomplete one. subtopic_mastery.medal only ever moves upward
  -- (see the on-conflict block below), so this never costs a medal
  -- already banked from a better earlier pass.
  if v_first_try::numeric / v_total >= 0.9 then
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
-- One-time reclassification of every existing subtopic_mastery row against
-- the new bands, using the same best_first_try/total_questions already on
-- record -- no retaking anything. A row with 0 total_questions (shouldn't
-- exist, but defensively) is left untouched rather than divided by zero.
-- Safe to re-run: it's a pure function of columns already stored, so
-- running it twice reclassifies to the same result the second time.
-- ---------------------------------------------------------------------------

update public.subtopic_mastery
set medal = case
              when best_first_try::numeric / total_questions >= 0.9 then 'Diamond'
              when best_first_try::numeric / total_questions >= 0.8 then 'Gold'
              when best_first_try::numeric / total_questions >= 0.6 then 'Silver'
              when best_first_try::numeric / total_questions >= 0.3 then 'Bronze'
              else 'None'
            end
where total_questions > 0;
