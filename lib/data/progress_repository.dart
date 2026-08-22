import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/subtopic_mastery.dart';

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
}
