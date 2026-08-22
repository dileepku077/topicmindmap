/// One practice question, as handed back by the `list_questions` database
/// function — deliberately stripped of `correct_index` and any option
/// feedback, since either would let a student read the answer before
/// tapping. Grading happens server-side in `submit_answer`; see
/// PracticeTestRepository.
class PracticeQuestion {
  const PracticeQuestion({
    required this.sortOrder,
    required this.difficulty,
    required this.prompt,
    required this.optionTexts,
  });

  final int sortOrder;

  /// 'Easy' · 'Medium' · 'Hard'.
  final String difficulty;
  final String prompt;
  final List<String> optionTexts;

  factory PracticeQuestion.fromMap(Map<String, dynamic> map) {
    final options = map['options'] as List<dynamic>;
    return PracticeQuestion(
      sortOrder: map['sort_order'] as int,
      difficulty: map['difficulty'] as String,
      prompt: map['prompt'] as String,
      optionTexts: options
          .map((o) => (o as Map<String, dynamic>)['text'] as String)
          .toList(),
    );
  }
}

/// The result of one tap, as handed back by `submit_answer` — whether it
/// was right, whether it was this pass's first attempt at the question
/// (which is what medals are scored on), and the feedback for the option
/// the student actually chose.
class AnswerResult {
  const AnswerResult({
    required this.wasCorrect,
    required this.wasFirst,
    required this.feedback,
  });

  final bool wasCorrect;
  final bool wasFirst;
  final String feedback;

  factory AnswerResult.fromMap(Map<String, dynamic> map) {
    return AnswerResult(
      wasCorrect: map['was_correct'] as bool,
      wasFirst: map['was_first'] as bool,
      feedback: map['feedback'] as String,
    );
  }
}
