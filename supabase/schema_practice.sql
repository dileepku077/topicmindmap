-- Astro Math: practice-test schema (questions, attempts, medals).
--
-- Run after schema.sql and seed.sql. Ported from math-tutor
-- (github.com/abhi20sc/math-tutor, by Jithu) — same server-side grading
-- design (no client read access to `questions`, every write goes through a
-- security-definer function), re-keyed from his (grade, unit) pairs to this
-- app's finer-grained (course, unit, subtopic) structure so practice results
-- can drive the mindmap's existing per-subtopic progress colouring.
--
-- ---------------------------------------------------------------------------
-- Why this keys on codes, not the subtopic id
-- ---------------------------------------------------------------------------
-- schema.sql's `courses`/`units`/`subtopics` are DROPPED AND RECREATED on
-- every run — every row is reproducible from seed.sql, so re-running it is
-- treated as a normal thing to do, and every uuid gets reassigned when it
-- happens. seed.sql already relies on this: it upserts everything on the
-- unique `code` columns, never on id.
--
-- His original design worked the same way one level up: `questions` was
-- deleted and reinserted per grade, so `questions.id` churned on every run,
-- and he keyed `attempts` on (grade, unit, sort_order) instead — stable
-- coordinates typed by hand — specifically so a content edit could never
-- silently orphan or cascade-delete a student's history.
--
-- A plain `subtopic_id uuid references subtopics(id)` here would reintroduce
-- exactly that failure mode via schema.sql's own churn instead of his
-- delete-and-reinsert. So `questions`/`attempts`/`progress_resets`/
-- `subtopic_mastery` all key on (course_code, unit_code, subtopic_code) text,
-- matching the natural key seed.sql already treats as the stable one.
--
-- Trade-off, same one he made: these three columns are NOT foreign-keyed to
-- `subtopics` (Postgres can't cleanly FK a three-level composite natural key
-- without denormalizing course_code/unit_code onto `units`/`subtopics`
-- themselves, which is out of scope here). `questions.course_code` alone is
-- FK'd to `courses.code`, since that one's a plain unique column — cheap
-- insurance against a typo'd course. unit_code/subtopic_code are validated by
-- convention: cross-check every row against `subtopics` before inserting
-- (Phase 2's re-tagging script should do this), the same "check before
-- delivering" discipline his README documents for his own question file.

-- ---------------------------------------------------------------------------
-- 0. profiles — add the one column practice tests need
-- ---------------------------------------------------------------------------
-- Nullable: browsing the mindmap never required picking "your" grade, and
-- shouldn't start requiring it now. Only a student who opens a practice test
-- needs this set (Phase 3 can prompt for it then). full_name/email — useful
-- for a teacher roster — are deliberately not added yet; they belong with
-- the teacher dashboard in Phase 5, not here.

alter table public.profiles
  add column if not exists grade int check (grade between 9 and 12);

-- ---------------------------------------------------------------------------
-- 1. questions — the bank
-- ---------------------------------------------------------------------------
-- RLS is on with NO read policy for students, on purpose: correct_index and
-- every option's feedback text live in here, and anything the browser can
-- fetch, a student can read in the network tab before answering. Section 4
-- below provides the only sanctioned way to read this table.

create table if not exists public.questions (
  id            bigint generated always as identity primary key,
  course_code   text   not null references public.courses (code),
  unit_code     text   not null,
  subtopic_code text   not null,
  sort_order    int    not null,   -- order of questions within the subtopic
  difficulty    text   not null check (difficulty in ('Easy', 'Medium', 'Hard')),
  prompt        text   not null,
  correct_index int    not null check (correct_index between 0 and 3),
  options       jsonb  not null,   -- exactly 4: [{"text":..., "feedback":...}, ...]
  -- Short slug naming the mistake this question is built to catch. Recorded
  -- on an attempt only when a wrong option is tapped — see submit_answer.
  misconception_tag text,
  created_at    timestamptz not null default now()
);

create index if not exists questions_subtopic_idx
  on public.questions (course_code, unit_code, subtopic_code, sort_order);

alter table public.questions enable row level security;

-- ---------------------------------------------------------------------------
-- 2. attempts — one row per tap, append only
-- ---------------------------------------------------------------------------
-- The source of truth for everything downstream: scores, medals, resume
-- position, and (Phase 5) parent reports and the teacher dashboard are all
-- derived from this table. Nothing ever updates or deletes a row in it.

create table if not exists public.attempts (
  id                bigint generated always as identity primary key,
  student_id        uuid not null references auth.users (id) on delete cascade,
  course_code       text not null,
  unit_code         text not null,
  subtopic_code     text not null,
  sort_order        int  not null,
  difficulty        text,
  chosen_index      int  not null check (chosen_index between 0 and 3),
  was_correct       boolean not null,
  was_first_attempt boolean not null,
  misconception_tag text,
  answered_at       timestamptz not null default now()
);

-- Resume and per-subtopic scoring read this constantly.
create index if not exists attempts_student_subtopic_idx
  on public.attempts (student_id, course_code, unit_code, subtopic_code, answered_at);

-- A future teacher dashboard (Phase 5) asks "which distractor is the whole
-- class picking", so it reads by question rather than by student.
create index if not exists attempts_question_idx
  on public.attempts (course_code, unit_code, subtopic_code, sort_order, chosen_index);

alter table public.attempts enable row level security;

drop policy if exists "attempts are owner readable" on public.attempts;
create policy "attempts are owner readable"
  on public.attempts for select
  using (auth.uid() = student_id);

-- No insert/update/delete policy for students — every write goes through
-- submit_answer() below, which is what stops a student forging an attempt
-- or a perfect score by calling the REST API directly.

-- ---------------------------------------------------------------------------
-- 3. progress_resets and subtopic_mastery
-- ---------------------------------------------------------------------------

-- The soft reset. Resetting deletes nothing — it records a moment in time,
-- and everything before it stops counting toward score and medals.
--
-- Scoped to the whole COURSE, not a single subtopic, on purpose: a student
-- who had a bad week on one subtopic must not be able to quietly wipe just
-- that one before a parent report while leaving the rest of their history
-- intact. One row per student per course, so resetting MPM2D leaves MCR3U
-- alone.
create table if not exists public.progress_resets (
  student_id  uuid not null references auth.users (id) on delete cascade,
  course_code text not null,
  reset_at    timestamptz not null default now(),
  primary key (student_id, course_code)
);

alter table public.progress_resets enable row level security;

drop policy if exists "resets are owner readable" on public.progress_resets;
create policy "resets are owner readable"
  on public.progress_resets for select
  using (auth.uid() = student_id);

-- The medal cabinet. Everything here could be recomputed from attempts —
-- it's stored anyway so a future teacher dashboard doesn't replay thousands
-- of taps just to draw a list of medals.
--
--   Bronze  every question in the subtopic answered correctly, any # of taps
--   Silver  70%+ correct on the first tap
--   Gold    90%+ on the first tap, AND every Hard question first try
--
-- Bronze rewards finishing rather than perfection on purpose — the app
-- teaches through wrong answers, so the entry tier must never punish a
-- student for tapping one. Medals only ever move upward: a bad rerun can't
-- cost a medal already earned, so replaying a subtopic carries no risk.
create table if not exists public.subtopic_mastery (
  student_id      uuid not null references auth.users (id) on delete cascade,
  course_code     text not null,
  unit_code       text not null,
  subtopic_code   text not null,
  best_first_try  int  not null default 0,
  total_questions int  not null default 0,
  hard_first_try  int  not null default 0,
  hard_total      int  not null default 0,
  medal           text not null default 'None'
                  check (medal in ('None', 'Bronze', 'Silver', 'Gold')),
  times_completed int  not null default 0,
  first_earned_at timestamptz,
  updated_at      timestamptz not null default now(),
  primary key (student_id, course_code, unit_code, subtopic_code)
);

create index if not exists subtopic_mastery_student_idx
  on public.subtopic_mastery (student_id, course_code);

alter table public.subtopic_mastery enable row level security;

drop policy if exists "mastery is owner readable" on public.subtopic_mastery;
create policy "mastery is owner readable"
  on public.subtopic_mastery for select
  using (auth.uid() = student_id);

-- ---------------------------------------------------------------------------
-- 4. Server-side grading
-- ---------------------------------------------------------------------------
-- These run security definer, so they can read `questions` even though
-- students can't. Each hands back the minimum needed:
--
--   list_questions  prompts and option TEXT only — no correct_index, and no
--                   feedback, since a feedback string beginning "Correct."
--                   gives the answer away just as plainly as the index does.
--   submit_answer   takes a tap, returns whether it was right and the
--                   feedback for THAT option, and logs the attempt.
--   award_medal     recomputes the score from attempts and stores the medal.
--   reset_progress  the soft reset, as a function so the app never writes
--                   progress_resets directly.
--
-- Because submit_answer writes the attempt and award_medal recomputes from
-- attempts, a student cannot forge either one — integrity and anti-cheat
-- come from the same design.

-- Questions for one subtopic, stripped of anything that gives away an
-- answer. Ordering is done here rather than in the app — Easy, then Medium,
-- then Hard, sort_order breaking ties — so the ramp can't be skipped by a
-- client that asks differently.
create or replace function public.list_questions(
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
             else 2
           end,
           q.sort_order;
$$;

-- One tap. Grades it, logs it, returns the feedback for that option only.
--
-- was_first_attempt is worked out here, not taken from the app — if the app
-- supplied it, a student could claim every answer was a first try and hand
-- themselves a Gold. The server checks whether this question has already
-- been attempted since the last reset/completion, a fact the student can't
-- edit.
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

  -- The current pass starts at whichever came later. greatest() ignores
  -- nulls, so a student who's never reset or finished this subtopic gets
  -- null, meaning every attempt so far counts.
  v_since := greatest(v_reset_at, v_last_pass);

  v_correct  := (p_chosen = v_question.correct_index);
  v_feedback := v_question.options -> p_chosen ->> 'feedback';

  -- First tap at this question IN THIS PASS. Scoped to the pass rather than
  -- all time since the reset is what makes "try this subtopic again" worth
  -- doing — measured since the reset alone, a question answered once could
  -- never be a first attempt again, so a student stuck on Bronze could only
  -- improve by wiping every subtopic they'd ever done. Because medals only
  -- move upward, a second pass carries no risk.
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
    -- Only a wrong tap represents a misconception — tagging correct answers
    -- would poison every count a future teacher view might show.
    case when v_correct then null else v_question.misconception_tag end
  );

  return query select v_correct, v_first, v_feedback;
end;
$$;

-- Works out the medal for a finished subtopic from the attempts themselves,
-- and stores it only if it beats what's already there.
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

  select count(*), count(*) filter (where difficulty = 'Hard')
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
           where a.was_correct and a.was_first_attempt and a.difficulty = 'Hard'
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

-- The soft reset, as a function so the app never writes progress_resets
-- directly.
create or replace function public.reset_progress(p_course_code text)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'Not signed in.';
  end if;

  insert into progress_resets (student_id, course_code, reset_at)
  values (auth.uid(), p_course_code, now())
  on conflict (student_id, course_code) do update set reset_at = now();
end;
$$;

-- Students may call these; anonymous visitors may not.
revoke all on function public.list_questions(text, text, text)      from public, anon;
revoke all on function public.submit_answer(text, text, text, int, int) from public, anon;
revoke all on function public.award_medal(text, text, text)         from public, anon;
revoke all on function public.reset_progress(text)                  from public, anon;

grant execute on function public.list_questions(text, text, text)      to authenticated;
grant execute on function public.submit_answer(text, text, text, int, int) to authenticated;
grant execute on function public.award_medal(text, text, text)         to authenticated;
grant execute on function public.reset_progress(text)                  to authenticated;

-- ---------------------------------------------------------------------------
-- 5. Retire practice_test_results
-- ---------------------------------------------------------------------------
-- Superseded by attempts + subtopic_mastery above, which carry the same
-- score-percent information plus first-try tracking, medals and resume
-- state that practice_test_results never had. Nothing else in this schema
-- references it, so it's dropped rather than left running alongside a
-- second, thinner copy of the same idea.
drop table if exists public.practice_test_results cascade;
