/// One answer option, unredacted -- unlike [PracticeQuestion]'s stripped
/// option text, this always carries its feedback string too, since the
/// admin editor is exactly the place that feedback gets corrected.
class AdminQuestionOption {
  const AdminQuestionOption({required this.text, required this.feedback});

  final String text;
  final String feedback;

  factory AdminQuestionOption.fromMap(Map<String, dynamic> map) {
    return AdminQuestionOption(
      text: map['text'] as String? ?? '',
      feedback: map['feedback'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {'text': text, 'feedback': feedback};
}

/// One question, unredacted -- the admin question editor's own shape, as
/// handed back by the `admin_list_questions` database function. Distinct
/// from [PracticeQuestion], which deliberately withholds correct_index and
/// every option's feedback so a student can't read the answer off the
/// network tab; only an admin session can ever see this shape.
class AdminQuestion {
  const AdminQuestion({
    required this.id,
    required this.sortOrder,
    required this.difficulty,
    required this.prompt,
    required this.correctIndex,
    required this.options,
    required this.misconceptionTag,
  });

  final int id;
  final int sortOrder;
  final String difficulty;
  final String prompt;
  final int correctIndex;

  /// Always exactly 4 -- enforced both by the questions table's own check
  /// constraint and, on the way back in, by admin_update_question().
  final List<AdminQuestionOption> options;
  final String? misconceptionTag;

  factory AdminQuestion.fromMap(Map<String, dynamic> map) {
    final options = (map['options'] as List<dynamic>)
        .map((o) => AdminQuestionOption.fromMap(o as Map<String, dynamic>))
        .toList();
    return AdminQuestion(
      id: map['id'] as int,
      sortOrder: map['sort_order'] as int,
      difficulty: map['difficulty'] as String,
      prompt: map['prompt'] as String,
      correctIndex: map['correct_index'] as int,
      options: options,
      misconceptionTag: map['misconception_tag'] as String?,
    );
  }
}
