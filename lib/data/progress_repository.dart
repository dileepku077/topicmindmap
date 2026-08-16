import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/practice_test_result.dart';

/// Reads a student's practice-test history. Results are recorded by the
/// practice-test system itself (service role) — this app only ever reads
/// them to drive the mindmap's progress color-coding.
class ProgressRepository {
  ProgressRepository(this._client);

  final SupabaseClient _client;

  /// Streams every practice-test attempt for [studentId], updating live as
  /// new results are recorded.
  Stream<List<PracticeTestResult>> watchResults(String studentId) {
    return _client
        .from('practice_test_results')
        .stream(primaryKey: ['id'])
        .eq('student_id', studentId)
        .map((rows) => rows.map(PracticeTestResult.fromMap).toList());
  }
}
