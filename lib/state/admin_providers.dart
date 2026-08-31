import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/admin_repository.dart';
import '../models/admin_question.dart';
import '../models/admin_student.dart';
import 'auth_providers.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.watch(supabaseClientProvider));
});

/// The full student list for the admin screen. A one-shot fetch, like
/// [profileProvider] — callers that mutate a student invalidate this
/// afterward rather than relying on realtime.
final adminStudentsProvider = FutureProvider<List<AdminStudent>>((ref) {
  return ref.watch(adminRepositoryProvider).listStudents();
});

/// The (course, unit, subtopic, difficulty) selection driving the admin
/// question editor -- a plain value type so Riverpod's family cache treats
/// two identical selections as the same request.
class AdminQuestionFilter {
  const AdminQuestionFilter({
    required this.courseCode,
    required this.unitCode,
    required this.subtopicCode,
    required this.difficulty,
  });

  final String courseCode;
  final String unitCode;
  final String subtopicCode;
  final String difficulty;

  @override
  bool operator ==(Object other) =>
      other is AdminQuestionFilter &&
      other.courseCode == courseCode &&
      other.unitCode == unitCode &&
      other.subtopicCode == subtopicCode &&
      other.difficulty == difficulty;

  @override
  int get hashCode =>
      Object.hash(courseCode, unitCode, subtopicCode, difficulty);
}

/// Every question matching one [AdminQuestionFilter], unredacted. A
/// one-shot fetch, like [adminStudentsProvider] — saving an edit
/// invalidates this rather than relying on realtime.
final adminQuestionsProvider =
    FutureProvider.family<List<AdminQuestion>, AdminQuestionFilter>((
      ref,
      filter,
    ) {
      return ref
          .watch(adminRepositoryProvider)
          .listQuestions(
            courseCode: filter.courseCode,
            unitCode: filter.unitCode,
            subtopicCode: filter.subtopicCode,
            difficulty: filter.difficulty,
          );
    });
