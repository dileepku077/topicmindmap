import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/lesson.dart';
import '../../state/lesson_providers.dart';
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
/// that section, rather than just describing what to imagine.
class _LessonBody extends StatelessWidget {
  const _LessonBody({required this.lesson});

  final Lesson lesson;

  static const _tryItMarker = '## Try It Yourself';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final styleSheet = MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      h1: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      h2: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      code: TextStyle(
        fontFamily: 'monospace',
        backgroundColor: scheme.surfaceContainerHighest,
        color: scheme.onSurface,
      ),
      codeblockDecoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      blockquoteDecoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        border: Border(left: BorderSide(color: scheme.primary, width: 3)),
      ),
      tableBorder: TableBorder.all(color: scheme.outlineVariant),
      tableHead: const TextStyle(fontWeight: FontWeight.bold),
    );

    final interactiveWidget = buildInteractiveWidget(lesson.interactiveWidgetId);
    final splitIndex = interactiveWidget == null ? -1 : lesson.content.indexOf(_tryItMarker);

    if (interactiveWidget == null || splitIndex == -1) {
      return Markdown(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        data: lesson.content,
        styleSheet: styleSheet,
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
          MarkdownBody(data: before, styleSheet: styleSheet, shrinkWrap: true),
          interactiveWidget,
          if (after.isNotEmpty)
            MarkdownBody(data: after, styleSheet: styleSheet, shrinkWrap: true),
        ],
      ),
    );
  }
}
