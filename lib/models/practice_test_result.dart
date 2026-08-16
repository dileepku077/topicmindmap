class PracticeTestResult {
  const PracticeTestResult({
    required this.id,
    required this.studentId,
    required this.subtopicId,
    required this.questionsTotal,
    required this.questionsCorrect,
    required this.attemptedAt,
  });

  final String id;
  final String studentId;
  final String subtopicId;
  final int questionsTotal;
  final int questionsCorrect;
  final DateTime attemptedAt;

  double get scorePercent =>
      questionsTotal == 0 ? 0 : (questionsCorrect / questionsTotal) * 100;

  factory PracticeTestResult.fromMap(Map<String, dynamic> map) {
    return PracticeTestResult(
      id: map['id'] as String,
      studentId: map['student_id'] as String,
      subtopicId: map['subtopic_id'] as String,
      questionsTotal: map['questions_total'] as int,
      questionsCorrect: map['questions_correct'] as int,
      attemptedAt: DateTime.parse(map['attempted_at'] as String),
    );
  }
}
