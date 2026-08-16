import 'package:flutter/material.dart';

/// A subtopic's (or unit's) mastery level, derived entirely from a
/// student's practice-test scores — never set directly by the student.
enum ProgressStatus {
  notStarted,
  struggling,
  developing,
  mastered;

  /// Buckets a best practice-test score into a status. `null` means the
  /// student hasn't attempted anything yet.
  static ProgressStatus fromScorePercent(double? scorePercent) {
    if (scorePercent == null) return ProgressStatus.notStarted;
    if (scorePercent >= 80) return ProgressStatus.mastered;
    if (scorePercent >= 50) return ProgressStatus.developing;
    return ProgressStatus.struggling;
  }
}

extension ProgressStatusDisplay on ProgressStatus {
  String get label => switch (this) {
        ProgressStatus.notStarted => 'Not started',
        ProgressStatus.struggling => 'Needs practice',
        ProgressStatus.developing => 'Developing',
        ProgressStatus.mastered => 'Mastered',
      };

  /// Traffic-light color used throughout the mindmap: grey/red/yellow/green.
  Color get color => switch (this) {
        ProgressStatus.notStarted => const Color(0xFF9AA0A6),
        ProgressStatus.struggling => const Color(0xFFE0524A),
        ProgressStatus.developing => const Color(0xFFE0A93B),
        ProgressStatus.mastered => const Color(0xFF3FA66A),
      };

  IconData get icon => switch (this) {
        ProgressStatus.notStarted => Icons.circle_outlined,
        ProgressStatus.struggling => Icons.error,
        ProgressStatus.developing => Icons.donut_large,
        ProgressStatus.mastered => Icons.check_circle,
      };
}
