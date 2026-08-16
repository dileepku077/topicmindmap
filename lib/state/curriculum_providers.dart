import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/curriculum_repository.dart';
import '../models/course.dart';
import '../models/subtopic.dart';
import '../models/unit.dart';
import 'auth_providers.dart';

final curriculumRepositoryProvider = Provider<CurriculumRepository>((ref) {
  return CurriculumRepository(ref.watch(supabaseClientProvider));
});

// Curriculum fetch failures (missing table, bad RLS policy, typo'd column)
// are schema problems, never transient network blips — Riverpod's default
// retry policy would otherwise retry up to 10 times with backoff (~40s)
// before finally surfacing the error, which just delays diagnosis.
Duration? _noRetry(int retryCount, Object error) => null;

final coursesProvider = FutureProvider<List<Course>>((ref) {
  return ref.watch(curriculumRepositoryProvider).fetchCourses();
}, retry: _noRetry);

final unitsProvider = FutureProvider<List<Unit>>((ref) {
  return ref.watch(curriculumRepositoryProvider).fetchUnits();
}, retry: _noRetry);

final subtopicsProvider = FutureProvider<List<Subtopic>>((ref) {
  return ref.watch(curriculumRepositoryProvider).fetchSubtopics();
}, retry: _noRetry);

class _SelectedCourseId extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String courseId) => state = courseId;
}

/// The grade the user has picked from the dropdown. `null` until they
/// choose one, in which case [selectedCourseProvider] falls back to a
/// sensible default.
final selectedCourseIdProvider =
    NotifierProvider<_SelectedCourseId, String?>(_SelectedCourseId.new);

/// The course whose mindmap should be shown: the user's explicit pick if
/// still valid, otherwise Grade 10 (the original course), otherwise
/// whichever course sorts first.
final selectedCourseProvider = Provider<Course?>((ref) {
  final courses = ref.watch(coursesProvider).value ?? const [];
  if (courses.isEmpty) return null;

  final selectedId = ref.watch(selectedCourseIdProvider);
  if (selectedId != null) {
    for (final course in courses) {
      if (course.id == selectedId) return course;
    }
  }

  for (final course in courses) {
    if (course.grade == 10) return course;
  }
  return courses.first;
});

/// This course's units, in display order.
final courseUnitsProvider = Provider<List<Unit>>((ref) {
  final course = ref.watch(selectedCourseProvider);
  if (course == null) return const [];
  final units = ref.watch(unitsProvider).value ?? const [];
  final filtered = units.where((u) => u.courseId == course.id).toList()
    ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  return filtered;
});

/// Subtopics belonging to any unit in [courseUnitsProvider].
final courseSubtopicsProvider = Provider<List<Subtopic>>((ref) {
  final unitIds = ref.watch(courseUnitsProvider).map((u) => u.id).toSet();
  final subtopics = ref.watch(subtopicsProvider).value ?? const [];
  return subtopics.where((s) => unitIds.contains(s.unitId)).toList();
});
