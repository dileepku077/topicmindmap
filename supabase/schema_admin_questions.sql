-- Astro STEM Labs: admin question-bank editing -- lets an admin fix a
-- typo'd prompt, distractor, feedback string, or correct answer through the
-- admin UI instead of hand-editing raw JSONB in the Supabase table editor.
--
-- Same "narrow RPC, not a wide table grant" philosophy as schema_admin.sql:
-- `questions` has no client read/write policy at all (see the section 1
-- comment in schema_practice.sql -- a student must never be able to read
-- correct_index or feedback text off the network tab), so both functions
-- below run security definer and re-check is_admin(auth.uid()) themselves
-- rather than relying on a broadened RLS policy.
--
-- Run after schema_practice.sql, schema_difficulty_tiers.sql, and
-- schema_admin.sql (needs is_admin()). Safe to re-run.

-- ---------------------------------------------------------------------------
-- 1. admin_list_questions() -- unredacted rows (prompt, options WITH their
--    feedback text, correct_index) for the admin question browser. Ordered
--    the same way list_questions() orders a student's own questions, so
--    paging next/previous here lines up with the order a student sees them
--    in. p_difficulty is optional -- null returns every difficulty for the
--    subtopic, in case the admin UI ever wants that.
-- ---------------------------------------------------------------------------

create or replace function public.admin_list_questions(
  p_course_code   text,
  p_unit_code     text,
  p_subtopic_code text,
  p_difficulty    text default null
)
returns table (
  id                bigint,
  sort_order        int,
  difficulty        text,
  prompt            text,
  correct_index     int,
  options           jsonb,
  misconception_tag text
)
language plpgsql
security definer
stable
set search_path = public
as $$
begin
  if not is_admin(auth.uid()) then
    raise exception 'Admin access required.';
  end if;

  return query
  select q.id, q.sort_order, q.difficulty, q.prompt, q.correct_index,
         q.options, q.misconception_tag
  from questions q
  where q.course_code = p_course_code
    and q.unit_code = p_unit_code
    and q.subtopic_code = p_subtopic_code
    and (p_difficulty is null or q.difficulty = p_difficulty)
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

revoke all on function public.admin_list_questions(text, text, text, text) from public, anon;
grant execute on function public.admin_list_questions(text, text, text, text) to authenticated;

-- ---------------------------------------------------------------------------
-- 2. admin_update_question() -- the prompt, all 4 options (text + feedback
--    each), the correct answer, and the misconception tag. Difficulty,
--    course/unit/subtopic, and sort_order are deliberately not editable
--    here -- moving a question to a different tier/topic is a re-seed
--    decision, not a correction, and doing it through this narrow RPC
--    would risk silently breaking the tier ordering list_questions() and
--    the mastery calculator both depend on.
-- ---------------------------------------------------------------------------

create or replace function public.admin_update_question(
  p_question_id       bigint,
  p_prompt             text,
  p_options            jsonb,
  p_correct_index      int,
  p_misconception_tag  text default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_option jsonb;
begin
  if not is_admin(auth.uid()) then
    raise exception 'Admin access required.';
  end if;
  if p_prompt is null or length(trim(p_prompt)) = 0 then
    raise exception 'Prompt cannot be empty.';
  end if;
  if p_correct_index is null or p_correct_index not between 0 and 3 then
    raise exception 'correct_index must be between 0 and 3.';
  end if;
  if jsonb_typeof(p_options) is distinct from 'array'
     or jsonb_array_length(p_options) != 4 then
    raise exception 'options must be an array of exactly 4 items.';
  end if;
  for v_option in select * from jsonb_array_elements(p_options) loop
    if coalesce(length(trim(v_option ->> 'text')), 0) = 0 then
      raise exception 'Every option needs answer text.';
    end if;
    if coalesce(length(trim(v_option ->> 'feedback')), 0) = 0 then
      raise exception 'Every option needs feedback text.';
    end if;
  end loop;

  update questions
  set prompt = p_prompt,
      options = p_options,
      correct_index = p_correct_index,
      misconception_tag = p_misconception_tag
  where id = p_question_id;

  if not found then
    raise exception 'No such question.';
  end if;
end;
$$;

revoke all on function public.admin_update_question(bigint, text, jsonb, int, text) from public, anon;
grant execute on function public.admin_update_question(bigint, text, jsonb, int, text) to authenticated;
