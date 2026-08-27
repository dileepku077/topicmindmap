-- Astro Math: turns on Realtime broadcasts for subtopic_mastery, so a
-- student's mindmap/classroom progress colors and medals update live the
-- moment a practice test finishes, without needing a page reload.
--
-- Why this was missing: progress_repository.dart's watchMastery() uses
-- supabase_flutter's .stream() on subtopic_mastery, which does an initial
-- select (fine — RLS already lets a student read their own rows) and then
-- subscribes to Postgres's logical replication feed for live changes. That
-- feed only carries a table's changes if the table has been explicitly
-- added to the `supabase_realtime` publication — every Supabase project
-- gets that publication by default, but it starts empty; nothing here ever
-- added subtopic_mastery to it. So a student finishing a practice test
-- (award_medal() in schema_practice.sql updates the row correctly) saw no
-- error and no visible update either: the write succeeded, but nothing
-- told their already-open mindmap/classroom view a row had changed. It
-- only ever looked "fixed" after a full reload, which reruns the initial
-- select from scratch and happens to pick up the latest data anyway.
--
-- Run after schema_practice.sql (needs public.subtopic_mastery to exist).
-- Safe to re-run — ALTER PUBLICATION ... ADD TABLE has no IF NOT EXISTS of
-- its own (it errors on a table already in the publication), so this
-- checks pg_publication_tables first instead.

do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'subtopic_mastery'
  ) then
    alter publication supabase_realtime add table public.subtopic_mastery;
  end if;
end
$$;
