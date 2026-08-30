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
  // "Struggling" reads as a judgment, not a status -- this app is meant to
  // make gradual progress feel encouraging, so even the lowest (non-zero)
  // band gets a forward-looking word. "Learning", not "Progressing": that
  // word's already taken by the tier above, and a student below 50% is
  // still building the basics rather than visibly progressing yet.
  String get label => switch (this) {
    ProgressStatus.notStarted => 'Not started',
    ProgressStatus.struggling => 'Learning',
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
    // A lightly-filled donut, not an error/exclamation glyph -- same
    // "how full is the ring" motif as developing's donut_large, just
    // earlier along it, rather than iconography that reads as a warning.
    ProgressStatus.struggling => Icons.donut_small,
    ProgressStatus.developing => Icons.donut_large,
    ProgressStatus.nearingCompletion => Icons.check_circle_outline,
    ProgressStatus.mastered => Icons.check_circle,
  };

  /// A short, encouraging note about where the student stands on a topic
  /// or unit — meant for a hover tooltip. [noun] lets the same wording
  /// read naturally for either ("this topic" vs "this unit"); [scorePercent],
  /// when given, adds a touch of specificity on top of the status band.
  String hoverMessage({String noun = 'topic', double? scorePercent}) {
    final score = scorePercent != null ? ' (${scorePercent.round()}%)' : '';
    return switch (this) {
      ProgressStatus.notStarted =>
        "Haven't started this $noun yet — plan to give it a try.",
      ProgressStatus.struggling =>
        "Just getting started on this $noun$score — keep practicing and it'll click.",
      ProgressStatus.developing =>
        "Making progress on this $noun$score — keep practicing to build it up.",
      ProgressStatus.nearingCompletion =>
        "Nearly there on this $noun$score — a bit more practice and it's mastered.",
      ProgressStatus.mastered =>
        "Know this $noun really well$score — great work!",
    };
  }
}
