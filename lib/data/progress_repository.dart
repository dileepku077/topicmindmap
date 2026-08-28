import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/subtopic_mastery.dart';
import '../models/tier_progress.dart';

/// Reads a student's practice-test mastery record — one row per subtopic
/// they've completed at least once, updated in place by the database's
/// award_medal() function as they improve. This app only ever reads them,
/// to drive the mindmap's progress color-coding.
class ProgressRepository {
  ProgressRepository(this._client);

  final SupabaseClient _client;

  /// Streams every subtopic_mastery row for [studentId], updating live as
  /// new medals are earned.
  Stream<List<SubtopicMastery>> watchMastery(String studentId) {
    return _client
        .from('subtopic_mastery')
        .stream(
          primaryKey: ['student_id', 'course_code', 'unit_code', 'subtopic_code'],
        )
        .eq('student_id', studentId)
        .map((rows) => rows.map(SubtopicMastery.fromMap).toList());
  }

  /// One row per (unit, subtopic, difficulty) tier with questions in the
  /// bank, for the Progress Report's charts. The solved/total numbers
  /// themselves come straight from topic_progress_report — a real table
  /// award_medal() keeps up to date as students practice (see
  /// supabase/schema_progress_report_table.sql) — rather than rejoining
  /// attempts/questions/progress_resets live on every page load the way
  /// this used to (topic_tier_progress() in schema_progress_report.sql,
  /// still defined but no longer called from here).
  ///
  /// topic_progress_report only ever has a row for a tier once a student
  /// has made at least one attempt at it, so it's paired with
  /// tier_catalog() — pure curriculum structure (which tiers exist and how
  /// many questions each has, no student data at all) — to fill in an
  /// explicit 0-progress row for anything untouched. Without that, an
  /// untouched unit's bar would be missing from the chart entirely instead
  /// of reading as 0%.
  Future<List<TierProgress>> fetchTierProgress(String courseCode) async {
    final catalogRows = await _client.rpc(
      'tier_catalog',
      params: {'p_course_code': courseCode},
    );
    final progressRows = await _client
        .from('topic_progress_report')
        .select()
        .eq('course_code', courseCode);

    final solvedByTier = <String, int>{
      for (final row in progressRows)
        _tierKey(
          row['unit_code'] as String,
          row['subtopic_code'] as String,
          row['difficulty'] as String,
        ): row['solved_questions'] as int,
    };

    return (catalogRows as List).map((row) {
      final map = row as Map<String, dynamic>;
      final unitCode = map['unit_code'] as String;
      final subtopicCode = map['subtopic_code'] as String;
      final difficulty = map['difficulty'] as String;
      return TierProgress(
        unitCode: unitCode,
        subtopicCode: subtopicCode,
        difficulty: difficulty,
        totalQuestions: map['total_questions'] as int,
        solvedQuestions: solvedByTier[_tierKey(unitCode, subtopicCode, difficulty)] ?? 0,
      );
    }).toList();
  }

  String _tierKey(String unitCode, String subtopicCode, String difficulty) =>
      '$unitCode/$subtopicCode/$difficulty';

  /// difficulty -> best medal earned on that specific tier for one
  /// subtopic ('None' · 'Bronze' · 'Silver' · 'Gold' · 'Diamond'), read
  /// straight from topic_progress_report. Unlike subtopic_mastery's single
  /// best-across-every-tier medal, this is how the tier picker shows a
  /// genuinely different medal per difficulty (Gold on Easy, Bronze on
  /// Advanced, say) for the same topic. A tier never attempted just has no
  /// entry.
  Future<Map<String, String>> fetchTierMedals({
    required String courseCode,
    required String unitCode,
    required String subtopicCode,
  }) async {
    final rows = await _client
        .from('topic_progress_report')
        .select('difficulty, medal')
        .eq('course_code', courseCode)
        .eq('unit_code', unitCode)
        .eq('subtopic_code', subtopicCode);
    return {for (final row in rows) row['difficulty'] as String: row['medal'] as String};
  }
}
