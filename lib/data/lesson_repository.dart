import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/lesson.dart';

/// Reads the bundled Grade 10 (MPM2D) lesson content asset. The JSON is a
/// tree of strands -> topics; this flattens every topic node (one with a
/// `content` field) into a single id-keyed map regardless of nesting depth,
/// so callers don't need to know the strand structure.
class LessonRepository {
  const LessonRepository();

  static const _assetPath = 'assets/data/mpm2d_topics_mindmap.json';

  Future<Map<String, Lesson>> fetchLessons() async {
    final raw = await rootBundle.loadString(_assetPath);
    final root = jsonDecode(raw) as Map<String, dynamic>;

    final lessons = <String, Lesson>{};
    void walk(Map<String, dynamic> node) {
      if (node['content'] != null) {
        final lesson = Lesson.fromMap(node);
        lessons[lesson.id] = lesson;
      }
      final children = node['children'] as List<dynamic>? ?? const [];
      for (final child in children) {
        walk(child as Map<String, dynamic>);
      }
    }

    walk(root);
    return lessons;
  }
}
