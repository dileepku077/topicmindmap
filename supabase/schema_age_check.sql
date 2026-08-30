-- ---------------------------------------------------------------------------
-- Minimum/maximum age at signup
-- ---------------------------------------------------------------------------
-- Astro STEM Labs is built for Ontario high-school students (grades 9-12,
-- roughly ages 14-20). Until now there was no floor at all stopping a much
-- younger child from creating an account, and no data captured to even know
-- an account's age band -- this closes that gap for new sign-ups going
-- forward. lib/features/auth/login_page.dart's email/password form now
-- requires an age between 14 and 20 before it will submit; the check
-- constraint below is the same rule enforced server-side too, in case a
-- request ever reaches the database some other way.
--
-- This only covers new sign-ups. Existing accounts, and accounts created via
-- "Continue with Google" (which has no form step to collect this during the
-- OAuth redirect), are left with age = null rather than retroactively locked
-- out of an app they already had access to.
alter table public.profiles add column if not exists age smallint;

alter table public.profiles drop constraint if exists profiles_age_range;
alter table public.profiles add constraint profiles_age_range
  check (age is null or age between 14 and 20);

-- Re-point handle_new_user() (schema_oauth_signin.sql) at the same metadata
-- key the signup form's `data:` param now also sends, same pattern already
-- used for grade.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  v_grade int := nullif(new.raw_user_meta_data ->> 'grade', '')::int;
  v_age int := nullif(new.raw_user_meta_data ->> 'age', '')::int;
  v_display_name text := coalesce(
    new.raw_user_meta_data ->> 'display_name',
    new.raw_user_meta_data ->> 'full_name',
    new.raw_user_meta_data ->> 'name'
  );
begin
  insert into public.profiles (id, display_name, grade, age)
  values (
    new.id,
    v_display_name,
    case when v_grade between 9 and 12 then v_grade else null end,
    case when v_age between 14 and 20 then v_age else null end
  );
  return new;
end;
$$;
