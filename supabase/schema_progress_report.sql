-- Astro STEM Labs: per-topic, per-difficulty-tier practice completion for
-- the Progress Report page (lib/features/progress_report/
-- progress_report_page.dart) — an overall mastery % bar chart plus four
-- separate charts, one per difficulty (Easy / Medium / Challenge-or-Hard /
-- Advanced), each with one bar per unit.
--
-- This returns one row per (unit, subtopic, difficulty) tier that actually
-- has questions — total/solved question counts, not a pre-aggregated
-- percentage — so the app can roll it up to whatever a given chart needs
-- (overall per unit, or per unit within one difficulty) without another
-- round trip. subtopic_mastery can't answer either of these on its own —
-- it keeps exactly one row per subtopic, holding only the single best
-- tier pass so far (see schema_tier_medals.sql's own comment on this), not
-- which of several tiers have been cleared. So this reads attempts
-- directly (a student can already read their own rows there — see the
-- "attempts are owner readable" policy in schema_practice.sql) and
-- re-derives per-tier completion the same way award_medal() does: every
-- question in that (course, unit, subtopic, difficulty) answered
-- correctly at least once since the last progress reset, counting only
-- Practice Test attempts (source is null) — a mock Test attempt
-- (source = 'test') must not move this any more than it moves medals or
-- mindmap colors.
--
-- IMPORTANT: which tier an attempt counts toward is resolved by joining
-- back to questions on (course_code, unit_code, subtopic_code, sort_order)
-- and reading questions.difficulty fresh, NOT by trusting attempts.
-- difficulty (a label snapshotted once, by submit_answer(), at the moment
-- that attempt was made). schema_difficulty_tiers.sql's own history is
-- exactly why this matters: MPM2D's top tier was retagged from 'Hard' to
-- 'Challenge'/'Advanced' partway through this app's life, via
-- questions_seed.sql deleting and re-inserting MPM2D's rows. A student who
-- practiced that content before the retag has attempts rows permanently
-- stamped 'Hard', even though questions.difficulty for that exact content
-- has said 'Challenge'/'Advanced' ever since — trusting the stamped label
-- would silently zero out real, completed progress on any tier that's
-- ever been relabeled after data collection. Resolving from questions
-- every time is self-healing against that, including for whatever gets
-- relabeled next.
--
-- A topic with no questions in a given tier yet just has no row for it;
-- the app treats that as "not part of this course" for that chart, not as
-- 0%.
--
-- Supersedes subtopic_progress_report() (dropped below), which returned
-- one pre-aggregated row per subtopic across every tier combined — too
-- coarse once the per-difficulty charts needed the tier breakdown too.
--
-- UPDATE: the app itself (progress_repository.dart) no longer calls this
-- function — the student's own solved/total numbers now come straight
-- from topic_progress_report (schema_progress_report_table.sql), a real
-- table kept in sync by award_medal() as students practice, rather than
-- rejoining attempts/questions/progress_resets on every page load. This
-- function is left defined (still correct, unchanged) as a live cross-
-- check if the persisted table's numbers are ever in doubt, and because
-- tier_catalog() below reuses its "tiers" CTE logic. Run after
-- schema_practice.sql (needs public.questions/attempts/progress_resets)
-- and schema_tier_medals.sql (this mirrors its per-tier completion logic;
-- not a hard dependency, just keep them consistent if either changes).
-- Safe to re-run.

drop function if exists public.subtopic_progress_report(text);

create or replace function public.topic_tier_progress(p_course_code text)
returns table (
  unit_code text,
  subtopic_code text,
  difficulty text,
  total_questions int,
  solved_questions int
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
  ),
  tiers as (
    select unit_code, subtopic_code, difficulty, count(*) as total_q
    from questions
    where course_code = p_course_code
    group by unit_code, subtopic_code, difficulty
  ),
  solved as (
    select
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
    left join v_reset r on true
    where a.student_id = auth.uid()
      and a.course_code = p_course_code
      and a.was_correct
      and a.source is null
      and (r.reset_at is null or a.answered_at > r.reset_at)
    group by q.unit_code, q.subtopic_code, q.difficulty
  )
  select
    t.unit_code,
    t.subtopic_code,
    t.difficulty,
    t.total_q as total_questions,
    coalesce(s.solved_q, 0) as solved_questions
  from tiers t
  left join solved s
    on s.unit_code = t.unit_code
    and s.subtopic_code = t.subtopic_code
    and s.difficulty = t.difficulty;
$$;

revoke all on function public.topic_tier_progress(text) from public, anon;
grant execute on function public.topic_tier_progress(text) to authenticated;

-- ---------------------------------------------------------------------------
-- tier_catalog(): just "which (unit, subtopic, difficulty) tiers exist for
-- this course, and how many questions are in each" — no student data at
-- all, purely curriculum structure. A student can't read questions
-- directly (see schema_practice.sql's own reasoning: prompt/options would
-- leak answers), so this is what progress_repository.dart now pairs with
-- topic_progress_report to get a *complete* set of bars, including tiers
-- the student hasn't touched yet (topic_progress_report only ever has a
-- row for a tier once there's been at least one attempt at it) — without
-- it, an untouched unit's bar would be missing entirely instead of
-- reading as 0%. Safe to expose broadly (no prompts/answers/feedback,
-- just counts), but still gated as security definer/authenticated-only
-- rather than a bare public view, same caution as every other student-
-- facing function here.
-- ---------------------------------------------------------------------------

create or replace function public.tier_catalog(p_course_code text)
returns table (
  unit_code text,
  subtopic_code text,
  difficulty text,
  total_questions int
)
language sql
security definer
stable
set search_path = public
as $$
  select unit_code, subtopic_code, difficulty, count(*)::int as total_questions
  from questions
  where course_code = p_course_code
  group by unit_code, subtopic_code, difficulty;
$$;

revoke all on function public.tier_catalog(text) from public, anon;
grant execute on function public.tier_catalog(text) to authenticated;
