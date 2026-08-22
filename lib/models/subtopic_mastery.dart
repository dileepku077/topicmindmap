/// A student's best completed pass at one subtopic's practice questions —
/// one row per (student, course, unit, subtopic), updated in place by the
/// database's `award_medal()` function each time they finish a pass, never
/// written directly by the app. See supabase/schema_practice.sql.
class SubtopicMastery {
  const SubtopicMastery({
    required this.courseCode,
    required this.unitCode,
    required this.subtopicCode,
    required this.bestFirstTry,
    required this.totalQuestions,
    required this.medal,
    required this.timesCompleted,
    required this.updatedAt,
  });

  final String courseCode;
  final String unitCode;
  final String subtopicCode;
  final int bestFirstTry;
  final int totalQuestions;

  /// 'None' · 'Bronze' · 'Silver' · 'Gold'.
  final String medal;
  final int timesCompleted;
  final DateTime updatedAt;

  double get scorePercent =>
      totalQuestions == 0 ? 0 : (bestFirstTry / totalQuestions) * 100;

  factory SubtopicMastery.fromMap(Map<String, dynamic> map) {
    return SubtopicMastery(
      courseCode: map['course_code'] as String,
      unitCode: map['unit_code'] as String,
      subtopicCode: map['subtopic_code'] as String,
      bestFirstTry: map['best_first_try'] as int,
      totalQuestions: map['total_questions'] as int,
      medal: map['medal'] as String,
      timesCompleted: map['times_completed'] as int,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
