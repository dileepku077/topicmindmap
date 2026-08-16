import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import '../models/subtopic.dart';
import '../models/unit.dart';

class CurriculumRepository {
  CurriculumRepository(this._client);

  final SupabaseClient _client;

  Future<List<Course>> fetchCourses() async {
    final rows = await _client.from('courses').select().order('order_index');
    return rows.map((row) => Course.fromMap(row)).toList();
  }

  Future<List<Unit>> fetchUnits() async {
    final rows = await _client.from('units').select().order('order_index');
    return rows.map((row) => Unit.fromMap(row)).toList();
  }

  Future<List<Subtopic>> fetchSubtopics() async {
    final rows =
        await _client.from('subtopics').select().order('order_index');
    return rows.map((row) => Subtopic.fromMap(row)).toList();
  }
}
