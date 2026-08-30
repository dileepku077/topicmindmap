import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
});

/// The current signed-in user, or null when browsing as a guest.
final currentUserProvider = Provider<User?>((ref) {
  ref.watch(authStateChangesProvider);
  return ref.watch(supabaseClientProvider).auth.currentUser;
});

/// Whether [user] signed up via "Continue with Google" rather than
/// email/password -- used to gate the age question in
/// complete_profile_page.dart, since only the Google path has no signup
/// form step to collect it during the OAuth redirect (see login_page.dart).
bool isGoogleAccount(User? user) => user?.appMetadata['provider'] == 'google';
