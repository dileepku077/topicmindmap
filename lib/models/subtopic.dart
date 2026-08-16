class Subtopic {
  const Subtopic({
    required this.id,
    required this.unitId,
    required this.code,
    required this.title,
    required this.orderIndex,
    this.description,
  });

  final String id;
  final String unitId;
  final String code;
  final String title;
  final String? description;
  final int orderIndex;

  factory Subtopic.fromMap(Map<String, dynamic> map) {
    return Subtopic(
      id: map['id'] as String,
      unitId: map['unit_id'] as String,
      code: map['code'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      orderIndex: map['order_index'] as int? ?? 0,
    );
  }
}
