/// One option's plain text, stripped of feedback and correctness — the
/// same shape `list_questions()` already hands Practice Test, since a
/// unit test paper must reveal nothing more than that until it's handed
/// in.
class UnitTestOption {
  const UnitTestOption({required this.text});

  final String text;

  factory UnitTestOption.fromMap(Map<String, dynamic> map) {
    return UnitTestOption(text: map['text'] as String? ?? '');
  }
}

class UnitTestStart {
  const UnitTestStart({
    required this.testId,
    required this.total,
    required this.isWarmup,
    required this.resumed,
  });

  final int testId;
  final int total;

  /// Free accounts get a shorter Easy/Medium-only paper, labelled as a
  /// warm-up rather than passed off as the real thing — same gate
  /// Practice Test's own Hard/Challenge/Advanced tiers already enforce.
  final bool isWarmup;

  /// True if this reopened an in-progress paper instead of starting a new
  /// one — a reload or a dropped connection doesn't cost a fresh attempt.
  final bool resumed;

  factory UnitTestStart.fromMap(Map<String, dynamic> map) {
    return UnitTestStart(
      testId: map['test_id'] as int,
      total: map['total'] as int? ?? 0,
      isWarmup: map['is_warmup'] as bool? ?? false,
      resumed: map['resumed'] as bool? ?? false,
    );
  }
}

class UnitTestItem {
  const UnitTestItem({
    required this.itemNo,
    required this.subtopicCode,
    required this.sortOrder,
    required this.difficulty,
    required this.prompt,
    required this.options,
    required this.chosenIndex,
  });

  final int itemNo;
  final String subtopicCode;
  final int sortOrder;
  final String difficulty;
  final String prompt;
  final List<UnitTestOption> options;

  /// Non-null once answered — lets a resumed paper redraw what was
  /// already picked, without saying whether it was right.
  final int? chosenIndex;

  factory UnitTestItem.fromMap(Map<String, dynamic> map) {
    return UnitTestItem(
      itemNo: map['item_no'] as int,
      subtopicCode: map['subtopic_code'] as String,
      sortOrder: map['sort_order'] as int,
      difficulty: map['difficulty'] as String,
      prompt: map['prompt'] as String,
      options: ((map['options'] as List?) ?? const [])
          .map((o) => UnitTestOption.fromMap(o as Map<String, dynamic>))
          .toList(),
      chosenIndex: map['chosen_index'] as int?,
    );
  }
}

class UnitTestScore {
  const UnitTestScore({
    required this.scorePercent,
    required this.correct,
    required this.total,
    required this.isWarmup,
    required this.seconds,
  });

  final int scorePercent;
  final int correct;
  final int total;
  final bool isWarmup;
  final int seconds;

  factory UnitTestScore.fromMap(Map<String, dynamic> map) {
    return UnitTestScore(
      scorePercent: map['score_pct'] as int? ?? 0,
      correct: map['correct'] as int? ?? 0,
      total: map['total'] as int? ?? 0,
      isWarmup: map['is_warmup'] as bool? ?? false,
      seconds: map['seconds'] as int? ?? 0,
    );
  }
}

/// One subtopic's slice of a finished paper — how many of its questions
/// were asked and how many were right.
class UnitTestBreakdown {
  const UnitTestBreakdown({
    required this.subtopicCode,
    required this.asked,
    required this.got,
    required this.percent,
  });

  final String subtopicCode;
  final int asked;
  final int got;
  final int percent;

  factory UnitTestBreakdown.fromMap(Map<String, dynamic> map) {
    return UnitTestBreakdown(
      subtopicCode: map['subtopic_code'] as String,
      asked: map['asked'] as int? ?? 0,
      got: map['got'] as int? ?? 0,
      percent: map['pct'] as int? ?? 0,
    );
  }
}

/// One question of a finished paper, as the student is allowed to see it
/// — the option they chose, whether it was right, and, only when it was
/// not, the feedback line naming the mistake. Never the correct answer:
/// these questions can come round again in a later paper.
class UnitTestReview {
  const UnitTestReview({
    required this.itemNo,
    required this.subtopicCode,
    required this.difficulty,
    required this.prompt,
    required this.chosenText,
    required this.wasCorrect,
    required this.feedback,
  });

  final int itemNo;
  final String subtopicCode;
  final String difficulty;
  final String prompt;
  final String? chosenText;
  final bool wasCorrect;
  final String? feedback;

  factory UnitTestReview.fromMap(Map<String, dynamic> map) {
    return UnitTestReview(
      itemNo: map['item_no'] as int,
      subtopicCode: map['subtopic_code'] as String,
      difficulty: map['difficulty'] as String,
      prompt: map['prompt'] as String,
      chosenText: map['chosen_text'] as String?,
      wasCorrect: map['was_correct'] as bool? ?? false,
      feedback: map['feedback'] as String?,
    );
  }
}

/// One paper already sat on this unit — the topic map shows a student's
/// best score, which is a kindness but also opaque (it can't go down, so
/// it stops being news); this history is where improvement is visible.
class UnitTestAttempt {
  const UnitTestAttempt({
    required this.testId,
    required this.scorePercent,
    required this.correct,
    required this.total,
    required this.isWarmup,
    required this.seconds,
    required this.finishedAt,
  });

  final int testId;
  final int scorePercent;
  final int correct;
  final int total;
  final bool isWarmup;
  final int seconds;
  final DateTime? finishedAt;

  factory UnitTestAttempt.fromMap(Map<String, dynamic> map) {
    return UnitTestAttempt(
      testId: map['test_id'] as int,
      scorePercent: map['score_pct'] as int? ?? 0,
      correct: map['correct'] as int? ?? 0,
      total: map['total'] as int? ?? 0,
      isWarmup: map['is_warmup'] as bool? ?? false,
      seconds: map['seconds'] as int? ?? 0,
      finishedAt: map['finished_at'] == null
          ? null
          : DateTime.tryParse(map['finished_at'] as String),
    );
  }
}
