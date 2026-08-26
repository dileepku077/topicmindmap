import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/unit_test.dart';

/// Calls the security-definer database functions in
/// supabase/schema_unit_tests.sql — the only way the app ever touches a
/// unit test's content or grading. Same no-direct-table-read philosophy
/// as PracticeTestRepository: `unit_tests`/`unit_test_items` have no
/// client read policy that would let a student see correct_index or
/// feedback text before the paper is handed in.
class UnitTestRepository {
  UnitTestRepository(this._client);

  final SupabaseClient _client;

  Future<UnitTestStart> start({
    required String courseCode,
    required String unitCode,
  }) async {
    final rows = await _client.rpc(
      'start_unit_test',
      params: {'p_course_code': courseCode, 'p_unit_code': unitCode},
    );
    return UnitTestStart.fromMap((rows as List).first as Map<String, dynamic>);
  }

  Future<List<UnitTestItem>> paper(int testId) async {
    final rows = await _client.rpc('unit_test_paper', params: {'p_test': testId});
    return (rows as List)
        .map((row) => UnitTestItem.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  /// Returns nothing, and that is the point — see the RPC's own doc
  /// comment. answer_unit_test_item() never reports back whether the tap
  /// was right.
  Future<void> answer({
    required int testId,
    required int itemNo,
    required int chosenIndex,
  }) {
    return _client.rpc(
      'answer_unit_test_item',
      params: {'p_test': testId, 'p_item_no': itemNo, 'p_chosen': chosenIndex},
    );
  }

  Future<UnitTestScore> finish(int testId) async {
    final rows = await _client.rpc('finish_unit_test', params: {'p_test': testId});
    return UnitTestScore.fromMap((rows as List).first as Map<String, dynamic>);
  }

  Future<List<UnitTestBreakdown>> result(int testId) async {
    final rows = await _client.rpc('unit_test_result', params: {'p_test': testId});
    return (rows as List)
        .map((row) => UnitTestBreakdown.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<List<UnitTestReview>> review(int testId) async {
    final rows = await _client.rpc('unit_test_item_review', params: {'p_test': testId});
    return (rows as List)
        .map((row) => UnitTestReview.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<List<UnitTestAttempt>> history({
    required String courseCode,
    required String unitCode,
  }) async {
    final rows = await _client.rpc(
      'unit_test_history',
      params: {'p_course_code': courseCode, 'p_unit_code': unitCode},
    );
    return (rows as List)
        .map((row) => UnitTestAttempt.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> abandon(int testId) {
    return _client.rpc('abandon_unit_test', params: {'p_test': testId});
  }
}
