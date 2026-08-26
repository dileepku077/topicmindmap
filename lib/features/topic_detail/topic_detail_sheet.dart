import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/lesson.dart';
import '../../models/progress_status.dart';
import '../../models/subtopic.dart';
import '../../models/subtopic_mastery.dart';
import '../../state/auth_providers.dart';
import '../../state/lesson_providers.dart';
import '../../state/practice_test_providers.dart';
import '../../state/progress_providers.dart';

/// Opens [SubtopicOverview] as a modal sheet — the spatial mindmap's way of
/// showing a subtopic. Its Lesson/Practice Test links hand off to whatever
/// [onOpenLesson]/[onOpenPractice] the caller supplies, after dismissing
/// the sheet itself — the mindmap page uses these to swap its own canvas
/// for the embedded content (keeping its sidebar and AppBar on screen),
/// the same way the classroom view's inline pane already does with
/// [SubtopicOverview] directly.
void showTopicDetailSheet(
  BuildContext context, {
  required Subtopic subtopic,
  required Color color,
  required String courseCode,
  required void Function(String lessonId, String lessonTitle) onOpenLesson,
  required void Function(String unitCode) onOpenPractice,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) => DraggableScrollableSheet(
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
              SubtopicOverview(
                subtopic: subtopic,
                courseCode: courseCode,
                onOpenLesson: (lessonId, lessonTitle) {
                  Navigator.of(sheetContext).pop();
                  onOpenLesson(lessonId, lessonTitle);
                },
                onOpenPractice: (unitCode) {
                  Navigator.of(sheetContext).pop();
                  onOpenPractice(unitCode);
                },
              ),
            ],
          ),
        );
      },
    ),
  );
}

/// A subtopic's title, description, Lesson/Practice Test links, and
/// practice-progress card — the content of the mindmap's detail sheet,
/// factored out so the classroom view's inline pane can show the exact
/// same thing without a modal wrapper. [onOpenLesson]/[onOpenPractice]
/// decide what "open" means for the caller (push a route, or swap a pane).
class SubtopicOverview extends ConsumerWidget {
  const SubtopicOverview({
    super.key,
    required this.subtopic,
    required this.courseCode,
    required this.onOpenLesson,
    required this.onOpenPractice,
  });

  final Subtopic subtopic;
  final String courseCode;
  final void Function(String lessonId, String lessonTitle) onOpenLesson;
  final void Function(String unitCode) onOpenPractice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final mastery = ref.watch(subtopicMasteryProvider(subtopic.id));
    final status = ProgressStatus.fromScorePercent(mastery?.scorePercent);
    final lessonId = lessonIdFor(courseCode: courseCode, subtopicCode: subtopic.code);
    final lesson = lessonId == null ? null : ref.watch(lessonProvider(lessonId));
    final unitCode = ref.watch(unitCodeByIdProvider)[subtopic.unitId];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(subtopic.title, style: Theme.of(context).textTheme.headlineSmall),
        if (subtopic.description != null) ...[
          const SizedBox(height: 8),
          Text(
            subtopic.description!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        if (lesson != null) ...[
          const SizedBox(height: 16),
          _LessonLink(
            lesson: lesson,
            onTap: () => onOpenLesson(lesson.id, lesson.title),
          ),
        ],
        if (unitCode != null) ...[
          const SizedBox(height: 10),
          _PracticeTestLink(onTap: () => onOpenPractice(unitCode)),
        ],
        const SizedBox(height: 20),
        Text('Practice progress', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        if (user == null)
          const _SignInPrompt()
        else
          _PracticeProgressCard(status: status, mastery: mastery),
      ],
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
  const _LessonLink({required this.lesson, required this.onTap});

  final Lesson lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
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

/// Opens the tap-through-questions practice test for this subtopic.
class _PracticeTestLink extends StatelessWidget {
  const _PracticeTestLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.secondary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.quiz_outlined, color: scheme.secondary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Practice Test',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: scheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.secondary, size: 20),
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
            // No Navigator.pop() here — this prompt is shared between the
            // mindmap's modal sheet (where popping first makes sense) and
            // the classroom view's inline pane (where there's nothing to
            // pop). Pushing login on top works fine either way.
            onPressed: () => context.push('/login'),
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }
}
