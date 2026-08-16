import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/lesson_providers.dart';

/// A short (~5 minute), self-contained explanation of one subtopic, opened
/// from its "Lesson" link in the mindmap so a student can learn the idea
/// before (or instead of) attempting practice questions.
class LessonPage extends ConsumerWidget {
  const LessonPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsProvider);
    final lesson = ref.watch(lessonProvider(lessonId));
    final scheme = Theme.of(context).colorScheme;

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
          return Markdown(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            data: lesson.content,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
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
            ),
          );
        },
      ),
    );
  }
}
