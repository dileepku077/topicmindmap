-- Astro STEM Labs: make award_medal() score the tier a student just
-- finished, instead of requiring every free-tier question across the whole
-- subtopic in one sitting.
--
-- The tier picker (schema_subscriptions.sql's list_questions gating, and
-- practice_test_page.dart's UI) already treats Easy/Medium/Challenge/
-- Advanced as separate, standalone practice sessions -- a student can walk
-- in and do just "Easy". But award_medal() never caught up: it summed
-- every reachable question across every tier of the subtopic and refused
-- to award anything until all of them were solved in the same pass. A
-- student who aced a single tier saw "0 of N correct" style non-results
-- (reported as "chose the right answer every time, but it said incorrect
-- at the end") because N counted tiers they hadn't even attempted yet.
--
-- Fix: award_medal() now takes the difficulty tier the student just
-- finished and scores/gates entirely within that tier. Gold's old extra
-- "every Hard question first try" clause is gone because it's now
-- redundant -- when p_difficulty is itself Hard/Challenge/Advanced, the
-- ordinary 90%-first-try threshold already means "nearly every hard
-- question, first try", since every counted question in the tier IS a
-- hard one.
--
-- subtopic_mastery keeps one row per subtopic (not one per tier) --
-- medal/best_first_try/total_questions still describe the single best
-- pass so far, upward-only by medal rank, same as before; they just now
-- reflect whichever tier earned that medal rather than a whole-subtopic
-- sweep.
--
-- Run after schema_subscriptions.sql (replaces its 3-arg award_medal with
-- a 4-arg, tier-scoped version). Safe to re-run.

drop function if exists public.award_medal(text, text, text);

create function public.award_medal(
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
