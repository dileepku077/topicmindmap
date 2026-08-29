import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/subtopic_attempt_stat.dart';
import '../models/subtopic_mastery.dart';

/// Reads a student's practice-test progress. Two different shapes for two
/// different purposes:
///
/// - [watchMastery] streams subtopic_mastery — one row per subtopic,
///   holding the single best tier pass earned so far. This app only reads
///   it, to drive the mindmap/sidebar's progress color-coding and medal
///   badges (a different, older, coarser signal than mastery %).
/// - [fetchSubtopicAttemptStats] returns raw per-(unit, subtopic,
///   difficulty) attempt counts, computed live from attempts — the input
///   the centralized mastery calculator (lib/domain/mastery_calculator.dart)
///   works from. Deliberately NOT read from the topic_progress_report
///   table: that table is a secondary, admin-queryable copy kept up to
///   date by award_medal() as a side effect, not the source of truth, and
///   computing live from attempts means the app's own mastery/medal
///   numbers can never go stale relative to a table that fell out of sync.
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

  /// Raw per-tier attempt/correct/first-try-correct counts for every topic
  /// in [courseCode] — see subtopic_attempt_stats() in
  /// supabase/schema_mastery_rework.sql. A tier never attempted just has
  /// no row; callers treat that as zero evidence, not zero mastery.
  Future<List<SubtopicAttemptStat>> fetchSubtopicAttemptStats(String courseCode) async {
    final rows = await _client.rpc(
      'subtopic_attempt_stats',
      params: {'p_course_code': courseCode},
    );
    return (rows as List)
        .map((row) => SubtopicAttemptStat.fromMap(row as Map<String, dynamic>))
        .toList();
  }
}
