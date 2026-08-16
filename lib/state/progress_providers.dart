import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/progress_repository.dart';
import '../models/practice_test_result.dart';
import '../models/progress_status.dart';
import 'auth_providers.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(supabaseClientProvider));
});

/// Live subtopicId -> practice-test attempts for the signed-in student.
/// Empty (and static) when browsing as a guest.
final practiceResultsProvider =
    StreamProvider<Map<String, List<PracticeTestResult>>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return Stream.value(const <String, List<PracticeTestResult>>{});
  }
  return ref.watch(progressRepositoryProvider).watchResults(user.id).map(
    (results) {
      final bySubtopic = <String, List<PracticeTestResult>>{};
      for (final result in results) {
        bySubtopic.putIfAbsent(result.subtopicId, () => []).add(result);
      }
      return bySubtopic;
    },
  );
});

/// This subtopic's recorded practice-test attempts for the signed-in student.
final subtopicResultsProvider =
    Provider.family<List<PracticeTestResult>, String>((ref, subtopicId) {
  final bySubtopic = ref.watch(practiceResultsProvider).value ?? const {};
  return bySubtopic[subtopicId] ?? const [];
});

/// Live subtopicId -> ProgressStatus, derived from each subtopic's best
/// practice-test score so far.
final subtopicStatusProvider = Provider<Map<String, ProgressStatus>>((ref) {
  final bySubtopic = ref.watch(practiceResultsProvider).value ?? const {};
  return {
    for (final entry in bySubtopic.entries)
      entry.key: ProgressStatus.fromScorePercent(_bestScore(entry.value)),
  };
});

double _bestScore(List<PracticeTestResult> results) =>
    results.map((r) => r.scorePercent).reduce((a, b) => a > b ? a : b);

/// Aggregates a unit's overall status as the least-complete status among
/// its attempted subtopics (relying on ProgressStatus being declared
/// worst-to-best, so a lower `index` is less complete) — one subtopic
/// still struggling keeps the whole unit reading as struggling, and a
/// unit only reaches "completed" once every attempted subtopic has. Units
/// with nothing attempted yet stay "not started".
ProgressStatus aggregateUnitStatus(
  Iterable<String> subtopicIds,
  Map<String, ProgressStatus> subtopicStatus,
) {
  final statuses =
      subtopicIds.map((id) => subtopicStatus[id]).whereType<ProgressStatus>();
  if (statuses.isEmpty) return ProgressStatus.notStarted;
  return statuses.reduce((a, b) => a.index < b.index ? a : b);
}
