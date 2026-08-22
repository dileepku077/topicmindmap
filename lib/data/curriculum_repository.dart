import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import '../models/subtopic.dart';
import '../models/unit.dart';

class CurriculumRepository {
  CurriculumRepository(this._client);

  final SupabaseClient _client;

  // postgrest's .order() defaults ascending to FALSE — without passing it
  // explicitly here, every one of these came back sorted highest
  // order_index first, which is why the mindmap used to open on whichever
  // course happened to sort last among its grade instead of the intended
  // one (courseUnitsProvider re-sorts units client-side, which papered
  // over this for units, but not for the course-picking fallback in
  // selectedCourseProvider, or for subtopics).
  Future<List<Course>> fetchCourses() async {
    final rows = await _client
        .from('courses')
        .select()
        .order('order_index', ascending: true);
    return rows.map((row) => Course.fromMap(row)).toList();
  }

  Future<List<Unit>> fetchUnits() async {
    final rows = await _client
        .from('units')
        .select()
        .order('order_index', ascending: true);
    return rows.map((row) => Unit.fromMap(row)).toList();
  }

  Future<List<Subtopic>> fetchSubtopics() async {
    final rows = await _client
        .from('subtopics')
        .select()
        .order('order_index', ascending: true);
    return rows.map((row) => Subtopic.fromMap(row)).toList();
  }
}
