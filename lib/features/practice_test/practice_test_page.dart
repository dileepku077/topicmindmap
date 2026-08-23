import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/practice_question.dart';
import '../../state/auth_providers.dart';
import '../../state/practice_test_providers.dart';

/// One question at a time, four tappable options, immediate per-option
/// feedback — the core loop this app's practice tests are built around. A
/// wrong tap names the specific mistake it represents (never the right
/// answer) and lets the student try again; the question only advances once
/// they get it right. Medals are awarded server-side once every question
/// in the subtopic has been answered correctly at least once this pass.
class PracticeTestPage extends ConsumerStatefulWidget {
  const PracticeTestPage({
    super.key,
    required this.courseCode,
    required this.unitCode,
    required this.subtopicCode,
    required this.subtopicTitle,
    this.embedded = false,
    this.onFinished,
  });

  final String courseCode;
  final String unitCode;
  final String subtopicCode;
  final String subtopicTitle;

  /// True when embedded in the classroom view's main pane instead of
  /// pushed as its own route — skips the Scaffold/AppBar, since the
  /// classroom view supplies its own header and keeps the left-hand unit
  /// list on screen around it.
  final bool embedded;

  /// Called when the student taps through from the completion screen.
  /// Defaults to popping the route, which only makes sense when this
  /// isn't [embedded]; the classroom view always passes its own callback.
  final VoidCallback? onFinished;

  @override
  ConsumerState<PracticeTestPage> createState() => _PracticeTestPageState();
}

class _PracticeTestPageState extends ConsumerState<PracticeTestPage> {
  int _index = 0;
  AnswerResult? _lastResult;
  final _triedThisQuestion = <int>{};

  /// The option index that was actually correct, once found — distinct
  /// from [_triedThisQuestion], which also holds every wrong option tried
  /// first. Only this one index should ever render green.
  int? _correctIndex;
  bool _submitting = false;
  int _firstTryCorrectCount = 0;

  bool _completed = false;
  String? _medal;
  bool _awardingMedal = false;
  int _questionCount = 0;

  /// How many Hard/Challenge/Advanced questions this subtopic has that
  /// weren't included in this pass, because the signed-in student isn't on
  /// Pro. Set once the pass finishes, so the completion screen can offer
  /// the upgrade at exactly the moment a free student has run out of
  /// questions to practice.
  int _lockedCount = 0;

  late final PracticeSubtopicRef _ref = PracticeSubtopicRef(
    courseCode: widget.courseCode,
    unitCode: widget.unitCode,
    subtopicCode: widget.subtopicCode,
  );

  Future<void> _submit(int chosenIndex, int sortOrder) async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      final result = await ref
          .read(practiceTestRepositoryProvider)
          .submitAnswer(
            courseCode: widget.courseCode,
            unitCode: widget.unitCode,
            subtopicCode: widget.subtopicCode,
            sortOrder: sortOrder,
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

  Future<void> _next(int questionCount, int lockedCount) async {
    final wasFirstTry = _lastResult!.wasFirst;

    if (_index + 1 < questionCount) {
      setState(() {
        _index += 1;
        _lastResult = null;
        _triedThisQuestion.clear();
        _correctIndex = null;
        if (wasFirstTry) _firstTryCorrectCount += 1;
      });
      return;
    }

    // Last question just answered correctly — finish the pass.
    setState(() {
      if (wasFirstTry) _firstTryCorrectCount += 1;
      _questionCount = questionCount;
      _lockedCount = lockedCount;
      _awardingMedal = true;
    });
    try {
      final medal = await ref
          .read(practiceTestRepositoryProvider)
          .awardMedal(
            courseCode: widget.courseCode,
            unitCode: widget.unitCode,
            subtopicCode: widget.subtopicCode,
          );
      if (!mounted) return;
      setState(() {
        _medal = medal;
        _completed = true;
        _awardingMedal = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _awardingMedal = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save your result: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    final body = user == null
        ? _SignInPrompt(subtopicTitle: widget.subtopicTitle)
        : _completed
        ? _CompletionView(
            medal: _medal ?? 'None',
            firstTryCorrectCount: _firstTryCorrectCount,
            questionCount: _questionCount,
            lockedCount: _lockedCount,
            subtopicTitle: widget.subtopicTitle,
            onFinished: widget.onFinished ?? () => context.pop(),
          )
        : Consumer(
            builder: (context, ref, _) {
              final questionsAsync = ref.watch(
                practiceQuestionsProvider(_ref),
              );
              return questionsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) =>
                    Center(child: Text('Failed to load questions: $error')),
                data: (questions) {
                  // A free student's Hard/Challenge/Advanced questions come
                  // back locked (no prompt/options — see PracticeQuestion),
                  // so the quiz itself only ever runs through what's
                  // unlocked; lockedCount drives the upsell on the
                  // completion screen once they're out of free questions.
                  final unlocked = questions.where((q) => !q.locked).toList();
                  final lockedCount = questions.length - unlocked.length;
                  if (unlocked.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No practice questions for this topic yet — '
                          'check back soon.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  final question = unlocked[_index];
                  return _QuestionView(
                    question: question,
                    questionNumber: _index + 1,
                    questionCount: unlocked.length,
                    lastResult: _lastResult,
                    triedIndices: _triedThisQuestion,
                    correctIndex: _correctIndex,
                    submitting: _submitting || _awardingMedal,
                    onSelect: (i) => _submit(i, question.sortOrder),
                    onNext: () => _next(unlocked.length, lockedCount),
                  );
                },
              );
            },
          );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(title: Text('Practice: ${widget.subtopicTitle}')),
      body: body,
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({
    required this.question,
    required this.questionNumber,
    required this.questionCount,
    required this.lastResult,
    required this.triedIndices,
    required this.correctIndex,
    required this.submitting,
    required this.onSelect,
    required this.onNext,
  });

  final PracticeQuestion question;
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
              _DifficultyChip(difficulty: question.difficulty),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: (questionNumber - 1) / questionCount,
            minHeight: 6,
            borderRadius: BorderRadius.circular(999),
          ),
          const SizedBox(height: 20),
          SelectableText(
            // Never null here: this view only ever renders an unlocked
            // question (see PracticeTestPage, which filters to those
            // before indexing) — a locked one has no prompt to show.
            question.prompt!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < question.optionTexts!.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _OptionTile(
                text: question.optionTexts![i],
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
                color:
                    (answeredCorrectly ? Colors.green : scheme.error)
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

class _OptionTile extends StatelessWidget {
  const _OptionTile({
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
              // SelectableText, not Text — a student should be able to
              // select and copy option text, same as the question — but it
              // needs its own onTap (matching the InkWell's) so tapping the
              // text itself still picks this option instead of only
              // starting a text selection.
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

class _DifficultyChip extends StatelessWidget {
  const _DifficultyChip({required this.difficulty});

  final String difficulty;

  Color _color(BuildContext context) => switch (difficulty) {
    'Easy' => Colors.green,
    'Medium' => const Color(0xFFD9A404),
    // Challenge/Advanced are MPM2D's own two tiers above Medium (see
    // schema_difficulty_tiers.sql); Hard is still MCR3U/MHF4U's single top
    // tier. Advanced and Hard share a color since neither ever appears
    // alongside the other in the same subtopic — each is just "the hardest
    // tier this course has."
    'Challenge' => const Color(0xFFE8590C),
    'Hard' || 'Advanced' => Theme.of(context).colorScheme.error,
    _ => Theme.of(context).colorScheme.outline,
  };

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
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

class _CompletionView extends StatelessWidget {
  const _CompletionView({
    required this.medal,
    required this.firstTryCorrectCount,
    required this.questionCount,
    required this.lockedCount,
    required this.subtopicTitle,
    required this.onFinished,
  });

  final String medal;
  final int firstTryCorrectCount;
  final int questionCount;

  /// Hard/Challenge/Advanced questions on this subtopic that weren't part
  /// of this pass because the student isn't on Pro. Zero for a Pro student,
  /// and for any subtopic with no gated tier at all.
  final int lockedCount;
  final String subtopicTitle;
  final VoidCallback onFinished;

  Color _medalColor(BuildContext context) => switch (medal) {
    'Gold' => const Color(0xFFD4A017),
    'Silver' => const Color(0xFF9AA0A6),
    'Bronze' => const Color(0xFFCD7F32),
    _ => Theme.of(context).colorScheme.outline,
  };

  @override
  Widget build(BuildContext context) {
    final color = _medalColor(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 64, color: color),
            const SizedBox(height: 16),
            Text(
              medal == 'None' ? 'Nice work!' : '$medal medal!',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'You finished every question on $subtopicTitle — '
              '$firstTryCorrectCount of $questionCount correct on the first try.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (lockedCount > 0) ...[
              const SizedBox(height: 16),
              _ProUpsellCard(lockedCount: lockedCount),
            ],
            const SizedBox(height: 24),
            FilledButton(onPressed: onFinished, child: const Text('Continue')),
          ],
        ),
      ),
    );
  }
}

/// Shown on the completion screen once a free student has answered every
/// question available to them — names what's behind the paywall (rather
/// than a vague "upgrade for more") and how to actually get it, since
/// there's no in-app purchase flow yet: a parent pays by e-Transfer and an
/// admin flips the student's account to Pro by hand.
class _ProUpsellCard extends StatelessWidget {
  const _ProUpsellCard({required this.lockedCount});

  final int lockedCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_outline, size: 18, color: scheme.primary),
              const SizedBox(width: 8),
              Text(
                '$lockedCount more question${lockedCount == 1 ? '' : 's'} with Pro',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Challenge and Advanced questions are a Pro feature. Ask a '
            'parent to contact us to upgrade your account.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SignInPrompt extends StatelessWidget {
  const _SignInPrompt({required this.subtopicTitle});

  final String subtopicTitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 40, color: scheme.primary),
            const SizedBox(height: 12),
            Text(
              'Sign in to practice $subtopicTitle',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.push('/login'),
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
