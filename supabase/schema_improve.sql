-- ---------------------------------------------------------------------------
-- Improve: a targeted drill from a student's own repeated mistakes
-- ---------------------------------------------------------------------------
-- Every wrong tap already tags itself with a misconception_tag
-- (schema_practice.sql's submit_answer) -- this was captured from the start
-- but never read back anywhere. This is that: find the misconceptions a
-- student is CURRENTLY still getting wrong (their latest attempt at each
-- question, not lifetime history -- a mistake they've since fixed shouldn't
-- keep haunting them), then serve questions built to catch exactly those.
--
-- Reuses submit_answer/award_medal as-is for grading -- an Improve question
-- is a completely ordinary row in `questions`, addressed by its own real
-- (course, unit, subtopic, sort_order), so answering it here counts toward
-- that subtopic's own medal and mastery numbers too, not a separate,
-- throwaway score.
create or replace function public.improve_questions(
  p_course_code text,
  p_limit int default 12
)
returns table (
  unit_code text,
  subtopic_code text,
  sort_order int,
  difficulty text,
  prompt text,
  options jsonb,
  misconception_tag text
)
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_is_pro boolean;
begin
  if auth.uid() is null then
    raise exception 'Not signed in.';
  end if;

  select coalesce(
    (select p.subscription_tier = 'pro' from profiles p where p.id = auth.uid()),
    false
  ) into v_is_pro;

  return query
  with reset_at as (
    select r.reset_at from progress_resets r
    where r.student_id = auth.uid() and r.course_code = p_course_code
  ),
  -- One row per question this student has ever attempted in this course,
  -- keeping only their most recent tap at it.
  latest_attempt as (
    select distinct on (a.unit_code, a.subtopic_code, a.sort_order)
           a.unit_code, a.subtopic_code, a.sort_order,
           a.was_correct, a.misconception_tag
    from attempts a
    where a.student_id = auth.uid()
      and a.course_code = p_course_code
      and (
        not exists (select 1 from reset_at)
        or a.answered_at > (select reset_at from reset_at)
      )
    order by a.unit_code, a.subtopic_code, a.sort_order, a.answered_at desc
  ),
  -- The misconceptions still live right now -- wrong on the latest tap,
  -- not just wrong at some point -- ranked by how often they recur.
  weak_tags as (
    select misconception_tag, count(*) as miss_count
    from latest_attempt
    where was_correct = false and misconception_tag is not null
    group by misconception_tag
    order by miss_count desc
    limit 5
  )
  select q.unit_code,
         q.subtopic_code,
         q.sort_order,
         q.difficulty,
         q.prompt,
         (
           select jsonb_agg(jsonb_build_object('text', elem ->> 'text') order by ord)
           from jsonb_array_elements(q.options) with ordinality as t(elem, ord)
         ) as options,
         q.misconception_tag
  from questions q
  join weak_tags w on w.misconception_tag = q.misconception_tag
  where q.course_code = p_course_code
    -- Same Free/Pro gate as list_questions -- Improve shouldn't hand a free
    -- student prompt/option text for a tier they haven't unlocked.
    and (v_is_pro or q.difficulty not in ('Hard', 'Challenge', 'Advanced'))
  order by random()
  limit p_limit;
end;
$$;

revoke all on function public.improve_questions(text, int) from public, anon;
grant execute on function public.improve_questions(text, int) to authenticated;
