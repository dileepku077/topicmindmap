import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/practice_question.dart';

/// Calls the security-definer database functions in
/// supabase/schema_practice.sql — the only way the app ever touches
/// practice-test content or grading. There is deliberately no direct table
/// read/write here: `questions` has no client read policy at all (so a
/// student can't read `correct_index` or feedback text off the network
/// tab), and every write is graded and logged server-side, so a student
/// can't forge an attempt or award themselves a medal by calling the REST
/// API directly.
class PracticeTestRepository {
  PracticeTestRepository(this._client);

  final SupabaseClient _client;

  Future<List<PracticeQuestion>> fetchQuestions({
    required String courseCode,
    required String unitCode,
    required String subtopicCode,
  }) async {
    final rows = await _client.rpc(
      'list_questions',
      params: {
        'p_course_code': courseCode,
        'p_unit_code': unitCode,
        'p_subtopic_code': subtopicCode,
      },
    );
    return (rows as List)
        .map((row) => PracticeQuestion.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<AnswerResult> submitAnswer({
    required String courseCode,
    required String unitCode,
    required String subtopicCode,
    required int sortOrder,
    required int chosenIndex,
  }) async {
    final rows = await _client.rpc(
      'submit_answer',
      params: {
        'p_course_code': courseCode,
        'p_unit_code': unitCode,
        'p_subtopic_code': subtopicCode,
        'p_sort_order': sortOrder,
        'p_chosen': chosenIndex,
      },
    );
    return AnswerResult.fromMap((rows as List).first as Map<String, dynamic>);
  }

  /// Recomputes and stores the medal for the tier the student just
  /// finished. Scored entirely within that tier (see schema_tier_medals.sql)
  /// so acing just "Easy" earns its own medal instead of needing every tier
  /// in the subtopic done in one sitting. Returns 'None' if the tier isn't
  /// actually complete yet (shouldn't happen if this is only called after
  /// every question in it has been answered) or didn't reach the Bronze
  /// bar.
  Future<String> awardMedal({
    required String courseCode,
    required String unitCode,
    required String subtopicCode,
    required String difficulty,
  }) async {
    final result = await _client.rpc(
      'award_medal',
      params: {
        'p_course_code': courseCode,
        'p_unit_code': unitCode,
        'p_subtopic_code': subtopicCode,
        'p_difficulty': difficulty,
      },
    );
    return result as String;
  }

  /// The soft reset — starts a fresh pass at every subtopic in this course,
  /// without deleting history. Scoped to the whole course on purpose; see
  /// schema_practice.sql.
  Future<void> resetProgress({required String courseCode}) {
    return _client.rpc(
      'reset_progress',
      params: {'p_course_code': courseCode},
    );
  }
}
