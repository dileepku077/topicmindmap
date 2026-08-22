import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/profile_repository.dart';
import '../models/profile.dart';
import 'auth_providers.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(supabaseClientProvider));
});

/// The signed-in student's profile, or null while browsing as a guest.
/// A one-shot fetch rather than a live stream — this changes rarely
/// (picked once from the settings screen), so callers that write to it
/// invalidate this provider afterward instead of relying on realtime.
final profileProvider = FutureProvider<Profile?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Future.value(null);
  return ref.watch(profileRepositoryProvider).fetchProfile(user.id);
});
