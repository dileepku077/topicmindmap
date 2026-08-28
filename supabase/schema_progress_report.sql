-- Astro STEM Labs: a per-subtopic "mastery %" for the new Progress Report
-- page (lib/features/progress_report/progress_report_page.dart) — a bar
-- chart with one bar per topic, colored using the same
-- ProgressStatus.fromScorePercent bands already used everywhere else in
-- the app (mindmap nodes, sidebar rows).
--
-- Mastery % here means something specific and different from
-- subtopic_mastery.medal: "what fraction of this topic's difficulty tiers
-- (Easy/Medium/Hard, or Easy/Medium/Challenge/Advanced — however many
-- actually exist for it) has the student fully solved at least once."
-- subtopic_mastery can't answer that on its own — it keeps exactly one row
-- per subtopic, holding only the single best tier pass so far (see
-- schema_tier_medals.sql's own comment on this), not which of several
-- tiers have been cleared. So this reads attempts directly (a student can
-- already read their own rows there — see the "attempts are owner
-- readable" policy in schema_practice.sql) and re-derives per-tier
-- completion the same way award_medal() does: every question in that
-- (course, unit, subtopic, difficulty) answered correctly at least once
-- since the last progress reset, counting only Practice Test attempts
-- (source is null) — a mock Test attempt (source = 'test') must not move
-- this any more than it moves medals or mindmap colors.
--
-- A topic with no questions in the bank yet has no rows here at all;
-- the app treats that the same as "not started" (0%), same simplification
-- subtopic_mastery already makes.
--
-- Run after schema_practice.sql (needs public.questions/attempts/
-- progress_resets) and schema_tier_medals.sql (this mirrors its per-tier
-- completion logic; not a hard dependency, just keep them consistent if
-- either changes). Safe to re-run.

create or replace function public.subtopic_progress_report(p_course_code text)
returns table (
  unit_code text,
  subtopic_code text,
  tiers_total int,
  tiers_completed int,
  mastery_percent numeric
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
      a.unit_code,
      a.subtopic_code,
      a.difficulty,
      count(distinct a.sort_order) as solved_q
    from attempts a
    left join v_reset r on true
    where a.student_id = auth.uid()
      and a.course_code = p_course_code
      and a.was_correct
      and a.source is null
      and (r.reset_at is null or a.answered_at > r.reset_at)
    group by a.unit_code, a.subtopic_code, a.difficulty
  )
  select
    t.unit_code,
    t.subtopic_code,
    count(*)::int as tiers_total,
    count(*) filter (
      where coalesce(s.solved_q, 0) >= t.total_q
    )::int as tiers_completed,
    round(
      100.0 * count(*) filter (where coalesce(s.solved_q, 0) >= t.total_q)
      / count(*),
      1
    ) as mastery_percent
  from tiers t
  left join solved s
    on s.unit_code = t.unit_code
    and s.subtopic_code = t.subtopic_code
    and s.difficulty = t.difficulty
  group by t.unit_code, t.subtopic_code;
$$;

revoke all on function public.subtopic_progress_report(text) from public, anon;
grant execute on function public.subtopic_progress_report(text) to authenticated;
