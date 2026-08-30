import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/practice_test_repository.dart';
import '../models/improve_question.dart';
import '../models/practice_question.dart';
import 'auth_providers.dart';
import 'curriculum_providers.dart';

final practiceTestRepositoryProvider = Provider<PracticeTestRepository>((ref) {
  return PracticeTestRepository(ref.watch(supabaseClientProvider));
});

/// unit.id -> unit.code, so a widget holding only a [Subtopic] (which knows
/// its unitId, not the unit's code) can resolve the natural-key triple
/// practice-test content is addressed by. See schema_practice.sql for why
/// that's codes rather than ids.
final unitCodeByIdProvider = Provider<Map<String, String>>((ref) {
  final units = ref.watch(unitsProvider).value ?? const [];
  return {for (final unit in units) unit.id: unit.code};
});

/// Identifies one subtopic's practice content by the natural key the
/// database functions take — used as the family key below so requests for
/// the same subtopic share a cached result.
class PracticeSubtopicRef {
  const PracticeSubtopicRef({
    required this.courseCode,
    required this.unitCode,
    required this.subtopicCode,
  });

  final String courseCode;
  final String unitCode;
  final String subtopicCode;

  @override
  bool operator ==(Object other) =>
      other is PracticeSubtopicRef &&
      other.courseCode == courseCode &&
      other.unitCode == unitCode &&
      other.subtopicCode == subtopicCode;

  @override
  int get hashCode => Object.hash(courseCode, unitCode, subtopicCode);
}

/// This subtopic's practice questions, already server-ordered Easy ->
/// Medium -> Hard and stripped of anything that gives away an answer.
final practiceQuestionsProvider =
    FutureProvider.family<List<PracticeQuestion>, PracticeSubtopicRef>((
      ref,
      subtopicRef,
    ) {
      return ref
          .watch(practiceTestRepositoryProvider)
          .fetchQuestions(
            courseCode: subtopicRef.courseCode,
            unitCode: subtopicRef.unitCode,
            subtopicCode: subtopicRef.subtopicCode,
          );
    });

/// A fresh batch of Improve questions for [courseCode] — a one-shot fetch,
/// not a live stream, same as [practiceQuestionsProvider]; a new session is
/// requested explicitly (see improve_page.dart) rather than silently
/// re-shuffling mid-session.
final improveQuestionsProvider =
    FutureProvider.family<List<ImproveQuestion>, String>((ref, courseCode) {
      return ref
          .watch(practiceTestRepositoryProvider)
          .fetchImproveQuestions(courseCode: courseCode);
    });
