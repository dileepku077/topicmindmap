-- Astro STEM Labs: Test — a graded mock test covering a whole unit, with
-- no feedback until the paper is handed in.
--
-- Ported from math-tutor's Test section (github.com/abhi20sc/math-tutor,
-- astro_sections.sql, by Jithu) — same design, re-keyed from his
-- (course, unit) + misconception_tag grain onto this app's (course_code,
-- unit_code, subtopic_code) structure, the same re-keying
-- schema_practice.sql already did when it ported his Quiz section.
--
-- WHY THIS IS A SEPARATE FEATURE FROM PRACTICE TEST, NOT A MODE OF IT
--
-- practice_test_page.dart is scoped to one subtopic and one difficulty
-- tier, and teaches in the moment: a wrong tap names the mistake
-- immediately and the student tries again until they get it right. That
-- is exactly wrong for a mock test — a score only means something if
-- nothing after question 1 changes how question 1 gets answered. So a
-- unit test pulls one paper across every subtopic in the unit, records
-- exactly one answer per question (right or wrong, no retry), and holds
-- every verdict back until the whole paper is finished.
--
-- WHAT A FINISHED TEST WRITES TO attempts, AND WHY IT MATTERS
--
-- finish_unit_test() inserts one attempts row per answered item, always
-- with was_first_attempt = false, tagged source = 'test'. That
-- combination is deliberate, straight from his original reasoning:
--
--   * medals and mindmap colours stay clean. award_medal() and every
--     progress% in this app are computed from Practice Test's own
--     was_first_attempt rows for one specific (unit, subtopic,
--     difficulty) tier; a unit test answer must never silently move
--     them, since a mock test spans many tiers at once and was never
--     "first-tried" in that sense to begin with.
--   * the history still exists. attempts is this app's append-only
--     source of truth for everything downstream (see schema_practice.sql)
--     — a wrong answer on a test is still a real data point, just one
--     that doesn't feed the same first-try signal Practice Test does.
--
-- Run after schema.sql, schema_practice.sql, and schema_subscriptions.sql
-- (needs public.questions/attempts and subscription_tier gating already
-- in place). Safe to re-run.

-- ---------------------------------------------------------------------------
-- 1. attempts.source — distinguishes a Practice Test row from a Test row.
--    Nullable so every existing row (all of them Practice Test) reads as
--    the default without a backfill.
-- ---------------------------------------------------------------------------

alter table public.attempts add column if not exists source text;

comment on column public.attempts.source is
  'Null for Practice Test, ''test'' for a graded unit test (see '
  'schema_unit_tests.sql). award_medal() and every progress%/mindmap '
  'colour in this app read was_first_attempt on Practice Test''s own '
  'rows; a unit test''s rows are always was_first_attempt = false so '
  'they never move those numbers.';

-- ---------------------------------------------------------------------------
-- 2. unit_tests / unit_test_items
-- ---------------------------------------------------------------------------
-- The paper is fixed the moment the test starts and stored here, not
-- re-drawn on every fetch: a reload must not reshuffle the questions, an
-- abandoned test must be resumable, and the score must come from what was
-- actually asked rather than from whatever the client claims was asked.

create table if not exists public.unit_tests (
  id           bigint generated always as identity primary key,
  student_id   uuid not null references auth.users (id) on delete cascade,
  course_code  text not null references public.courses (code),
  unit_code    text not null,
  is_warmup    boolean not null default false,
  total        int  not null check (total > 0),
  answered     int  not null default 0,
  correct      int  not null default 0,
  score_pct    int,
  started_at   timestamptz not null default now(),
  finished_at  timestamptz,
  abandoned    boolean not null default false
);

create index if not exists unit_tests_student_idx
  on public.unit_tests (student_id, course_code, unit_code, finished_at desc nulls last);

alter table public.unit_tests enable row level security;
drop policy if exists "unit tests are owner readable" on public.unit_tests;
create policy "unit tests are owner readable"
  on public.unit_tests for select
  using (auth.uid() = student_id);

-- No insert/update/delete policy for students — every write goes through
-- the security-definer functions below, same reasoning as `attempts`.

create table if not exists public.unit_test_items (
  test_id       bigint not null references public.unit_tests (id) on delete cascade,
  item_no       int    not null,
  subtopic_code text   not null,
  sort_order    int    not null,
  difficulty    text   not null,
  misconception_tag text,
  chosen_index  int,
  was_correct   boolean,
  answered_at   timestamptz,
  primary key (test_id, item_no)
);

-- RLS on, no policy at all — the same treatment `questions` gets. Nothing
-- reads this table directly; unit_test_paper() hands out the four option
-- texts and nothing else, and only for a test the caller owns.
alter table public.unit_test_items enable row level security;

-- ---------------------------------------------------------------------------
-- 3. start_unit_test — resume an in-progress paper, or draw a fresh one.
-- ---------------------------------------------------------------------------
-- Free accounts get a 10-question warm-up over Easy/Medium only, matching
-- the same subscription_tier gate list_questions()/submit_answer() already
-- enforce (schema_subscriptions.sql) — a test can never become a side
-- door into Challenge/Hard/Advanced content a free account hasn't paid
-- for. Pro accounts get a 15-question paper across every tier the unit
-- has. Either way: one question from every subtopic in the unit wins a
-- slot first, so no subtopic can be missed entirely by chance, then the
-- remaining slots fill at random from what's left — and a thinner unit
-- than the target length shortens the paper rather than failing.

create or replace function public.start_unit_test(
  p_course_code text,
  p_unit_code   text
)
returns table (test_id bigint, total int, is_warmup boolean, resumed boolean)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_is_pro boolean;
  v_want   int;
  v_warmup boolean;
  v_test   bigint;
  v_count  int;
begin
  if auth.uid() is null then
    raise exception 'Not signed in.';
  end if;
  if not exists (
    select 1 from questions
    where course_code = p_course_code and unit_code = p_unit_code
  ) then
    raise exception 'No such unit.';
  end if;

  -- Resume rather than start again. A student who reloads mid-test, or
  -- whose phone sleeps, comes back to the same paper with their answers
  -- intact.
  select t.id into v_test
  from unit_tests t
  where t.student_id = auth.uid()
    and t.course_code = p_course_code and t.unit_code = p_unit_code
    and t.finished_at is null and not t.abandoned
  order by t.started_at desc
  limit 1;

  if v_test is not null then
    return query
      select t.id, t.total, t.is_warmup, true
      from unit_tests t where t.id = v_test;
    return;
  end if;

  select coalesce(
    (select p.subscription_tier = 'pro' from profiles p where p.id = auth.uid()),
    false
  ) into v_is_pro;

  v_warmup := not v_is_pro;
  v_want   := case when v_is_pro then 15 else 10 end;

  insert into unit_tests (student_id, course_code, unit_code, is_warmup, total)
  values (auth.uid(), p_course_code, p_unit_code, v_warmup, v_want)
  returning id into v_test;

  insert into unit_test_items (test_id, item_no, subtopic_code, sort_order,
                               difficulty, misconception_tag)
  select v_test,
         row_number() over (
           order by case p.difficulty
                      when 'Easy'      then 0
                      when 'Medium'    then 1
                      when 'Challenge' then 2
                      when 'Hard'      then 2
                      when 'Advanced'  then 3
                      else 4 end,
                    p.pick_order),
         p.subtopic_code, p.sort_order, p.difficulty, p.misconception_tag
  from (
    select c.subtopic_code, c.sort_order, c.difficulty, c.misconception_tag,
           c.pick_order
    from (
      select q.subtopic_code,
             q.sort_order,
             q.difficulty,
             q.misconception_tag,
             row_number() over (
               partition by q.subtopic_code order by random()
             ) as rn_in_subtopic,
             random() as pick_order
      from questions q
      where q.course_code = p_course_code
        and q.unit_code = p_unit_code
        and (v_is_pro or q.difficulty not in ('Hard', 'Challenge', 'Advanced'))
    ) c
    -- One per subtopic wins a slot outright; everything else queues behind.
    order by (c.rn_in_subtopic > 1), c.pick_order
    limit v_want
  ) p;

  get diagnostics v_count = row_count;

  -- A unit with fewer questions available than the target (only possible
  -- on a warm-up over a thin unit) shortens the paper rather than failing.
  update unit_tests set total = v_count where id = v_test;

  return query select v_test, v_count, v_warmup, false;
end;
$$;

-- ---------------------------------------------------------------------------
-- 4. unit_test_paper — the questions, and nothing else.
-- ---------------------------------------------------------------------------
-- Same option-stripping list_questions() already does: four texts, no
-- correct_index, no feedback. chosen_index comes back so a resumed test
-- redraws what was already ticked, but was_correct is withheld until the
-- paper is finished.

create or replace function public.unit_test_paper(p_test bigint)
returns table (
  item_no       int,
  subtopic_code text,
  sort_order    int,
  difficulty    text,
  prompt        text,
  options       jsonb,
  chosen_index  int
)
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_course text;
begin
  select t.course_code into v_course
  from unit_tests t
  where t.id = p_test and t.student_id = auth.uid();

  if v_course is null then
    raise exception 'No such test.';
  end if;

  return query
  select i.item_no, i.subtopic_code, i.sort_order, i.difficulty, q.prompt,
         (
           select jsonb_agg(jsonb_build_object('text', elem ->> 'text') order by ord)
           from jsonb_array_elements(q.options) with ordinality as t(elem, ord)
         ),
         i.chosen_index
  from unit_test_items i
  join questions q
    on q.course_code = v_course and q.subtopic_code = i.subtopic_code
   and q.sort_order = i.sort_order and q.difficulty = i.difficulty
  where i.test_id = p_test
  order by i.item_no;
end;
$$;

-- ---------------------------------------------------------------------------
-- 5. answer_unit_test_item — records a choice, returns nothing.
-- ---------------------------------------------------------------------------
-- The silence is the point. submit_answer() (Practice Test) returns
-- was_correct and feedback because Practice Test is meant to teach in the
-- moment; returning either here would let a student read the result off
-- the network tab mid-paper and the score would stop meaning anything.

create or replace function public.answer_unit_test_item(
  p_test    bigint,
  p_item_no int,
  p_chosen  int
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_course  text;
  v_correct int;
  v_item    record;
begin
  if p_chosen is not null and (p_chosen < 0 or p_chosen > 3) then
    raise exception 'Option out of range.';
  end if;

  select t.course_code into v_course
  from unit_tests t
  where t.id = p_test and t.student_id = auth.uid()
    and t.finished_at is null and not t.abandoned;

  if v_course is null then
    raise exception 'No such test, or it is already finished.';
  end if;

  select * into v_item from unit_test_items i
  where i.test_id = p_test and i.item_no = p_item_no;
  if not found then
    raise exception 'No such question on this paper.';
  end if;

  select q.correct_index into v_correct
  from questions q
  where q.course_code = v_course and q.subtopic_code = v_item.subtopic_code
    and q.sort_order = v_item.sort_order and q.difficulty = v_item.difficulty;

  update unit_test_items
     set chosen_index = p_chosen,
         was_correct  = (p_chosen = v_correct),
         answered_at  = now()
   where test_id = p_test and item_no = p_item_no;

  update unit_tests t
     set answered = (
           select count(*) from unit_test_items i
           where i.test_id = p_test and i.chosen_index is not null
         )
   where t.id = p_test;
end;
$$;

-- ---------------------------------------------------------------------------
-- 6. finish_unit_test — score it, and only now let the results out.
-- ---------------------------------------------------------------------------

create or replace function public.finish_unit_test(p_test bigint)
returns table (score_pct int, correct int, total int, is_warmup boolean, seconds int)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_t       record;
  v_correct int;
begin
  select * into v_t from unit_tests t
  where t.id = p_test and t.student_id = auth.uid();
  if not found then
    raise exception 'No such test.';
  end if;

  if v_t.finished_at is null then
    select count(*) filter (where i.was_correct) into v_correct
    from unit_test_items i where i.test_id = p_test;

    insert into attempts (
      student_id, course_code, unit_code, subtopic_code, sort_order,
      difficulty, chosen_index, was_correct, was_first_attempt,
      misconception_tag, source
    )
    select auth.uid(), v_t.course_code, v_t.unit_code, i.subtopic_code,
           i.sort_order, i.difficulty, i.chosen_index,
           coalesce(i.was_correct, false),
           false,
           case when coalesce(i.was_correct, false) then null else i.misconception_tag end,
           'test'
    from unit_test_items i
    where i.test_id = p_test and i.chosen_index is not null;

    update unit_tests
       set finished_at = now(),
           correct     = v_correct,
           score_pct   = round(100.0 * v_correct / nullif(v_t.total, 0))::int
     where id = p_test;
  end if;

  return query
    select t.score_pct, t.correct, t.total, t.is_warmup,
           greatest(0, extract(epoch from (t.finished_at - t.started_at))::int)
    from unit_tests t where t.id = p_test;
end;
$$;

-- ---------------------------------------------------------------------------
-- 7. unit_test_result — the per-subtopic breakdown, once the paper is
--    closed.
-- ---------------------------------------------------------------------------

create or replace function public.unit_test_result(p_test bigint)
returns table (
  subtopic_code text,
  asked         int,
  got           int,
  pct           int
)
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_found boolean;
begin
  select true into v_found from unit_tests t
  where t.id = p_test and t.student_id = auth.uid() and t.finished_at is not null;
  if not v_found then
    raise exception 'No such finished test.';
  end if;

  return query
  select i.subtopic_code,
         count(*)::int,
         count(*) filter (where i.was_correct)::int,
         round(100.0 * count(*) filter (where i.was_correct) / count(*))::int
  from unit_test_items i
  where i.test_id = p_test
  group by i.subtopic_code
  order by 4, 2 desc;
end;
$$;

-- ---------------------------------------------------------------------------
-- 8. unit_test_item_review — what was actually wrong, once the paper is
--    closed. Feedback appears here and nowhere earlier: the same string
--    Practice Test would have shown at the moment of the tap, just held
--    back until holding it back no longer changes the score.
-- ---------------------------------------------------------------------------

create or replace function public.unit_test_item_review(p_test bigint)
returns table (
  item_no       int,
  subtopic_code text,
  difficulty    text,
  prompt        text,
  chosen_text   text,
  was_correct   boolean,
  feedback      text
)
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_course text;
begin
  select t.course_code into v_course from unit_tests t
  where t.id = p_test and t.student_id = auth.uid() and t.finished_at is not null;
  if v_course is null then
    raise exception 'No such finished test.';
  end if;

  return query
  select i.item_no,
         i.subtopic_code,
         i.difficulty,
         q.prompt,
         q.options -> i.chosen_index ->> 'text',
         coalesce(i.was_correct, false),
         case when coalesce(i.was_correct, false) then null
              else q.options -> i.chosen_index ->> 'feedback' end
  from unit_test_items i
  join questions q
    on q.course_code = v_course and q.subtopic_code = i.subtopic_code
   and q.sort_order = i.sort_order and q.difficulty = i.difficulty
  where i.test_id = p_test
  order by i.item_no;
end;
$$;

-- ---------------------------------------------------------------------------
-- 9. abandon_unit_test — a way out that is not a zero.
-- ---------------------------------------------------------------------------

create or replace function public.abandon_unit_test(p_test bigint)
returns void
language sql
security definer
set search_path = public
as $$
  update unit_tests set abandoned = true
  where id = p_test and student_id = auth.uid() and finished_at is null;
$$;

-- ---------------------------------------------------------------------------
-- 10. unit_test_history — every paper already sat on this unit.
-- ---------------------------------------------------------------------------

create or replace function public.unit_test_history(
  p_course_code text,
  p_unit_code   text
)
returns table (
  test_id     bigint,
  score_pct   int,
  correct     int,
  total       int,
  is_warmup   boolean,
  seconds     int,
  finished_at timestamptz
)
language sql
security definer
stable
set search_path = public
as $$
  select t.id, t.score_pct, t.correct, t.total, t.is_warmup,
         greatest(0, extract(epoch from (t.finished_at - t.started_at))::int),
         t.finished_at
  from unit_tests t
  where t.student_id = auth.uid()
    and t.course_code = p_course_code
    and t.unit_code = p_unit_code
    and t.finished_at is not null
    and not t.abandoned
  order by t.finished_at desc
  limit 20;
$$;

revoke all on function public.start_unit_test(text, text)         from public, anon;
revoke all on function public.unit_test_paper(bigint)              from public, anon;
revoke all on function public.answer_unit_test_item(bigint,int,int) from public, anon;
revoke all on function public.finish_unit_test(bigint)             from public, anon;
revoke all on function public.unit_test_result(bigint)             from public, anon;
revoke all on function public.unit_test_item_review(bigint)        from public, anon;
revoke all on function public.abandon_unit_test(bigint)            from public, anon;
revoke all on function public.unit_test_history(text, text)        from public, anon;

grant execute on function public.start_unit_test(text, text)          to authenticated;
grant execute on function public.unit_test_paper(bigint)              to authenticated;
grant execute on function public.answer_unit_test_item(bigint,int,int) to authenticated;
grant execute on function public.finish_unit_test(bigint)             to authenticated;
grant execute on function public.unit_test_result(bigint)             to authenticated;
grant execute on function public.unit_test_item_review(bigint)        to authenticated;
grant execute on function public.abandon_unit_test(bigint)            to authenticated;
grant execute on function public.unit_test_history(text, text)        to authenticated;
