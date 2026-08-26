import 'profile.dart';

/// One row from `admin_list_students()` (supabase/schema_admin.sql) — a
/// student's profile plus their email, which lives on auth.users rather
/// than public.profiles and so never appears in the plain [Profile] model.
class AdminStudent {
  const AdminStudent({
    required this.id,
    required this.email,
    required this.displayName,
    required this.grade,
    required this.subscriptionTier,
    required this.createdAt,
  });

  final String id;
  final String email;
  final String? displayName;
  final int? grade;
  final SubscriptionTier subscriptionTier;
  final DateTime createdAt;

  factory AdminStudent.fromMap(Map<String, dynamic> map) {
    return AdminStudent(
      id: map['id'] as String,
      email: map['email'] as String,
      displayName: map['display_name'] as String?,
      grade: map['grade'] as int?,
      subscriptionTier: SubscriptionTier.fromName(
        map['subscription_tier'] as String?,
      ),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
