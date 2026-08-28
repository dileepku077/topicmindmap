/// One (unit, subtopic, difficulty) tier's practice completion — see
/// supabase/schema_progress_report.sql's topic_tier_progress() for exactly
/// how [totalQuestions]/[solvedQuestions] are derived. The Progress Report
/// page aggregates these up to whatever granularity a given chart needs
/// (per unit overall, or per unit within one difficulty), rather than the
/// database pre-aggregating a single fixed shape.
class TierProgress {
  const TierProgress({
    required this.unitCode,
    required this.subtopicCode,
    required this.difficulty,
    required this.totalQuestions,
    required this.solvedQuestions,
  });

  final String unitCode;
  final String subtopicCode;
  final String difficulty;
  final int totalQuestions;
  final int solvedQuestions;

  /// Every question in this tier answered correctly at least once.
  bool get isComplete => totalQuestions > 0 && solvedQuestions >= totalQuestions;

  factory TierProgress.fromMap(Map<String, dynamic> map) {
    return TierProgress(
      unitCode: map['unit_code'] as String,
      subtopicCode: map['subtopic_code'] as String,
      difficulty: map['difficulty'] as String,
      totalQuestions: map['total_questions'] as int,
      solvedQuestions: map['solved_questions'] as int,
    );
  }
}
