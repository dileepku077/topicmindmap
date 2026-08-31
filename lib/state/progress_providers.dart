import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/progress_repository.dart';
import '../models/progress_status.dart';
import '../models/subtopic_attempt_stat.dart';
import '../models/subtopic_mastery.dart';
import 'auth_providers.dart';
import 'curriculum_providers.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(supabaseClientProvider));
});

// A failed RPC call here (missing function, stale schema cache after a
// migration hasn't been run yet) is a schema problem, never a transient
// network blip -- same reasoning as curriculum_providers.dart's own
// _noRetry. Without this, Riverpod's default retry policy retries up to
// 10 times with backoff (~40s) before surfacing the error, which looks
// exactly like the Progress Report "just spinning" instead of showing
// what's actually wrong.
Duration? _noRetry(int retryCount, Object error) => null;

/// subtopic_mastery keys on (course_code, unit_code, subtopic_code) — stable
/// text codes — rather than subtopic.id, because schema.sql drops and
/// recreates courses/units/subtopics (and every uuid with them) on every
/// run; see supabase/schema_practice.sql for the full reasoning. This maps
/// that natural key back to the subtopic.id the rest of the app already
/// keys its UI state on, using whichever curriculum content is loaded.
final _subtopicIdByCodeProvider = Provider<Map<String, String>>((ref) {
  final courses = ref.watch(coursesProvider).value ?? const [];
  final units = ref.watch(unitsProvider).value ?? const [];
  final subtopics = ref.watch(subtopicsProvider).value ?? const [];

  final courseCodeByCourseId = {for (final c in courses) c.id: c.code};
  final unitByUnitId = {for (final u in units) u.id: u};

  final byCode = <String, String>{};
  for (final subtopic in subtopics) {
    final unit = unitByUnitId[subtopic.unitId];
    if (unit == null) continue;
    final courseCode = courseCodeByCourseId[unit.courseId];
    if (courseCode == null) continue;
    byCode['$courseCode/${unit.code}/${subtopic.code}'] = subtopic.id;
  }
  return byCode;
});

/// Live subtopicId -> this student's mastery record, for every subtopic
/// they've completed at least once. Empty (and static) when browsing as a
/// guest, or before curriculum content has finished loading.
final practiceMasteryProvider = StreamProvider<Map<String, SubtopicMastery>>((
  ref,
) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return Stream.value(const <String, SubtopicMastery>{});
  }
  final subtopicIdByCode = ref.watch(_subtopicIdByCodeProvider);
  return ref.watch(progressRepositoryProvider).watchMastery(user.id).map((
    rows,
  ) {
    final bySubtopic = <String, SubtopicMastery>{};
    for (final row in rows) {
      final code = '${row.courseCode}/${row.unitCode}/${row.subtopicCode}';
      final subtopicId = subtopicIdByCode[code];
      if (subtopicId != null) bySubtopic[subtopicId] = row;
    }
    return bySubtopic;
  });
});

/// Raw per-(unit, subtopic, difficulty) attempt stats for one course — the
/// single source both the Progress Report page and the practice test's
/// tier picker compute their mastery %/medals from (via
/// lib/domain/mastery_calculator.dart), so the two can never disagree with
/// each other the way separately-cached numbers could. A one-shot fetch
/// (not a live stream, unlike [practiceMasteryProvider]) — callers that
/// just changed the underlying data (finishing a practice tier) invalidate
/// this explicitly, same pattern as every other write in this app.
final subtopicAttemptStatsProvider =
    FutureProvider.family<List<SubtopicAttemptStat>, String>((ref, courseCode) {
      final user = ref.watch(currentUserProvider);
      if (user == null) return Future.value(const <SubtopicAttemptStat>[]);
      return ref
          .watch(progressRepositoryProvider)
          .fetchSubtopicAttemptStats(courseCode);
    }, retry: _noRetry);

/// The (course, time window) selection behind
/// [subtopicAttemptStatsRangeProvider] — a plain value type so Riverpod's
/// family cache treats two identical selections as the same request.
/// [since]/[until] null/null means "all time", same as
/// [subtopicAttemptStatsProvider].
class SubtopicStatsRangeFilter {
  const SubtopicStatsRangeFilter({
    required this.courseCode,
    this.since,
    this.until,
  });

  final String courseCode;
  final DateTime? since;
  final DateTime? until;

  @override
  bool operator ==(Object other) =>
      other is SubtopicStatsRangeFilter &&
      other.courseCode == courseCode &&
      other.since == since &&
      other.until == until;

  @override
  int get hashCode => Object.hash(courseCode, since, until);
}

/// Same data as [subtopicAttemptStatsProvider], scoped to a time window --
/// used only by the Progress Report page's date-range selector. Kept
/// separate from [subtopicAttemptStatsProvider] rather than adding the
/// range to that provider's own key: the practice test's tier picker and
/// Improve both read that one expecting "this student's whole history",
/// and folding a range in there would mean every one of those call sites
/// has to remember to pass null/null to keep meaning what it already
/// means.
final subtopicAttemptStatsRangeProvider =
    FutureProvider.family<List<SubtopicAttemptStat>, SubtopicStatsRangeFilter>((
      ref,
      filter,
    ) {
      final user = ref.watch(currentUserProvider);
      if (user == null) return Future.value(const <SubtopicAttemptStat>[]);
      return ref
          .watch(progressRepositoryProvider)
          .fetchSubtopicAttemptStats(
            filter.courseCode,
            since: filter.since,
            until: filter.until,
          );
    }, retry: _noRetry);

/// This subtopic's mastery record for the signed-in student, or null if
/// they haven't completed a pass of it yet.
final subtopicMasteryProvider = Provider.family<SubtopicMastery?, String>((
  ref,
  subtopicId,
) {
  return ref.watch(practiceMasteryProvider).value?[subtopicId];
});

/// Live subtopicId -> ProgressStatus, derived from each subtopic's best
/// completed-pass score so far.
final subtopicStatusProvider = Provider<Map<String, ProgressStatus>>((ref) {
  final bySubtopic = ref.watch(practiceMasteryProvider).value ?? const {};
  return {
    for (final entry in bySubtopic.entries)
      entry.key: ProgressStatus.fromScorePercent(entry.value.scorePercent),
  };
});

/// Live subtopicId -> best completed-pass score (0-100) so far. A subtopic
/// with no completed pass simply has no entry — distinct from "scored 0%".
final subtopicScorePercentProvider = Provider<Map<String, double>>((ref) {
  final bySubtopic = ref.watch(practiceMasteryProvider).value ?? const {};
  return {
    for (final entry in bySubtopic.entries) entry.key: entry.value.scorePercent,
  };
});

/// Live subtopicId -> best medal earned so far ('None' · 'Bronze' ·
/// 'Silver' · 'Gold' · 'Diamond'). A subtopic with no completed pass has no
/// entry, same as [subtopicScorePercentProvider] — distinct from having
/// completed a pass but earned nothing.
final subtopicMedalProvider = Provider<Map<String, String>>((ref) {
  final bySubtopic = ref.watch(practiceMasteryProvider).value ?? const {};
  return {for (final entry in bySubtopic.entries) entry.key: entry.value.medal};
});

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
  final statuses = subtopicIds
      .map((id) => subtopicStatus[id])
      .whereType<ProgressStatus>();
  if (statuses.isEmpty) return ProgressStatus.notStarted;
  return statuses.reduce((a, b) => a.index < b.index ? a : b);
}

/// A unit's own medal — the worst medal among its *attempted* subtopics
/// (never-attempted ones are ignored entirely, same as
/// [aggregateUnitStatus]), so a unit only reads as Diamond once every
/// subtopic a student has actually tried has earned Diamond, and one
/// straggling Bronze subtopic keeps the whole unit at Bronze. Null (no
/// badge worth showing) until at least one subtopic has been attempted.
String? aggregateUnitMedal(
  Iterable<String> subtopicIds,
  Map<String, String> subtopicMedal,
) {
  const rank = {'None': 0, 'Bronze': 1, 'Silver': 2, 'Gold': 3, 'Diamond': 4};
  String? worst;
  var worstRank = 5;
  for (final id in subtopicIds) {
    final medal = subtopicMedal[id];
    if (medal == null) continue;
    final r = rank[medal] ?? 0;
    if (r < worstRank) {
      worstRank = r;
      worst = medal;
    }
  }
  return worst;
}

/// A unit's overall completion percent — the average of its subtopics'
/// best scores, counting an untouched subtopic as 0 so the number climbs
/// smoothly from 0% toward 100% as the student works through the whole
/// unit rather than jumping straight to one subtopic's score. Returns
/// null (nothing to show yet) until at least one subtopic in the unit has
/// been attempted.
double? aggregateUnitScorePercent(
  Iterable<String> subtopicIds,
  Map<String, double> subtopicScorePercent,
) {
  final ids = subtopicIds.toList();
  if (ids.isEmpty || !ids.any(subtopicScorePercent.containsKey)) return null;
  final total = ids.fold<double>(
    0,
    (sum, id) => sum + (subtopicScorePercent[id] ?? 0),
  );
  return total / ids.length;
}
