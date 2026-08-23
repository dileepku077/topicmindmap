/// Which screen a student sees first when they open the app —
/// the spatial mindmap, or the classroom view (classroom_view.dart).
/// Persisted per-account so it's remembered across sign-ins.
enum DefaultView {
  mindmap,
  classroom;

  static DefaultView fromName(String? name) {
    return DefaultView.values.firstWhere(
      (v) => v.name == name,
      orElse: () => DefaultView.mindmap,
    );
  }
}

/// Whether a student's account can reach the Hard/Challenge/Advanced tier
/// of practice questions. There's no self-serve upgrade: a student pays by
/// e-Transfer outside the app, and an admin flips this column by hand (via
/// the Supabase SQL editor today, an admin UI later) — see
/// supabase/schema_subscriptions.sql, which also guards this column against
/// a student ever setting it on themselves through the app.
enum SubscriptionTier {
  free,
  pro;

  static SubscriptionTier fromName(String? name) {
    return SubscriptionTier.values.firstWhere(
      (v) => v.name == name,
      orElse: () => SubscriptionTier.free,
    );
  }
}

class Profile {
  const Profile({
    required this.id,
    required this.displayName,
    required this.grade,
    required this.defaultView,
    required this.subscriptionTier,
  });

  final String id;
  final String? displayName;
  final int? grade;
  final DefaultView defaultView;
  final SubscriptionTier subscriptionTier;

  bool get isPro => subscriptionTier == SubscriptionTier.pro;

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      displayName: map['display_name'] as String?,
      grade: map['grade'] as int?,
      defaultView: DefaultView.fromName(map['default_view'] as String?),
      subscriptionTier: SubscriptionTier.fromName(
        map['subscription_tier'] as String?,
      ),
    );
  }
}
