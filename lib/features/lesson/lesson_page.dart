import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/lesson_providers.dart';
import 'html/html_lesson_view.dart';

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
          // Diagrams and interactive Desmos graphs are embedded directly in
          // the lesson's markdown as raw HTML (see html/), so the whole
          // lesson renders as one continuous, selectable/copyable page.
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            child: HtmlLessonView(
              key: ValueKey(lesson.id),
              frameId: '${lesson.id}-full',
              markdown: lesson.content,
              videoTitle: lesson.videoTitle,
              videoUrl: lesson.videoUrl,
              videoSource: lesson.videoSource,
            ),
          );
        },
      ),
    );
  }
}
