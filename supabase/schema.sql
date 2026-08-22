-- Topic Mindmap: schema for the Ontario academic math stream (grades 9-12)
-- curriculum mindmap app.
-- Run this in the Supabase SQL editor (or via `supabase db push`) on a fresh project.

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------------
-- Curriculum content (public, read-only to app users)
-- ---------------------------------------------------------------------------

-- This revision adds `courses` (one per grade) and a `units.course_id` FK,
-- so unit/subtopic codes only need to be unique within their own course
-- rather than globally. `create table if not exists` below won't retrofit
-- that column onto an already-existing `units` table, so drop and recreate
-- instead of migrating in place — every row here is fully reproducible from
-- seed.sql, so there's nothing to preserve. Re-run seed.sql after this.
--
-- IMPORTANT: practice-test data (supabase/schema_practice.sql) deliberately
-- does NOT foreign-key against subtopics.id, precisely because of the drop
-- here — it keys on the stable (course_code, unit_code, subtopic_code) text
-- codes instead, so re-running this file never touches a student's practice
-- history. Keep it that way; don't add a subtopic_id FK to those tables.
drop table if exists public.subtopics cascade;
drop table if exists public.units cascade;
drop table if exists public.courses cascade;

-- One row per grade's course (MTH1W, MPM2D, MCR3U, MHF4U, plus SNC2D and
-- SPH3U — see seed.sql). The mindmap shows one course at a time; the grade
-- dropdown in the app switches which course's units/subtopics are loaded.
create table if not exists public.courses (
  id uuid primary key default gen_random_uuid(),
  grade int not null,                     -- 9, 10, 11, 12
  code text not null unique,              -- e.g. 'MPM2D'
  title text not null,                    -- e.g. 'Grade 10 Academic Math'
  description text,
  order_index int not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.units (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses (id) on delete cascade,
  code text not null,                     -- e.g. 'linear-systems' (unique within its course)
  title text not null,                    -- e.g. 'Linear Systems'
  description text,
  color text not null default '#5B8DEF',  -- hex color used as a subtle accent on the mindmap node
  order_index int not null default 0,
  created_at timestamptz not null default now(),
  unique (course_id, code)
);

create index if not exists units_course_id_idx on public.units (course_id);

create table if not exists public.subtopics (
  id uuid primary key default gen_random_uuid(),
  unit_id uuid not null references public.units (id) on delete cascade,
  code text not null,                     -- e.g. 'solving-by-substitution'
  title text not null,
  description text,
  order_index int not null default 0,
  created_at timestamptz not null default now(),
  unique (unit_id, code)
);

create index if not exists subtopics_unit_id_idx on public.subtopics (unit_id);

-- ---------------------------------------------------------------------------
-- Per-user data (private, owner-only)
-- ---------------------------------------------------------------------------

-- Student comments/notes and manually-editable progress have been removed:
-- progress is now derived entirely from practice-test results (see
-- supabase/schema_practice.sql, which must be run after this file). Drop the
-- old tables/type if they exist from a previous version of this schema (this
-- permanently deletes any notes or manually-set progress students had
-- saved).
drop table if exists public.notes cascade;
drop table if exists public.user_progress cascade;
drop type if exists public.progress_status cascade;

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Create a profile row automatically when a new auth user signs up.
-- ---------------------------------------------------------------------------

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, new.raw_user_meta_data ->> 'display_name');
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------

alter table public.courses enable row level security;
alter table public.units enable row level security;
alter table public.subtopics enable row level security;
alter table public.profiles enable row level security;

-- Curriculum content: readable by anyone (including anonymous), no client writes.
drop policy if exists "courses are publicly readable" on public.courses;
create policy "courses are publicly readable"
  on public.courses for select
  using (true);

drop policy if exists "units are publicly readable" on public.units;
create policy "units are publicly readable"
  on public.units for select
  using (true);

drop policy if exists "subtopics are publicly readable" on public.subtopics;
create policy "subtopics are publicly readable"
  on public.subtopics for select
  using (true);

-- Profiles: a user can read/update only their own profile.
drop policy if exists "profiles are self readable" on public.profiles;
create policy "profiles are self readable"
  on public.profiles for select
  using (auth.uid() = id);

drop policy if exists "profiles are self updatable" on public.profiles;
create policy "profiles are self updatable"
  on public.profiles for update
  using (auth.uid() = id);

-- Practice-test tables (questions, attempts, progress_resets,
-- subtopic_mastery) live in supabase/schema_practice.sql, which must be run
-- after this file.
