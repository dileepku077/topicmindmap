-- Astro STEM Labs: lets the Progress Report page scope itself to a time
-- window (All time / Last 7 days / Last 30 days / a custom calendar range)
-- instead of always reporting on a student's whole history.
--
-- Redefines subtopic_attempt_stats() from schema_mastery_rework.sql with
-- two new optional bounds, p_since/p_until -- both null (the only way it
-- was ever called before this file) reproduces the exact old behavior, so
-- this is purely additive: no existing caller needs to change to keep
-- working. The soft-reset filter (a.answered_at > r.reset_at) still
-- applies underneath any range the caller asks for, same as before --
-- reported time windows can only narrow what a reset already excluded,
-- never see past it.
--
-- Run after schema_mastery_rework.sql. Safe to re-run.
--
-- Drops the old 1-argument signature first rather than just adding this
-- one alongside it: Postgres treats a different parameter LIST (even
-- adding only-defaulted params) as a distinct overload, not a
-- replacement, and having both around at once would leave a
-- p_course_code-only RPC call ambiguous between them ("function is not
-- unique").

drop function if exists public.subtopic_attempt_stats(text);

create or replace function public.subtopic_attempt_stats(
  p_course_code text,
  p_since       timestamptz default null,
  p_until       timestamptz default null
)
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
    and (p_since is null or a.answered_at >= p_since)
    and (p_until is null or a.answered_at <= p_until)
  group by a.unit_code, a.subtopic_code, a.difficulty;
$$;

revoke all on function public.subtopic_attempt_stats(text, timestamptz, timestamptz) from public, anon;
grant execute on function public.subtopic_attempt_stats(text, timestamptz, timestamptz) to authenticated;
