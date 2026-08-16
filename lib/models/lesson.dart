class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.content,
    this.summary,
    this.estimatedReadMinutes,
    this.videoTitle,
    this.videoUrl,
    this.videoSource,
  });

  final String id;
  final String title;
  final String? summary;
  final int? estimatedReadMinutes;

  /// Markdown body — the JSON's `contentFormat` is always `'markdown'`
  /// today, so there's nothing else to branch on yet.
  final String content;

  /// A single hand-picked, curriculum-matched video (Jensen Math, Khan
  /// Academy, or similar) shown at the end of the lesson. All three are
  /// null/non-null together — see html/lesson_html_builder.dart.
  final String? videoTitle;
  final String? videoUrl;
  final String? videoSource;

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] as String,
      title: map['title'] as String,
      summary: map['summary'] as String?,
      estimatedReadMinutes: map['estimatedReadMinutes'] as int?,
      content: map['content'] as String? ?? '',
      videoTitle: map['videoTitle'] as String?,
      videoUrl: map['videoUrl'] as String?,
      videoSource: map['videoSource'] as String?,
    );
  }
}
