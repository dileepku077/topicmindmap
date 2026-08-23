-- Astro STEM Labs: Free/Pro subscription gating for practice questions.
--
-- Product rule: Easy and Medium questions are free for every course. Every
-- harder tier a course has -- MPM2D's Challenge/Advanced, and MCR3U/MHF4U's
-- Hard (their own single hardest tier, playing the same role) -- requires a
-- Pro subscription. There's no self-serve upgrade yet: a student pays by
-- Interac e-Transfer outside the app, and an admin manually flips their
-- subscription_tier (today via the Supabase SQL editor / table editor,
-- later via an admin UI querying the same column). This migration only
-- adds the gating -- it does not build that admin UI.
--
-- Run after schema_difficulty_tiers.sql (needs the Challenge/Advanced
-- tiers and the current list_questions()/award_medal() to build on top of).
-- Safe to re-run.

-- ---------------------------------------------------------------------------
-- 1. profiles.subscription_tier
-- ---------------------------------------------------------------------------

alter table public.profiles
  add column if not exists subscription_tier text not null default 'free'
  check (subscription_tier in ('free', 'pro'));

-- The existing "profiles are self updatable" RLS policy (schema.sql) lets a
-- student update *any* column on their own row, including this one -- so
-- without a guard, a student could grant themselves Pro for free with a
-- single REST call (`.from('profiles').update({subscription_tier: 'pro'})`),
-- no different from editing display_name. RLS is row-level, not
-- column-level, so the fix is a trigger: block the change specifically when
-- it arrives through a normal authenticated request (auth.uid() is set).
-- Direct SQL run by an admin in the Supabase dashboard executes as the
-- table owner outside PostgREST, where auth.uid() is null, so that path is
-- unaffected -- which is exactly the manual upgrade flow described above.
create or replace function public.guard_subscription_tier()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.subscription_tier is distinct from old.subscription_tier
     and auth.uid() is not null then
    raise exception 'subscription_tier can only be changed by an admin.';
  end if;
  return new;
end;
$$;

drop trigger if exists profiles_guard_subscription_tier on public.profiles;
create trigger profiles_guard_subscription_tier
  before update on public.profiles
  for each row execute function public.guard_subscription_tier();

-- ---------------------------------------------------------------------------
-- 2. list_questions() -- returns every question, but Challenge/Advanced/Hard
--    rows come back with prompt/options stripped for a free student, plus a
--    `locked` flag so the app can still show "N more questions with Pro"
--    without ever sending their content to a browser that isn't paying for
--    it (the same reasoning schema_practice.sql already applies to
--    correct_index and feedback text).
-- ---------------------------------------------------------------------------

create or replace function public.list_questions(
  p_course_code   text,
  p_unit_code     text,
  p_subtopic_code text
)
returns table (sort_order int, difficulty text, prompt text, options jsonb, locked boolean)
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_is_pro boolean;
begin
  select coalesce(
    (select p.subscription_tier = 'pro' from profiles p where p.id = auth.uid()),
    false
  ) into v_is_pro;

  return query
  select q.sort_order,
         q.difficulty,
         case when v_is_pro or q.difficulty not in ('Hard', 'Challenge', 'Advanced')
              then q.prompt end,
         case when v_is_pro or q.difficulty not in ('Hard', 'Challenge', 'Advanced')
              then (
                select jsonb_agg(jsonb_build_object('text', elem ->> 'text') order by ord)
                from jsonb_array_elements(q.options) with ordinality as t(elem, ord)
              )
         end,
         not (v_is_pro or q.difficulty not in ('Hard', 'Challenge', 'Advanced'))
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
end;
$$;

-- ---------------------------------------------------------------------------
-- 3. submit_answer() -- defense in depth. The app never lets a free student
--    tap a locked question (list_questions gave it no content to render),
--    but this closes the gap for a direct RPC call bypassing the UI.
-- ---------------------------------------------------------------------------

create or replace function public.submit_answer(
  p_course_code   text,
  p_unit_code     text,
  p_subtopic_code text,
  p_sort_order    int,
  p_chosen        int
)
returns table (was_correct boolean, was_first boolean, feedback text)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_question  record;
  v_is_pro    boolean;
  v_reset_at  timestamptz;
  v_last_pass timestamptz;
  v_since     timestamptz;
  v_correct   boolean;
  v_first     boolean;
  v_feedback  text;
begin
  if auth.uid() is null then
    raise exception 'Not signed in.';
  end if;

  select q.correct_index, q.options, q.difficulty, q.misconception_tag
    into v_question
  from questions q
  where q.course_code = p_course_code
    and q.unit_code = p_unit_code
    and q.subtopic_code = p_subtopic_code
    and q.sort_order = p_sort_order;

  if not found then
    raise exception 'No such question.';
  end if;

  if p_chosen < 0 or p_chosen > 3 then
    raise exception 'Option out of range.';
  end if;

  select coalesce(
    (select p.subscription_tier = 'pro' from profiles p where p.id = auth.uid()),
    false
  ) into v_is_pro;

  if not v_is_pro and v_question.difficulty in ('Hard', 'Challenge', 'Advanced') then
    raise exception 'This question requires a Pro subscription.';
  end if;

  select r.reset_at into v_reset_at
  from progress_resets r
  where r.student_id = auth.uid() and r.course_code = p_course_code;

  -- When this subtopic was last completed. Finishing one closes a pass, so
  -- anything after that timestamp belongs to a fresh attempt at it.
  select m.updated_at into v_last_pass
  from subtopic_mastery m
  where m.student_id = auth.uid()
    and m.course_code = p_course_code
    and m.unit_code = p_unit_code
    and m.subtopic_code = p_subtopic_code;

  v_since := greatest(v_reset_at, v_last_pass);

  v_correct  := (p_chosen = v_question.correct_index);
  v_feedback := v_question.options -> p_chosen ->> 'feedback';

  v_first := not exists (
    select 1 from attempts a
    where a.student_id = auth.uid()
      and a.course_code = p_course_code
      and a.unit_code = p_unit_code
      and a.subtopic_code = p_subtopic_code
      and a.sort_order = p_sort_order
      and (v_since is null or a.answered_at > v_since)
  );

  insert into attempts (
    student_id, course_code, unit_code, subtopic_code, sort_order, difficulty,
    chosen_index, was_correct, was_first_attempt, misconception_tag
  ) values (
    auth.uid(), p_course_code, p_unit_code, p_subtopic_code, p_sort_order,
    v_question.difficulty, p_chosen, v_correct, v_first,
    case when v_correct then null else v_question.misconception_tag end
  );

  return query select v_correct, v_first, v_feedback;
end;
$$;

-- ---------------------------------------------------------------------------
-- 4. award_medal() -- v_total/v_hard_total (the completion + Gold-gate
--    counts) only count questions a free student can actually reach, so a
--    free student who's answered every Easy/Medium question correctly gets
--    a real medal (Gold included) rather than being permanently stuck at
--    "not finished" by content they're not paying for. For a Pro student,
--    this also folds 'Challenge' into the Gold-medal gate alongside
--    'Hard'/'Advanced' (schema_difficulty_tiers.sql deliberately left
--    Challenge out of that gate, back when it was the one tier everyone
--    could reach regardless of tier). Now that Challenge sits behind the
--    same Pro paywall as Advanced, a Pro student has access to both, so
--    Gold should mean mastering everything they can reach, not just the
--    single hardest tier.
-- ---------------------------------------------------------------------------

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
  v_is_pro     boolean;
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

  select coalesce(
    (select p.subscription_tier = 'pro' from profiles p where p.id = auth.uid()),
    false
  ) into v_is_pro;

  select count(*) filter (
           where v_is_pro or difficulty not in ('Hard', 'Challenge', 'Advanced')
         ),
         count(*) filter (
           where v_is_pro and difficulty in ('Hard', 'Challenge', 'Advanced')
         )
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
           where a.was_correct and a.was_first_attempt and a.difficulty in ('Hard', 'Challenge', 'Advanced')
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
