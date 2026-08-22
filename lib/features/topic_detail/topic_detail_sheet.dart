import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/lesson.dart';
import '../../models/progress_status.dart';
import '../../models/subtopic.dart';
import '../../models/subtopic_mastery.dart';
import '../../state/auth_providers.dart';
import '../../state/lesson_providers.dart';
import '../../state/progress_providers.dart';

void showTopicDetailSheet(
  BuildContext context, {
  required Subtopic subtopic,
  required Color color,
  required String courseCode,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => TopicDetailSheet(
      subtopic: subtopic,
      color: color,
      courseCode: courseCode,
    ),
  );
}

class TopicDetailSheet extends ConsumerWidget {
  const TopicDetailSheet({
    super.key,
    required this.subtopic,
    required this.color,
    required this.courseCode,
  });

  final Subtopic subtopic;
  final Color color;
  final String courseCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final mastery = ref.watch(subtopicMasteryProvider(subtopic.id));
    final status = ProgressStatus.fromScorePercent(mastery?.scorePercent);
    final lessonId = lessonIdFor(courseCode: courseCode, subtopicCode: subtopic.code);
    final lesson = lessonId == null ? null : ref.watch(lessonProvider(lessonId));

    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                subtopic.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (subtopic.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtopic.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              if (lesson != null) ...[
                const SizedBox(height: 16),
                _LessonLink(lesson: lesson),
              ],
              const SizedBox(height: 20),
              Text('Practice progress', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              if (user == null)
                const _SignInPrompt()
              else
                _PracticeProgressCard(status: status, mastery: mastery),
            ],
          ),
        );
      },
    );
  }
}

class _PracticeProgressCard extends StatelessWidget {
  const _PracticeProgressCard({required this.status, required this.mastery});

  final ProgressStatus status;
  final SubtopicMastery? mastery;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: status.color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(status.icon, color: status.color, size: 20),
              const SizedBox(width: 8),
              Text(
                status.label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: status.color,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            mastery == null
                ? 'No practice test attempts yet. Complete a practice test on '
                    'this topic to see progress here.'
                : 'Best score: ${mastery!.scorePercent.round()}% · '
                    'completed ${mastery!.timesCompleted} '
                    '${mastery!.timesCompleted == 1 ? 'time' : 'times'} · '
                    'Last practiced ${_formatDate(mastery!.updatedAt)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _formatDate(DateTime date) => '${_months[date.month - 1]} ${date.day}';

/// Opens a short, standalone explanation of the subtopic — meant to be
/// read in about five minutes to get the idea before (or instead of)
/// diving into practice questions.
class _LessonLink extends StatelessWidget {
  const _LessonLink({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => context.push('/lesson/${lesson.id}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.menu_book_outlined, color: scheme.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Lesson',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              if (lesson.estimatedReadMinutes != null)
                Text(
                  '~${lesson.estimatedReadMinutes} min read',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: scheme.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignInPrompt extends StatelessWidget {
  const _SignInPrompt();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text('Sign in to see your practice test progress.'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/login');
            },
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }
}
