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

  Future<void> _next(int questionCount) async {
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
                  if (questions.isEmpty) {
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
                  final question = questions[_index];
                  return _QuestionView(
                    question: question,
                    questionNumber: _index + 1,
                    questionCount: questions.length,
                    lastResult: _lastResult,
                    triedIndices: _triedThisQuestion,
                    correctIndex: _correctIndex,
                    submitting: _submitting || _awardingMedal,
                    onSelect: (i) => _submit(i, question.sortOrder),
                    onNext: () => _next(questions.length),
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
            question.prompt,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < question.optionTexts.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _OptionTile(
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
    required this.subtopicTitle,
    required this.onFinished,
  });

  final String medal;
  final int firstTryCorrectCount;
  final int questionCount;
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
            const SizedBox(height: 24),
            FilledButton(onPressed: onFinished, child: const Text('Continue')),
          ],
        ),
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
