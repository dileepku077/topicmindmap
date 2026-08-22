/// Which screen a student sees first when they open the app —
/// the spatial mindmap, or the flat list (topic_tree_view.dart).
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

class Profile {
  const Profile({
    required this.id,
    required this.displayName,
    required this.grade,
    required this.defaultView,
  });

  final String id;
  final String? displayName;
  final int? grade;
  final DefaultView defaultView;

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      displayName: map['display_name'] as String?,
      grade: map['grade'] as int?,
      defaultView: DefaultView.fromName(map['default_view'] as String?),
    );
  }
}
