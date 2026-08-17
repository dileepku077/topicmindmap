import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/grade10_lesson_mapping.dart';
import '../data/grade9_lesson_mapping.dart';
import '../data/lesson_repository.dart';
import '../models/lesson.dart';

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return const LessonRepository();
});

/// All bundled lessons, keyed by lesson id. This is a static asset (not
/// per-user data), so a fetch failure is a packaging bug, not something
/// worth retrying — same reasoning as the curriculum providers.
final lessonsProvider = FutureProvider<Map<String, Lesson>>((ref) {
  return ref.watch(lessonRepositoryProvider).fetchLessons();
}, retry: (_, _) => null);

/// The lesson for a given lesson id, once loaded.
final lessonProvider = Provider.family<Lesson?, String>((ref, lessonId) {
  final lessons = ref.watch(lessonsProvider).value ?? const {};
  return lessons[lessonId];
});

/// The lesson id covering [subtopicCode] in [courseCode]'s curriculum, if
/// any. Lesson content exists for Grade 9 (MPM1D) and Grade 10 (MPM2D) today.
String? lessonIdFor({required String courseCode, required String subtopicCode}) {
  switch (courseCode) {
    case 'MPM1D':
      return grade9LessonIdBySubtopicCode[subtopicCode];
    case 'MPM2D':
      return grade10LessonIdBySubtopicCode[subtopicCode];
    default:
      return null;
  }
}
