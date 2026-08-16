import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/lesson.dart';
import '../../state/lesson_providers.dart';
import 'html/html_lesson_view.dart';
import 'interactive/interactive_widget_registry.dart';

/// A short (~5-10 minute), self-contained explanation of one subtopic,
/// opened from its "Lesson" link in the mindmap so a student can learn the
/// idea before (or instead of) attempting practice questions.
class LessonPage extends ConsumerWidget {
  const LessonPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsProvider);
    final lesson = ref.watch(lessonProvider(lessonId));

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson?.title ?? 'Lesson'),
        actions: [
          if (lesson?.estimatedReadMinutes != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '~${lesson!.estimatedReadMinutes} min read',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
        ],
      ),
      body: lessonsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load lesson: $error')),
        data: (_) {
          if (lesson == null) {
            return const Center(child: Text('Lesson not found.'));
          }
          return _LessonBody(lesson: lesson);
        },
      ),
    );
  }
}

/// Splits the lesson at its "## Try It Yourself" section (if any) and
/// drops the corresponding interactive widget in as a live replacement for
/// that section, rather than just describing what to imagine. The text on
/// either side renders as real HTML (see html/), not Flutter-painted
/// widgets, so it's selectable and copyable like a normal web page.
class _LessonBody extends StatelessWidget {
  const _LessonBody({required this.lesson});

  final Lesson lesson;

  static const _tryItMarker = '## Try It Yourself';

  @override
  Widget build(BuildContext context) {
    final interactiveWidget = buildInteractiveWidget(lesson.interactiveWidgetId);
    final splitIndex = interactiveWidget == null ? -1 : lesson.content.indexOf(_tryItMarker);

    if (interactiveWidget == null || splitIndex == -1) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: HtmlLessonView(
          frameId: '${lesson.id}-full',
          markdown: lesson.content,
          videoTitle: lesson.videoTitle,
          videoUrl: lesson.videoUrl,
          videoSource: lesson.videoSource,
        ),
      );
    }

    final before = lesson.content.substring(0, splitIndex).trimRight();
    final afterMarker = lesson.content.substring(splitIndex + _tryItMarker.length);
    final nextHeadingIndex = afterMarker.indexOf('\n## ');
    final after = nextHeadingIndex == -1
        ? ''
        : afterMarker.substring(nextHeadingIndex + 1).trimLeft();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HtmlLessonView(frameId: '${lesson.id}-before', markdown: before),
          interactiveWidget,
          // The video card lives on this trailing section — always render
          // it when there's trailing text or a video to show, so the video
          // has somewhere to go even when "after" text is empty.
          if (after.isNotEmpty || lesson.videoUrl != null)
            HtmlLessonView(
              frameId: '${lesson.id}-after',
              markdown: after,
              videoTitle: lesson.videoTitle,
              videoUrl: lesson.videoUrl,
              videoSource: lesson.videoSource,
            ),
        ],
      ),
    );
  }
}
