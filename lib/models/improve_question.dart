/// One question served by the `improve_questions` database function --
/// unlike [PracticeQuestion] (always one fixed subtopic per session), each
/// of these carries its own (unit, subtopic) since an Improve session draws
/// from wherever a student's weak misconceptions actually live, potentially
/// spanning several subtopics in one batch. Never [locked]: the database
/// function only ever returns tiers the signed-in student can already
/// reach (see schema_improve.sql).
class ImproveQuestion {
  const ImproveQuestion({
    required this.unitCode,
    required this.subtopicCode,
    required this.sortOrder,
    required this.difficulty,
    required this.prompt,
    required this.optionTexts,
    required this.misconceptionTag,
  });

  final String unitCode;
  final String subtopicCode;
  final int sortOrder;
  final String difficulty;
  final String prompt;
  final List<String> optionTexts;
  final String? misconceptionTag;

  factory ImproveQuestion.fromMap(Map<String, dynamic> map) {
    final options = map['options'] as List<dynamic>? ?? const [];
    return ImproveQuestion(
      unitCode: map['unit_code'] as String,
      subtopicCode: map['subtopic_code'] as String,
      sortOrder: map['sort_order'] as int,
      difficulty: map['difficulty'] as String,
      prompt: map['prompt'] as String,
      optionTexts: options
          .map((o) => (o as Map<String, dynamic>)['text'] as String)
          .toList(),
      misconceptionTag: map['misconception_tag'] as String?,
    );
  }
}
