import 'package:flutter/material.dart';

/// Non-web fallback so the conditional import in html_lesson_view.dart
/// resolves on every platform. This app only ships to web today; if that
/// changes, this is the place to render lesson markdown natively instead.
class HtmlLessonView extends StatelessWidget {
  const HtmlLessonView({
    super.key,
    required this.frameId,
    required this.markdown,
    required this.isDark,
    this.videoTitle,
    this.videoUrl,
    this.videoSource,
  });

  final String frameId;
  final String markdown;
  final bool isDark;
  final String? videoTitle;
  final String? videoUrl;
  final String? videoSource;

  @override
  Widget build(BuildContext context) {
    return SelectableText(markdown);
  }
}
