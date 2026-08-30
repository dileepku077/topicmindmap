import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/brand_badge.dart';
import '../../state/lesson_providers.dart';
import 'html/html_lesson_view.dart';

/// A short (~5-10 minute), self-contained explanation of one subtopic,
/// opened from its "Lesson" link in the mindmap so a student can learn the
/// idea before (or instead of) attempting practice questions. A thin
/// Scaffold+AppBar wrapper around [LessonBody] — used when a lesson is its
/// own full-screen route (pushed from the mindmap's detail sheet). The
/// classroom view embeds [LessonBody] directly instead, inside its own
/// main pane, so its left-hand unit list stays on screen.
class LessonPage extends ConsumerWidget {
  const LessonPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lesson = ref.watch(lessonProvider(lessonId));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandBadge(size: 28),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                lesson?.title ?? 'Lesson',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
      body: LessonBody(lessonId: lessonId),
    );
  }
}

/// The lesson content itself, with no Scaffold/AppBar of its own — split
/// out so it can be embedded directly in the classroom view's main pane
/// as well as used full-screen via [LessonPage].
class LessonBody extends ConsumerWidget {
  const LessonBody({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsProvider);
    final lesson = ref.watch(lessonProvider(lessonId));

    return lessonsAsync.when(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HtmlLessonView(
                key: ValueKey(lesson.id),
                frameId: '${lesson.id}-full',
                markdown: lesson.content,
                isDark: Theme.of(context).brightness == Brightness.dark,
                videoTitle: lesson.videoTitle,
                videoUrl: lesson.videoUrl,
                videoSource: lesson.videoSource,
              ),
            ],
          ),
        );
      },
    );
  }
}
