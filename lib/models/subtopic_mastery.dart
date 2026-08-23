import 'package:flutter/material.dart';

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

/// The color a medal tier reads as everywhere it's shown — the practice
/// test's own completion screen, and every subtopic/unit badge below.
/// 'None' has no color of its own since [MedalBadge] never renders one for
/// it; the fallback only matters if an unrecognized string ever reaches
/// here.
Color medalColor(String medal) => switch (medal) {
  'Gold' => const Color(0xFFD4A017),
  'Silver' => const Color(0xFF9AA0A6),
  'Bronze' => const Color(0xFFCD7F32),
  _ => const Color(0xFF9AA0A6),
};

/// A small trophy badge in the earned tier's color, for a subtopic or
/// unit's best medal so far — used on mindmap nodes, classroom cards, and
/// the classroom sidebar alike, so a medal reads the same everywhere it
/// shows up. Renders nothing for 'None' or no record at all: nothing
/// earned yet isn't worth a badge next to every single topic.
class MedalBadge extends StatelessWidget {
  const MedalBadge({super.key, required this.medal, this.size = 13});

  /// 'None' · 'Bronze' · 'Silver' · 'Gold', or null if this subtopic/unit
  /// has no mastery record yet.
  final String? medal;
  final double size;

  @override
  Widget build(BuildContext context) {
    final medal = this.medal;
    if (medal == null || medal == 'None') return const SizedBox.shrink();
    return Icon(Icons.emoji_events, size: size, color: medalColor(medal));
  }
}
