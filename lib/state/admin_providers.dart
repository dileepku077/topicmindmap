import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/admin_repository.dart';
import '../models/admin_student.dart';
import 'auth_providers.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.watch(supabaseClientProvider));
});

/// The full student list for the admin screen. A one-shot fetch, like
/// [profileProvider] — callers that mutate a student invalidate this
/// afterward rather than relying on realtime.
final adminStudentsProvider = FutureProvider<List<AdminStudent>>((ref) {
  return ref.watch(adminRepositoryProvider).listStudents();
});
