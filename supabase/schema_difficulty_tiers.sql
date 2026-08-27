-- Astro Math: adds "Challenge" and "Advanced" as difficulty tiers, on top of
-- the existing Easy/Medium/Hard set, so MPM2D's practice questions can ramp
-- Easy -> Medium -> Challenge -> Advanced instead of stopping at Hard.
--
-- Deliberately additive, not a rename: MCR3U and MHF4U's question banks
-- still use 'Hard' as their own top tier (see questions_seed.sql), and
-- re-seeding them must keep working unmodified. Only MPM2D's own questions
-- are retagged here (Hard -> Challenge) and get new Advanced-tier content
-- (see questions_seed.sql) -- every other course is untouched.
--
-- Run after schema_practice.sql (needs public.questions/subtopic_mastery to
-- exist) and before re-running questions_seed.sql (which now inserts rows
-- tagged 'Challenge'/'Advanced' for MPM2D that this constraint must allow).
-- Safe to re-run.

alter table public.questions
  drop constraint if exists questions_difficulty_check;

alter table public.questions
  add constraint questions_difficulty_check
  check (difficulty in ('Easy', 'Medium', 'Hard', 'Challenge', 'Advanced'));

-- list_questions() ordered Easy, then Medium, then Hard -- extended so a
-- course using the new tiers ramps Easy -> Medium -> Challenge -> Advanced
-- the same way. 'Hard' and 'Challenge' share a rank because no course ever
-- mixes the two label sets in one subtopic (Hard is MCR3U/MHF4U's own top
-- tier, Challenge is the tier below MPM2D's new Advanced), so within any
-- one subtopic this is still a strict, unambiguous order.
--
-- Postgres won't let CREATE OR REPLACE change a function's return-table
-- shape, only its body (same issue schema_subscriptions.sql's own version
-- of this function already documents) -- has to be dropped first. That
-- matters here specifically because re-running every schema_*.sql file in
-- order, twice, leaves list_questions in schema_subscriptions.sql's
-- 5-column shape (it adds a `locked` column) by the time this file's own
-- CREATE OR REPLACE runs again on the *second* pass, even though this file
-- is meant to run *before* schema_subscriptions.sql the first time through.
-- Dropping first makes this file idempotent regardless of which shape was
-- left over from a previous full run. Dropping also clears the function's
-- privileges, so the REVOKE/GRANT below re-applies the same "students yes,
-- anonymous visitors no" grant schema_practice.sql originally set --
-- schema_subscriptions.sql (if run afterward, as intended) redoes this
-- again itself once it adds the `locked` column.
drop function if exists public.list_questions(text, text, text);

create function public.list_questions(
  p_course_code   text,
  p_unit_code     text,
  p_subtopic_code text
)
returns table (sort_order int, difficulty text, prompt text, options jsonb)
language sql
security definer
stable
set search_path = public
as $$
  select q.sort_order,
         q.difficulty,
         q.prompt,
         (
           select jsonb_agg(jsonb_build_object('text', elem ->> 'text') order by ord)
           from jsonb_array_elements(q.options) with ordinality as t(elem, ord)
         )
  from questions q
  where q.course_code = p_course_code
    and q.unit_code = p_unit_code
    and q.subtopic_code = p_subtopic_code
  order by case q.difficulty
             when 'Easy' then 0
             when 'Medium' then 1
             when 'Challenge' then 2
             when 'Hard' then 2
             when 'Advanced' then 3
             else 4
           end,
           q.sort_order;
$$;

revoke all on function public.list_questions(text, text, text) from public, anon;
grant execute on function public.list_questions(text, text, text) to authenticated;

-- award_medal()'s Gold gate previously required every 'Hard' question
-- solved first-try -- 'Hard' was always the single hardest tier a subtopic
-- could have. That's still true per course: MCR3U/MHF4U's hardest tier is
-- 'Hard', MPM2D's is now 'Advanced'. Counting `difficulty in ('Hard',
-- 'Advanced')` keeps the gate working for both without a per-course branch,
-- since a subtopic only ever has one of the two labels. The
-- hard_total/hard_first_try columns and variable names are kept as-is
-- (internal bookkeeping only, never read by the app -- see
-- models/subtopic_mastery.dart) to avoid unrelated churn.
create or replace function public.award_medal(
  p_course_code   text,
  p_unit_code     text,
  p_subtopic_code text
)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_reset_at   timestamptz;
  v_last_pass  timestamptz;
  v_since      timestamptz;
  v_total      int;
  v_hard_total int;
  v_first_try  int;
  v_hard_first int;
  v_solved     int;
  v_earned     text;
  v_existing   text;
  v_rank       int;
  v_had_rank   int;
begin
  if auth.uid() is null then
    raise exception 'Not signed in.';
  end if;

  select count(*), count(*) filter (where difficulty in ('Hard', 'Advanced'))
    into v_total, v_hard_total
  from questions
  where course_code = p_course_code
    and unit_code = p_unit_code
    and subtopic_code = p_subtopic_code;

  if v_total = 0 then
    return 'None';
  end if;

  select r.reset_at into v_reset_at
  from progress_resets r
  where r.student_id = auth.uid() and r.course_code = p_course_code;

  -- Same window submit_answer used, so the medal is scored on exactly the
  -- taps that were marked as first attempts.
  select m.updated_at into v_last_pass
  from subtopic_mastery m
  where m.student_id = auth.uid()
    and m.course_code = p_course_code
    and m.unit_code = p_unit_code
    and m.subtopic_code = p_subtopic_code;

  v_since := greatest(v_reset_at, v_last_pass);

  -- Distinct questions, because a question answered right after three wrong
  -- taps must not count three times.
  select count(distinct a.sort_order) filter (where a.was_correct),
         count(distinct a.sort_order) filter (where a.was_correct and a.was_first_attempt),
         count(distinct a.sort_order) filter (
           where a.was_correct and a.was_first_attempt and a.difficulty in ('Hard', 'Advanced')
         )
    into v_solved, v_first_try, v_hard_first
  from attempts a
  where a.student_id = auth.uid()
    and a.course_code = p_course_code
    and a.unit_code = p_unit_code
    and a.subtopic_code = p_subtopic_code
    and (v_since is null or a.answered_at > v_since);

  -- Not finished yet — nothing to award.
  if v_solved < v_total then
    return 'None';
  end if;

  if v_first_try::numeric / v_total >= 0.9
     and (v_hard_total = 0 or v_hard_first = v_hard_total) then
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
    case when v_rank >= v_had_rank then v_earned else v_existing end,
    v_first_try, v_total, v_hard_first, v_hard_total, 1, now(), now()
  )
  on conflict (student_id, course_code, unit_code, subtopic_code) do update set
    -- Upward only. A bad rerun never costs a medal already earned.
    medal = case
              when v_rank >= v_had_rank then v_earned
              else subtopic_mastery.medal
            end,
    best_first_try  = greatest(subtopic_mastery.best_first_try, v_first_try),
    total_questions = v_total,
    hard_first_try  = greatest(subtopic_mastery.hard_first_try, v_hard_first),
    hard_total      = v_hard_total,
    times_completed = subtopic_mastery.times_completed + 1,
    updated_at      = now();

  return v_earned;
end;
$$;
