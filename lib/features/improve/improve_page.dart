import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/brand_badge.dart';
import '../../models/improve_question.dart';
import '../../models/practice_question.dart';
import '../../state/auth_providers.dart';
import '../../state/curriculum_providers.dart';
import '../../state/practice_test_providers.dart';
import '../../state/progress_providers.dart';

/// A targeted drill built from a student's own repeated mistakes, not a
/// chosen subtopic -- see `improve_questions` in schema_improve.sql, which
/// finds whichever misconceptions this student is currently still getting
/// wrong (across the whole course) and serves questions built to catch
/// exactly those. One question at a time, same retry-until-correct
/// mechanic as PracticeTestPage, but a batch here can span several
/// subtopics, so each question is graded against its own real
/// (unit, subtopic, difficulty) rather than one shared tier.
class ImprovePage extends ConsumerStatefulWidget {
  const ImprovePage({
    super.key,
    required this.courseCode,
    this.embedded = false,
    this.onFinished,
  });

  final String courseCode;

  /// True when embedded in the classroom view's main pane instead of
  /// pushed as its own route — same convention as PracticeTestPage.
  final bool embedded;

  /// Called when the student taps through from the completion (or
  /// nothing-to-improve) screen. Defaults to popping the route, which only
  /// makes sense when this isn't [embedded].
  final VoidCallback? onFinished;

  @override
  ConsumerState<ImprovePage> createState() => _ImprovePageState();
}

class _ImprovePageState extends ConsumerState<ImprovePage> {
  int _index = 0;
  AnswerResult? _lastResult;
  final _triedThisQuestion = <int>{};
  int? _correctIndex;
  bool _submitting = false;
  int _firstTryCorrectCount = 0;
  bool _completed = false;
  int _questionCount = 0;

  Future<void> _submit(ImproveQuestion question, int chosenIndex) async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      final result = await ref
          .read(practiceTestRepositoryProvider)
          .submitAnswer(
            courseCode: widget.courseCode,
            unitCode: question.unitCode,
            subtopicCode: question.subtopicCode,
            sortOrder: question.sortOrder,
            chosenIndex: chosenIndex,
          );
      if (!mounted) return;
      setState(() {
        _lastResult = result;
        _triedThisQuestion.add(chosenIndex);
        if (result.wasCorrect) _correctIndex = chosenIndex;
        _submitting = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not submit that answer: $error')),
      );
    }
  }

  Future<void> _next(ImproveQuestion question, int questionCount) async {
    final wasFirstTry = _lastResult!.wasFirst;
    setState(() => _submitting = true);
    try {
      // Each Improve question can belong to a different subtopic, so its
      // medal has to be recomputed right after it's answered rather than
      // once at the end of a shared tier the way PracticeTestPage does.
      await ref
          .read(practiceTestRepositoryProvider)
          .awardMedal(
            courseCode: widget.courseCode,
            unitCode: question.unitCode,
            subtopicCode: question.subtopicCode,
            difficulty: question.difficulty,
          );
    } catch (_) {
      // Best-effort -- the attempt itself is already saved either way.
    }
    if (!mounted) return;

    if (_index + 1 < questionCount) {
      setState(() {
        _index += 1;
        _lastResult = null;
        _triedThisQuestion.clear();
        _correctIndex = null;
        _submitting = false;
        if (wasFirstTry) _firstTryCorrectCount += 1;
      });
      return;
    }

    setState(() {
      if (wasFirstTry) _firstTryCorrectCount += 1;
      _questionCount = questionCount;
      _completed = true;
      _submitting = false;
    });
    // Same reasoning as PracticeTestPage: force a fresh read so the
    // dashboard/progress report reflect this session immediately.
    ref.invalidate(practiceMasteryProvider);
    ref.invalidate(subtopicAttemptStatsProvider(widget.courseCode));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final onDone = widget.onFinished ?? () => context.pop();

    final body = user == null
        ? const _ImproveSignInPrompt()
        : _completed
        ? _ImproveCompletionView(
            firstTryCorrectCount: _firstTryCorrectCount,
            questionCount: _questionCount,
            onDone: onDone,
          )
        : Consumer(
            builder: (context, ref, _) {
              final questionsAsync = ref.watch(
                improveQuestionsProvider(widget.courseCode),
              );
              final subtopicTitleByCode = {
                for (final s in ref.watch(courseSubtopicsProvider))
                  s.code: s.title,
              };
              return questionsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) =>
                    Center(child: Text('Failed to load questions: $error')),
                data: (questions) {
                  if (questions.isEmpty) {
                    return _ImproveNothingToDoView(onDone: onDone);
                  }
                  final question = questions[_index];
                  return _ImproveQuestionView(
                    question: question,
                    subtopicTitle: subtopicTitleByCode[question.subtopicCode],
                    questionNumber: _index + 1,
                    questionCount: questions.length,
                    lastResult: _lastResult,
                    triedIndices: _triedThisQuestion,
                    correctIndex: _correctIndex,
                    submitting: _submitting,
                    onSelect: (i) => _submit(question, i),
                    onNext: () => _next(question, questions.length),
                  );
                },
              );
            },
          );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrandBadge(size: 28),
            SizedBox(width: 10),
            Text('Improve'),
          ],
        ),
      ),
      body: body,
    );
  }
}

class _ImproveQuestionView extends StatelessWidget {
  const _ImproveQuestionView({
    required this.question,
    required this.subtopicTitle,
    required this.questionNumber,
    required this.questionCount,
    required this.lastResult,
    required this.triedIndices,
    required this.correctIndex,
    required this.submitting,
    required this.onSelect,
    required this.onNext,
  });

  final ImproveQuestion question;
  final String? subtopicTitle;
  final int questionNumber;
  final int questionCount;
  final AnswerResult? lastResult;
  final Set<int> triedIndices;
  final int? correctIndex;
  final bool submitting;
  final void Function(int chosenIndex) onSelect;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final answeredCorrectly = lastResult?.wasCorrect ?? false;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Question $questionNumber of $questionCount',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(width: 10),
              _ImproveDifficultyChip(difficulty: question.difficulty),
            ],
          ),
          if (subtopicTitle != null) ...[
            const SizedBox(height: 4),
            Text(
              'From: $subtopicTitle',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: (questionNumber - 1) / questionCount,
            minHeight: 6,
            borderRadius: BorderRadius.circular(999),
          ),
          const SizedBox(height: 20),
          SelectableText(
            question.prompt,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < question.optionTexts.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ImproveOptionTile(
                text: question.optionTexts[i],
                tried: triedIndices.contains(i),
                isCorrectAnswer: correctIndex == i,
                enabled: !submitting && !answeredCorrectly,
                onTap: () => onSelect(i),
              ),
            ),
          if (lastResult != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: (answeredCorrectly ? Colors.green : scheme.error)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (answeredCorrectly ? Colors.green : scheme.error)
                      .withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    answeredCorrectly ? Icons.check_circle : Icons.info,
                    color: answeredCorrectly ? Colors.green : scheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: SelectableText(lastResult!.feedback)),
                ],
              ),
            ),
          ],
          if (answeredCorrectly) ...[
            const SizedBox(height: 16),
            FilledButton(
              onPressed: submitting ? null : onNext,
              child: Text(
                submitting
                    ? 'Saving…'
                    : questionNumber == questionCount
                    ? 'Finish'
                    : 'Next question',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Duplicated from practice_test_page.dart's private `_OptionTile` rather
/// than shared -- that one is scoped to [PracticeQuestion]'s own private
/// widget tree, and the two pages are small enough that a shared export
/// isn't worth the coupling.
class _ImproveOptionTile extends StatelessWidget {
  const _ImproveOptionTile({
    required this.text,
    required this.tried,
    required this.isCorrectAnswer,
    required this.enabled,
    required this.onTap,
  });

  final String text;
  final bool tried;
  final bool isCorrectAnswer;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color borderColor = isCorrectAnswer
        ? Colors.green
        : tried
        ? scheme.error
        : scheme.outlineVariant;

    return Material(
      color: isCorrectAnswer
          ? Colors.green.withValues(alpha: 0.08)
          : tried
          ? scheme.error.withValues(alpha: 0.06)
          : scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            children: [
              if (tried)
                Icon(
                  isCorrectAnswer ? Icons.check_circle : Icons.cancel,
                  size: 18,
                  color: isCorrectAnswer ? Colors.green : scheme.error,
                ),
              if (tried) const SizedBox(width: 10),
              Expanded(
                child: SelectableText(text, onTap: enabled ? onTap : null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Same color scale as practice_test_page.dart's private `_tierColor`,
/// duplicated for the same reason as [_ImproveOptionTile] above.
Color _improveTierColor(BuildContext context, String difficulty) =>
    switch (difficulty) {
      'Easy' => Colors.green,
      'Medium' => const Color(0xFFD9A404),
      'Challenge' => const Color(0xFFE8590C),
      'Hard' || 'Advanced' => Theme.of(context).colorScheme.error,
      _ => Theme.of(context).colorScheme.outline,
    };

class _ImproveDifficultyChip extends StatelessWidget {
  const _ImproveDifficultyChip({required this.difficulty});

  final String difficulty;

  @override
  Widget build(BuildContext context) {
    final color = _improveTierColor(context, difficulty);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _ImproveCompletionView extends StatelessWidget {
  const _ImproveCompletionView({
    required this.firstTryCorrectCount,
    required this.questionCount,
    required this.onDone,
  });

  final int firstTryCorrectCount;
  final int questionCount;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events_outlined, size: 56, color: scheme.primary),
            const SizedBox(height: 16),
            Text(
              'Nice work!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$firstTryCorrectCount of $questionCount correct on the first '
              'try. You just drilled the mistakes you keep making the most.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: onDone, child: const Text('Done')),
          ],
        ),
      ),
    );
  }
}

class _ImproveNothingToDoView extends StatelessWidget {
  const _ImproveNothingToDoView({required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, size: 56, color: scheme.primary),
            const SizedBox(height: 16),
            Text(
              "You're all caught up!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "We couldn't find a mistake you keep repeating right now -- "
              'keep practicing and check back here if one turns up.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: onDone, child: const Text('Back')),
          ],
        ),
      ),
    );
  }
}

class _ImproveSignInPrompt extends StatelessWidget {
  const _ImproveSignInPrompt();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Sign in to get a drill built from your own practice history.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
