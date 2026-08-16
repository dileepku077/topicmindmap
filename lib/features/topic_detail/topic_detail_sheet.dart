import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/practice_test_result.dart';
import '../../models/progress_status.dart';
import '../../models/subtopic.dart';
import '../../state/auth_providers.dart';
import '../../state/progress_providers.dart';

void showTopicDetailSheet(
  BuildContext context, {
  required Subtopic subtopic,
  required Color color,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => TopicDetailSheet(subtopic: subtopic, color: color),
  );
}

class TopicDetailSheet extends ConsumerWidget {
  const TopicDetailSheet({super.key, required this.subtopic, required this.color});

  final Subtopic subtopic;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final results = ref.watch(subtopicResultsProvider(subtopic.id));
    final bestScore = results.isEmpty
        ? null
        : results.map((r) => r.scorePercent).reduce((a, b) => a > b ? a : b);
    final status = ProgressStatus.fromScorePercent(bestScore);

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
              const SizedBox(height: 20),
              Text('Practice progress', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              if (user == null)
                const _SignInPrompt()
              else
                _PracticeProgressCard(status: status, results: results),
            ],
          ),
        );
      },
    );
  }
}

class _PracticeProgressCard extends StatelessWidget {
  const _PracticeProgressCard({required this.status, required this.results});

  final ProgressStatus status;
  final List<PracticeTestResult> results;

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
            results.isEmpty
                ? 'No practice test attempts yet. Complete a practice test on '
                    'this topic to see progress here.'
                : 'Best score: ${_bestScore(results).round()}% · '
                    '${results.length} ${results.length == 1 ? 'attempt' : 'attempts'} · '
                    'Last practiced ${_formatDate(_lastAttemptDate(results))}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

double _bestScore(List<PracticeTestResult> results) =>
    results.map((r) => r.scorePercent).reduce((a, b) => a > b ? a : b);

DateTime _lastAttemptDate(List<PracticeTestResult> results) =>
    results.map((r) => r.attemptedAt).reduce((a, b) => a.isAfter(b) ? a : b);

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _formatDate(DateTime date) => '${_months[date.month - 1]} ${date.day}';

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
