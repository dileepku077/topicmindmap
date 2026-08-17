import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/lesson.dart';

/// Reads the bundled per-grade lesson content assets. Each JSON file is a
/// tree of strands -> topics; this flattens every topic node (one with a
/// `content` field) into a single id-keyed map regardless of nesting depth,
/// so callers don't need to know the strand structure. Lesson ids are
/// prefixed distinctly per grade (e.g. `a1`/`b3` for MPM2D, `g9-n1` for
/// MPM1D), so the flattened maps can merge safely with no id collisions.
class LessonRepository {
  const LessonRepository();

  static const _assetPaths = [
    'assets/data/mpm1d_topics_mindmap.json',
    'assets/data/mpm2d_topics_mindmap.json',
  ];

  Future<Map<String, Lesson>> fetchLessons() async {
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

    for (final assetPath in _assetPaths) {
      final raw = await rootBundle.loadString(assetPath);
      final root = jsonDecode(raw) as Map<String, dynamic>;
      walk(root);
    }
    return lessons;
  }
}
