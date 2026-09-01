-- Astro STEM Labs: columns backing the automated Stripe subscription flow
-- (supabase/functions/create-checkout-session, create-portal-session,
-- stripe-webhook). e-Transfer + an admin hand-flipping subscription_tier
-- (schema_subscriptions.sql) still works exactly as before -- this is an
-- additional path, not a replacement.
--
-- No change needed to guard_subscription_tier() (schema_subscriptions.sql):
-- it only blocks the column change when auth.uid() is not null, and the
-- webhook writes with the service-role key, which has no JWT `sub` claim --
-- auth.uid() is null in that context, the same exemption an admin's own
-- direct SQL edit already relies on today.
--
-- Run after schema_subscriptions.sql. Safe to re-run.

alter table public.profiles
  add column if not exists stripe_customer_id text,
  add column if not exists stripe_subscription_id text;

create unique index if not exists profiles_stripe_customer_id_idx
  on public.profiles (stripe_customer_id)
  where stripe_customer_id is not null;
