import 'package:flutter/material.dart';

class Unit {
  const Unit({
    required this.id,
    required this.courseId,
    required this.code,
    required this.title,
    required this.color,
    required this.orderIndex,
    this.description,
  });

  final String id;
  final String courseId;
  final String code;
  final String title;
  final String? description;
  final Color color;
  final int orderIndex;

  factory Unit.fromMap(Map<String, dynamic> map) {
    return Unit(
      id: map['id'] as String,
      courseId: map['course_id'] as String,
      code: map['code'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      color: _colorFromHex(map['color'] as String? ?? '#5B8DEF'),
      orderIndex: map['order_index'] as int? ?? 0,
    );
  }
}

Color _colorFromHex(String hex) {
  final cleaned = hex.replaceFirst('#', '').padLeft(6, '0');
  return Color(int.parse('FF$cleaned', radix: 16));
}
