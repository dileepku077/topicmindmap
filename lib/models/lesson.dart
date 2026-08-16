class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.content,
    this.summary,
    this.estimatedReadMinutes,
  });

  final String id;
  final String title;
  final String? summary;
  final int? estimatedReadMinutes;

  /// Markdown body — the JSON's `contentFormat` is always `'markdown'`
  /// today, so there's nothing else to branch on yet.
  final String content;

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] as String,
      title: map['title'] as String,
      summary: map['summary'] as String?,
      estimatedReadMinutes: map['estimatedReadMinutes'] as int?,
      content: map['content'] as String? ?? '',
    );
  }
}
