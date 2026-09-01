import 'package:supabase_flutter/supabase_flutter.dart';

/// Calls the Stripe-backed Edge Functions in supabase/functions/ -- the
/// only two the app needs, since Stripe's own Checkout and Billing Portal
/// pages handle entering a card and managing/cancelling a subscription.
/// Both return a URL to redirect the browser to; nothing about a card
/// number ever passes through this app or Supabase at all.
class BillingRepository {
  BillingRepository(this._client);

  final SupabaseClient _client;

  /// Starts a new Pro subscription checkout. The caller lands back on
  /// /settings?checkout=success|cancel once they're done (see
  /// create-checkout-session's success_url/cancel_url).
  Future<String> createCheckoutSession() async {
    final response = await _client.functions.invoke('create-checkout-session');
    return (response.data as Map<String, dynamic>)['url'] as String;
  }

  /// Opens Stripe's hosted portal for an existing Pro student to update
  /// their card or cancel -- this app has no cancellation UI of its own.
  Future<String> createPortalSession() async {
    final response = await _client.functions.invoke('create-portal-session');
    return (response.data as Map<String, dynamic>)['url'] as String;
  }
}
