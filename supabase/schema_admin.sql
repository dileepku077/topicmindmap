-- Astro STEM Labs: admin access -- a small set of staff accounts that can
-- manage student profiles (grade, subscription tier, password, deletion)
-- through a UI instead of the Supabase SQL editor.
--
-- Every admin action below is its own narrow, purpose-built RPC that
-- re-checks is_admin(auth.uid()) itself, rather than a broadened RLS
-- policy on profiles -- same "narrow RPC, not a wide table grant"
-- philosophy schema_practice.sql already uses for questions (a student
-- can't read correct_index off the network tab; an admin session can't
-- bulk-read every profile column just because is_admin happens to be
-- true). None of these touch a service-role key, which must never ship
-- to a Flutter web client -- the password reset instead writes
-- auth.users.encrypted_password directly with the same crypt()/
-- gen_salt('bf') hashing Supabase Auth itself uses, the same trick
-- seed.sql's demo accounts already rely on. That only works because
-- these functions are `security definer`, executing with the privileges
-- of whichever role runs this file in the SQL editor (normally the
-- project-owner/postgres role, which already has write access to
-- auth.users -- seed.sql inserts into it directly).
--
-- Run after schema.sql, schema_practice.sql, schema_preferences.sql, and
-- schema_subscriptions.sql (needs profiles.grade/default_view/
-- subscription_tier already in place). Safe to re-run.

-- ---------------------------------------------------------------------------
-- 1. profiles.is_admin
-- ---------------------------------------------------------------------------

alter table public.profiles
  add column if not exists is_admin boolean not null default false;

-- Same reasoning as guard_subscription_tier() in schema_subscriptions.sql:
-- "profiles are self updatable" would otherwise let a student grant
-- themselves admin with one REST call. Direct SQL run by an admin in the
-- Supabase dashboard is unaffected (auth.uid() is null there); an admin
-- acting through a future admin RPC (none exists yet, but this mirrors
-- the equivalent fix to guard_subscription_tier() below in case one
-- ever does) is also let through -- is_admin() is defined further down
-- this file, but that's fine, function bodies only resolve names at
-- call time, not at CREATE time.
create or replace function public.guard_is_admin()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.is_admin is distinct from old.is_admin
     and auth.uid() is not null
     and not is_admin(auth.uid()) then
    raise exception 'is_admin can only be changed by an admin.';
  end if;
  return new;
end;
$$;

drop trigger if exists profiles_guard_is_admin on public.profiles;
create trigger profiles_guard_is_admin
  before update on public.profiles
  for each row execute function public.guard_is_admin();

-- ---------------------------------------------------------------------------
-- 2. is_admin() -- the check every admin RPC below re-runs itself,
--    server-side, rather than trusting a client-supplied flag.
-- ---------------------------------------------------------------------------

create or replace function public.is_admin(p_user_id uuid)
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select coalesce((select p.is_admin from profiles p where p.id = p_user_id), false);
$$;

revoke all on function public.is_admin(uuid) from public, anon;
grant execute on function public.is_admin(uuid) to authenticated;

-- schema_subscriptions.sql's guard_subscription_tier() blocked a
-- subscription_tier change whenever auth.uid() was not null -- back when
-- the only legitimate way to flip it was a direct SQL-editor session
-- (auth.uid() null there). admin_update_student() below is a real,
-- vetted, authenticated path to change it now, and it was getting
-- rejected by this exact trigger (the admin's own auth.uid() is very
-- much not null). Redefined here to let an admin session through too --
-- still blocks a student changing their own tier, since that's the
-- actual thing this trigger exists to prevent.
create or replace function public.guard_subscription_tier()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.subscription_tier is distinct from old.subscription_tier
     and auth.uid() is not null
     and not is_admin(auth.uid()) then
    raise exception 'subscription_tier can only be changed by an admin.';
  end if;
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- 3. admin_list_students() -- every student's profile plus their email
--    (profiles has no email column of its own -- auth.users does). Admin
--    accounts are excluded: this manages *students*, and it keeps an
--    admin from resetting another admin's password or deleting their
--    account through this same list (each mutating RPC below re-checks
--    this independently too, in case that ever changes).
-- ---------------------------------------------------------------------------

create or replace function public.admin_list_students()
returns table (
  id uuid,
  email text,
  display_name text,
  grade int,
  subscription_tier text,
  created_at timestamptz
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
  select p.id, u.email::text, p.display_name, p.grade, p.subscription_tier,
         p.created_at
  from profiles p
  join auth.users u on u.id = p.id
  where not p.is_admin
  order by u.email;
end;
$$;

revoke all on function public.admin_list_students() from public, anon;
grant execute on function public.admin_list_students() to authenticated;

-- ---------------------------------------------------------------------------
-- 4. admin_update_student() -- grade / subscription tier / display name.
--    Every param is optional (null = leave unchanged) so the UI can send
--    just the one field it's editing.
-- ---------------------------------------------------------------------------

create or replace function public.admin_update_student(
  p_student_id uuid,
  p_grade int default null,
  p_subscription_tier text default null,
  p_display_name text default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not is_admin(auth.uid()) then
    raise exception 'Admin access required.';
  end if;
  if is_admin(p_student_id) then
    raise exception 'Cannot edit an admin account from here.';
  end if;
  if p_subscription_tier is not null and p_subscription_tier not in ('free', 'pro') then
    raise exception 'subscription_tier must be ''free'' or ''pro''.';
  end if;
  if p_grade is not null and p_grade not between 9 and 12 then
    raise exception 'grade must be between 9 and 12.';
  end if;

  update profiles
  set grade = coalesce(p_grade, grade),
      subscription_tier = coalesce(p_subscription_tier, subscription_tier),
      display_name = coalesce(p_display_name, display_name)
  where id = p_student_id;

  if not found then
    raise exception 'No such student.';
  end if;
end;
$$;

revoke all on function public.admin_update_student(uuid, int, text, text) from public, anon;
grant execute on function public.admin_update_student(uuid, int, text, text) to authenticated;

-- ---------------------------------------------------------------------------
-- 5. admin_reset_student_password() -- see the file header for why this
--    writes auth.users directly instead of calling a service-role admin
--    API.
-- ---------------------------------------------------------------------------

create or replace function public.admin_reset_student_password(
  p_student_id uuid,
  p_new_password text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not is_admin(auth.uid()) then
    raise exception 'Admin access required.';
  end if;
  if is_admin(p_student_id) then
    raise exception 'Cannot reset an admin account''s password from here.';
  end if;
  if length(p_new_password) < 6 then
    raise exception 'Password must be at least 6 characters.';
  end if;

  update auth.users
  set encrypted_password = crypt(p_new_password, gen_salt('bf')),
      updated_at = now()
  where id = p_student_id;

  if not found then
    raise exception 'No such student.';
  end if;
end;
$$;

revoke all on function public.admin_reset_student_password(uuid, text) from public, anon;
grant execute on function public.admin_reset_student_password(uuid, text) to authenticated;

-- ---------------------------------------------------------------------------
-- 6. admin_delete_student() -- deletes the auth.users row; profiles,
--    subtopic_mastery, attempts, and progress_resets all cascade via the
--    on-delete-cascade FKs schema.sql/schema_practice.sql already declare.
--    Irreversible -- the Flutter UI confirms before calling this, but the
--    RPC itself doesn't (and shouldn't) trust that confirmation happened.
-- ---------------------------------------------------------------------------

create or replace function public.admin_delete_student(p_student_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not is_admin(auth.uid()) then
    raise exception 'Admin access required.';
  end if;
  if is_admin(p_student_id) then
    raise exception 'Cannot delete an admin account from here.';
  end if;

  delete from auth.users where id = p_student_id;

  if not found then
    raise exception 'No such student.';
  end if;
end;
$$;

revoke all on function public.admin_delete_student(uuid) from public, anon;
grant execute on function public.admin_delete_student(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- 7. The admin account itself.
-- ---------------------------------------------------------------------------
-- WARNING: same local-dev trick seed.sql's demo accounts use -- inserting
-- directly into auth.users/auth.identities. 'abc123' matches the demo
-- accounts' throwaway password on purpose (this is a dev/staging seed,
-- not a production credential) -- change it from the admin UI itself
-- (once signed in, resetting your own password is a normal Supabase
-- auth.updateUser call, no admin RPC needed) before this project is
-- exposed to real students.

with admin_user (id, email, display_name) as (
  values (
    '99999999-9999-9999-9999-999999999999'::uuid,
    'stemlabs.ca@gmail.com',
    'Astro STEM Labs Admin'
  )
)
insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password,
  email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
  created_at, updated_at, confirmation_token, recovery_token,
  email_change_token_new, email_change
)
select
  '00000000-0000-0000-0000-000000000000', a.id, 'authenticated', 'authenticated', a.email,
  crypt('abc123', gen_salt('bf')),
  now(), '{"provider":"email","providers":["email"]}'::jsonb,
  jsonb_build_object('display_name', a.display_name),
  now(), now(), '', '', '', ''
from admin_user a
on conflict (id) do update set encrypted_password = excluded.encrypted_password;

with admin_user (id, email) as (
  values ('99999999-9999-9999-9999-999999999999'::uuid, 'stemlabs.ca@gmail.com')
)
insert into auth.identities (
  id, provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at
)
select
  gen_random_uuid(), a.id::text, a.id,
  jsonb_build_object('sub', a.id::text, 'email', a.email),
  'email', now(), now(), now()
from admin_user a
on conflict (provider, provider_id) do nothing;

-- The handle_new_user() trigger (schema.sql) creates this row automatically
-- on first run (auth.users INSERT fires it); the ON CONFLICT here covers
-- re-running this file against a project where it already exists, rather
-- than relying on trigger timing either way.
insert into public.profiles (id, display_name, is_admin)
values ('99999999-9999-9999-9999-999999999999'::uuid, 'Astro STEM Labs Admin', true)
on conflict (id) do update set is_admin = true;
