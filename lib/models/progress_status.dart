import 'package:flutter/material.dart';

/// A subtopic's (or unit's) mastery level, derived entirely from a
/// student's practice-test scores — never set directly by the student.
///
/// Ordered worst-to-best on purpose: [aggregateUnitStatus] in
/// progress_providers.dart relies on `index` to escalate a unit to its
/// least-complete subtopic's status.
enum ProgressStatus {
  notStarted,
  struggling,
  developing,
  nearingCompletion,
  mastered;

  /// Buckets a best practice-test score into a status. `null` means the
  /// student hasn't attempted anything yet. Five bands, traffic-signal
  /// style: grey (not started) → orange (struggling) → yellow (developing)
  /// → light green (nearing completion) → green (successfully completed).
  static ProgressStatus fromScorePercent(double? scorePercent) {
    if (scorePercent == null) return ProgressStatus.notStarted;
    if (scorePercent >= 90) return ProgressStatus.mastered;
    if (scorePercent >= 70) return ProgressStatus.nearingCompletion;
    if (scorePercent >= 50) return ProgressStatus.developing;
    return ProgressStatus.struggling;
  }
}

extension ProgressStatusDisplay on ProgressStatus {
  String get label => switch (this) {
        ProgressStatus.notStarted => 'Not started',
        ProgressStatus.struggling => 'Struggling',
        ProgressStatus.developing => 'Progressing',
        ProgressStatus.nearingCompletion => 'Nearing completion',
        ProgressStatus.mastered => 'Completed',
      };

  /// Traffic-signal palette: grey/orange/yellow/light-green/green.
  Color get color => switch (this) {
        ProgressStatus.notStarted => const Color(0xFF9AA0A6),
        ProgressStatus.struggling => const Color(0xFFE8590C),
        ProgressStatus.developing => const Color(0xFFD9A404),
        ProgressStatus.nearingCompletion => const Color(0xFF66BB6A),
        ProgressStatus.mastered => const Color(0xFF2E7D32),
      };

  IconData get icon => switch (this) {
        ProgressStatus.notStarted => Icons.circle_outlined,
        ProgressStatus.struggling => Icons.error,
        ProgressStatus.developing => Icons.donut_large,
        ProgressStatus.nearingCompletion => Icons.check_circle_outline,
        ProgressStatus.mastered => Icons.check_circle,
      };
}
