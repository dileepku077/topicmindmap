-- Astro Math: student view preference (mindmap vs. classroom list),
-- picked from a new Profile/Settings screen and applied on next login.
--
-- Run after schema.sql (needs public.profiles to exist). Safe to re-run.

alter table public.profiles
  add column if not exists default_view text not null default 'mindmap'
  check (default_view in ('mindmap', 'classroom'));

-- No RLS changes needed: profiles already has "profiles are self
-- updatable" (using auth.uid() = id) from schema.sql, which already
-- covers this new column same as any other.
