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

/// True from the moment Supabase reports a password-recovery sign-in (a
/// student clicked the "reset your password" link emailed to them by
/// login_page.dart's forgot-password flow) until reset_password_page.dart
/// calls [PasswordRecoveryNotifier.clear] after they've actually set a new
/// one. mindmap_page.dart shows [ResetPasswordPage] in place of the usual
/// content for as long as this is true -- otherwise the app's normal
/// "already signed in -> show the mindmap" behavior would just drop them
/// straight into the app on the recovery link's session without ever
/// prompting for a new password.
///
/// A latch, not a plain derived read of the auth stream's latest event:
/// once the recovery event has fired, later unrelated auth events (a
/// realtime reconnect, a token refresh) shouldn't silently clear this.
class PasswordRecoveryNotifier extends Notifier<bool> {
  @override
  bool build() {
    final subscription = ref
        .watch(supabaseClientProvider)
        .auth
        .onAuthStateChange
        .listen((data) {
          if (data.event == AuthChangeEvent.passwordRecovery) {
            state = true;
          }
        });
    ref.onDispose(subscription.cancel);
    return false;
  }

  void clear() => state = false;
}

final passwordRecoveryProvider =
    NotifierProvider<PasswordRecoveryNotifier, bool>(
      PasswordRecoveryNotifier.new,
    );
