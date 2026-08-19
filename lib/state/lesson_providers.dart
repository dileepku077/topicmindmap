import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/grade10_lesson_mapping.dart';
import '../data/grade9_lesson_mapping.dart';
import '../data/lesson_repository.dart';
import '../data/snc2d_lesson_mapping.dart';
import '../data/sph3u_lesson_mapping.dart';
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
/// any. Lesson content exists for Grade 9 Math (MPM1D), Grade 10 Math
/// (MPM2D), Grade 10 Science (SNC2D), and Grade 11 Physics (SPH3U) today.
String? lessonIdFor({
  required String courseCode,
  required String subtopicCode,
}) {
  switch (courseCode) {
    case 'MPM1D':
      return grade9LessonIdBySubtopicCode[subtopicCode];
    case 'MPM2D':
      return grade10LessonIdBySubtopicCode[subtopicCode];
    case 'SNC2D':
      return snc2dLessonIdBySubtopicCode[subtopicCode];
    case 'SPH3U':
      return sph3uLessonIdBySubtopicCode[subtopicCode];
    default:
      return null;
  }
}
