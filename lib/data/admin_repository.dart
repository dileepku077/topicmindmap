import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/admin_student.dart';
import '../models/profile.dart';

/// Every method here calls one of the `security definer` RPCs in
/// supabase/schema_admin.sql, each of which re-checks `is_admin(auth.uid())`
/// itself server-side — this repository doesn't (and can't) grant admin
/// access on its own, it just calls functions that refuse to run for
/// anyone who isn't already an admin in the database.
class AdminRepository {
  AdminRepository(this._client);

  final SupabaseClient _client;

  Future<List<AdminStudent>> listStudents() async {
    final rows = await _client.rpc('admin_list_students');
    return (rows as List)
        .map((row) => AdminStudent.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  /// Null fields are left unchanged — send only what actually changed.
  Future<void> updateStudent({
    required String studentId,
    int? grade,
    SubscriptionTier? subscriptionTier,
    String? displayName,
  }) {
    return _client.rpc(
      'admin_update_student',
      params: {
        'p_student_id': studentId,
        'p_grade': grade,
        'p_subscription_tier': subscriptionTier?.name,
        'p_display_name': displayName,
      },
    );
  }

  Future<void> resetPassword({
    required String studentId,
    required String newPassword,
  }) {
    return _client.rpc(
      'admin_reset_student_password',
      params: {'p_student_id': studentId, 'p_new_password': newPassword},
    );
  }

  /// Permanently deletes the student's account and every row that
  /// references it (progress, attempts, medals) via cascading foreign
  /// keys. Irreversible — the UI confirms before calling this.
  Future<void> deleteStudent(String studentId) {
    return _client.rpc(
      'admin_delete_student',
      params: {'p_student_id': studentId},
    );
  }
}
