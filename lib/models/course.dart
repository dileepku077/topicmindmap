class Course {
  const Course({
    required this.id,
    required this.grade,
    required this.code,
    required this.title,
    required this.orderIndex,
    this.description,
  });

  final String id;
  final int grade;
  final String code;
  final String title;
  final String? description;
  final int orderIndex;

  /// Short label for pickers, e.g. "Grade 10 · MPM2D".
  String get gradeLabel => 'Grade $grade · $code';

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] as String,
      grade: map['grade'] as int,
      code: map['code'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      orderIndex: map['order_index'] as int? ?? 0,
    );
  }
}
