// Astro STEM Labs: the other end of the checkout/portal flow -- Stripe
// calls this directly (never the Flutter app), verified via the
// Stripe-Signature header rather than a Supabase JWT (see
// supabase/config.toml's verify_jwt = false for this function). Writes
// with the service-role key, which bypasses guard_subscription_tier()'s
// auth.uid()-based check the same way an admin's own direct SQL edit
// already does -- see schema_stripe_billing.sql's own comment on this.
//
// Secrets required (supabase secrets set): STRIPE_SECRET_KEY,
// STRIPE_WEBHOOK_SECRET.
//
// Only 3 of Stripe's dozens of event types affect subscription_tier;
// everything else is acknowledged (200) and ignored rather than treated
// as an error, since Stripe retries on non-2xx responses.

import Stripe from "npm:stripe@17";
import { createClient } from "npm:@supabase/supabase-js@2";

const stripe = new Stripe(Deno.env.get("STRIPE_SECRET_KEY")!, {
  apiVersion: "2024-06-20",
});
// Deno's crypto differs enough from Node's that Stripe's signature check
// needs its async, SubtleCrypto-backed variant rather than the default
// sync one.
const cryptoProvider = Stripe.createSubtleCryptoProvider();

const admin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

async function setTier(
  customerId: string,
  tier: "free" | "pro",
  subscriptionId: string | null,
) {
  const update: Record<string, unknown> = { subscription_tier: tier };
  if (subscriptionId !== null) update.stripe_subscription_id = subscriptionId;
  const { error } = await admin
    .from("profiles")
    .update(update)
    .eq("stripe_customer_id", customerId);
  if (error) throw error;
}

Deno.serve(async (req) => {
  const signature = req.headers.get("Stripe-Signature");
  const body = await req.text();

  let event: Stripe.Event;
  try {
    event = await stripe.webhooks.constructEventAsync(
      body,
      signature!,
      Deno.env.get("STRIPE_WEBHOOK_SECRET")!,
      undefined,
      cryptoProvider,
    );
  } catch (error) {
    console.error("Webhook signature verification failed:", error);
    return new Response(`Webhook Error: ${error}`, { status: 400 });
  }

  try {
    switch (event.type) {
      case "checkout.session.completed": {
        const session = event.data.object as Stripe.Checkout.Session;
        const customerId = session.customer as string;
        const subscriptionId = session.subscription as string | null;
        await setTier(customerId, "pro", subscriptionId);
        break;
      }
      case "customer.subscription.updated": {
        const sub = event.data.object as Stripe.Subscription;
        const customerId = sub.customer as string;
        const active = sub.status === "active" || sub.status === "trialing";
        await setTier(customerId, active ? "pro" : "free", sub.id);
        break;
      }
      case "customer.subscription.deleted": {
        const sub = event.data.object as Stripe.Subscription;
        const customerId = sub.customer as string;
        await setTier(customerId, "free", null);
        break;
      }
      default:
        break;
    }
    return new Response(JSON.stringify({ received: true }), { status: 200 });
  } catch (error) {
    console.error("Webhook handler failed:", error);
    return new Response(JSON.stringify({ error: String(error) }), {
      status: 500,
    });
  }
});
