-- Astro Math: tracks whether a student has seen the "How to use this app"
-- welcome page yet. login_page.dart checks this right after a successful
-- sign-in/sign-up and routes to /welcome instead of / the first time; the
-- page itself (welcome_page.dart) marks it true once opened. The same page
-- is also reachable any time afterward via the "How to use this app" link
-- in the sidebar (curriculum_sidebar.dart) — that link doesn't care about
-- this column at all, it's only what drives the automatic first redirect.
--
-- Run after schema.sql (needs public.profiles to exist). Safe to re-run.
--
-- Defaults to false for every existing row too, not just new signups —
-- deliberately: an account created before this feature shipped has never
-- seen this page either, so it gets shown once on that student's next
-- sign-in the same as a brand-new account would.

alter table public.profiles
  add column if not exists has_seen_intro boolean not null default false;

-- No RLS changes needed: profiles already has "profiles are self
-- updatable" (using auth.uid() = id) from schema.sql, which already
-- covers this new column same as any other.
