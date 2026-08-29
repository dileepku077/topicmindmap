-- ---------------------------------------------------------------------------
-- Google sign-in support
-- ---------------------------------------------------------------------------
-- Adding "Continue with Google" (lib/features/auth/login_page.dart) means
-- handle_new_user() (schema_practice.sql) can now fire for an account whose
-- raw_user_meta_data never went through our own signUp() `data:` param at
-- all -- Google's OAuth flow populates that column itself, using its own
-- key names ('full_name'/'name') instead of ours ('display_name'). Without
-- this, a Google sign-up's profiles.display_name comes back null and the
-- classroom greeting / admin student list show a blank name for them.
--
-- Grade has no equivalent fallback -- Google has no concept of it, so a
-- Google sign-up still lands with grade null, same as before this file.
-- lib/features/auth/choose_grade_page.dart is what asks for it afterward.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  v_grade int := nullif(new.raw_user_meta_data ->> 'grade', '')::int;
  v_display_name text := coalesce(
    new.raw_user_meta_data ->> 'display_name',
    new.raw_user_meta_data ->> 'full_name',
    new.raw_user_meta_data ->> 'name'
  );
begin
  insert into public.profiles (id, display_name, grade)
  values (
    new.id,
    v_display_name,
    case when v_grade between 9 and 12 then v_grade else null end
  );
  return new;
end;
$$;
