-- Topic Mindmap: schema for Ontario Grade 10 Math (MPM2D) curriculum mindmap app.
-- Run this in the Supabase SQL editor (or via `supabase db push`) on a fresh project.

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------------
-- Curriculum content (public, read-only to app users)
-- ---------------------------------------------------------------------------

create table if not exists public.units (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,              -- e.g. 'linear-systems'
  title text not null,                    -- e.g. 'Linear Systems'
  description text,
  color text not null default '#5B8DEF',  -- hex color used as a subtle accent on the mindmap node
  order_index int not null default 0,
  created_at timestamptz not null default now()
);

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
-- progress is now derived entirely from practice_test_results below. Drop
-- the old tables/type if they exist from a previous version of this schema
-- (this permanently deletes any notes or manually-set progress students had
-- saved).
drop table if exists public.notes cascade;
drop table if exists public.user_progress cascade;
drop type if exists public.progress_status cascade;

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now()
);

-- Practice-test results drive the mindmap's progress color-coding. Rows are
-- written by the practice-test system (service role) as a student completes
-- questions on a subtopic — the app only ever reads them. There is no
-- student-facing way to edit or fabricate a score.
create table if not exists public.practice_test_results (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references auth.users (id) on delete cascade,
  subtopic_id uuid not null references public.subtopics (id) on delete cascade,
  questions_total int not null check (questions_total > 0),
  questions_correct int not null check (
    questions_correct >= 0 and questions_correct <= questions_total
  ),
  score_percent numeric generated always as (
    round((questions_correct::numeric / questions_total) * 100, 1)
  ) stored,
  attempted_at timestamptz not null default now()
);

create index if not exists practice_test_results_student_id_idx
  on public.practice_test_results (student_id);
create index if not exists practice_test_results_subtopic_id_idx
  on public.practice_test_results (subtopic_id);

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

alter table public.units enable row level security;
alter table public.subtopics enable row level security;
alter table public.profiles enable row level security;
alter table public.practice_test_results enable row level security;

-- Curriculum content: readable by anyone (including anonymous), no client writes.
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

-- Practice test results: a student can only read their own results. There
-- are intentionally no insert/update/delete policies for the authenticated
-- role — scores are recorded by the (trusted, service-role) practice-test
-- system, not by students editing their own progress from the app.
drop policy if exists "practice results are owner readable" on public.practice_test_results;
create policy "practice results are owner readable"
  on public.practice_test_results for select
  using (auth.uid() = student_id);
