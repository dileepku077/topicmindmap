/// One (unit, subtopic, difficulty) tier's raw attempt counts for the
/// signed-in student — the data-layer row shape subtopic_attempt_stats()
/// returns (see supabase/schema_mastery_rework.sql). Callers group these
/// by subtopic or unit and feed them to calculateMastery()
/// (lib/domain/mastery_calculator.dart) as DifficultyStats; this class
/// carries the extra unit/subtopic context that the pure calculator
/// doesn't need.
class SubtopicAttemptStat {
  const SubtopicAttemptStat({
    required this.unitCode,
    required this.subtopicCode,
    required this.difficulty,
    required this.attempted,
    required this.correct,
    required this.firstTryCorrect,
  });

  final String unitCode;
  final String subtopicCode;
  final String difficulty;
  final int attempted;
  final int correct;
  final int firstTryCorrect;

  factory SubtopicAttemptStat.fromMap(Map<String, dynamic> map) {
    return SubtopicAttemptStat(
      unitCode: map['unit_code'] as String,
      subtopicCode: map['subtopic_code'] as String,
      difficulty: map['difficulty'] as String,
      attempted: map['attempted'] as int,
      correct: map['correct'] as int,
      firstTryCorrect: map['first_try_correct'] as int,
    );
  }
}
