import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/brand_badge.dart';
import '../../models/practice_question.dart';
import '../../state/auth_providers.dart';
import '../../state/practice_test_providers.dart';
import '../../state/progress_providers.dart';

/// A subtopic opens on a tier picker (Easy/Medium/Challenge/Advanced, or
/// Easy/Medium/Hard — whatever this subtopic actually has), with a lock
/// icon on any tier a free student can't reach. Picking an unlocked tier
/// starts its quiz: one question at a time, four tappable options,
/// immediate per-option feedback. A wrong tap names the specific mistake
/// it represents (never the right answer) and lets the student try again;
/// the question only advances once they get it right. Medals are awarded
/// server-side, scored entirely within the tier just finished (see
/// schema_tier_medals.sql) — acing "Easy" alone earns its own medal rather
/// than needing every tier in the subtopic done in one sitting.
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
  /// Null while the student is choosing a difficulty on the tier picker;
  /// set to 'Easy' / 'Medium' / 'Challenge' / 'Hard' / 'Advanced' once
  /// they've picked one, which is what actually starts the quiz.
  String? _selectedTier;

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

  void _selectTier(String tier) {
    setState(() {
      _selectedTier = tier;
      _index = 0;
      _lastResult = null;
      _triedThisQuestion.clear();
      _correctIndex = null;
      _firstTryCorrectCount = 0;
      _completed = false;
      _medal = null;
    });
  }

  void _backToTiers() {
    setState(() {
      _selectedTier = null;
      _completed = false;
    });
  }

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
            difficulty: _selectedTier!,
          );
      if (!mounted) return;
      setState(() {
        _medal = medal;
        _completed = true;
        _awardingMedal = false;
      });
      // practiceMasteryProvider is a live Supabase Realtime stream (see
      // progress_repository.dart), which only pushes an update if
      // subtopic_mastery is in the supabase_realtime publication (see
      // schema_realtime.sql — easy to miss, and was missing until now).
      // Invalidating here forces a fresh read regardless, so the mindmap/
      // classroom view reflects this result the moment the student goes
      // back, instead of depending on that realtime push arriving.
      ref.invalidate(practiceMasteryProvider);
      // Same reasoning — the Progress Report's bar for this topic should
      // reflect a just-cleared tier immediately if the student checks it
      // right after, not a stale fetch from before this attempt.
      ref.invalidate(progressReportProvider(widget.courseCode));
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
            onBackToTiers: _backToTiers,
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
                  if (_selectedTier == null) {
                    return _TierPickerView(
                      questions: questions,
                      subtopicTitle: widget.subtopicTitle,
                      onSelectTier: _selectTier,
                    );
                  }

                  // A free student's Hard/Challenge/Advanced questions come
                  // back locked (no prompt/options — see PracticeQuestion);
                  // the tier picker already refuses to send them into a
                  // locked tier, so this is just the selected tier's usable
                  // questions.
                  final tierUnlocked = questions
                      .where((q) => q.difficulty == _selectedTier && !q.locked)
                      .toList();

                  if (tierUnlocked.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'No questions available in this category.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: _backToTiers,
                              child: const Text('Choose another level'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final question = tierUnlocked[_index];
                  return _QuestionView(
                    question: question,
                    questionNumber: _index + 1,
                    questionCount: tierUnlocked.length,
                    lastResult: _lastResult,
                    triedIndices: _triedThisQuestion,
                    correctIndex: _correctIndex,
                    submitting: _submitting || _awardingMedal,
                    onSelect: (i) => _submit(i, question.sortOrder),
                    onNext: () => _next(tierUnlocked.length),
                  );
                },
              );
            },
          );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandBadge(size: 28),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Practice: ${widget.subtopicTitle}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
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

/// Shared by [_DifficultyChip] (in-quiz badge) and [_TierTile] (picker
/// tile) so a tier reads as the same color in both places.
Color _tierColor(BuildContext context, String difficulty) => switch (difficulty) {
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

class _DifficultyChip extends StatelessWidget {
  const _DifficultyChip({required this.difficulty});

  final String difficulty;

  @override
  Widget build(BuildContext context) {
    final color = _tierColor(context, difficulty);
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
    required this.onBackToTiers,
    required this.onFinished,
  });

  final String medal;
  final int firstTryCorrectCount;
  final int questionCount;

  /// Returns to this subtopic's tier picker so the student can practice
  /// another difficulty without leaving the subtopic.
  final VoidCallback onBackToTiers;
  final VoidCallback onFinished;

  Color _medalColor(BuildContext context) => switch (medal) {
    'Diamond' => const Color(0xFF4FC3F7),
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
            Icon(
              medal == 'Diamond' ? Icons.diamond : Icons.emoji_events,
              size: 64,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              medal == 'None' ? 'Nice work!' : '$medal medal!',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$firstTryCorrectCount of $questionCount correct on the first try.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton(
                  onPressed: onBackToTiers,
                  child: const Text('Choose another level'),
                ),
                FilledButton(onPressed: onFinished, child: const Text('Continue')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown up front, before any question loads: one tile per difficulty this
/// subtopic actually has, in Easy → Medium → Challenge/Hard → Advanced
/// order. A free student sees every tier that exists (so they know Challenge
/// and Advanced exist at all) but a locked one shows a lock icon instead of
/// a chevron and explains the paywall on tap rather than starting a quiz —
/// this is what replaced the old end-of-quiz upsell card.
class _TierPickerView extends StatelessWidget {
  const _TierPickerView({
    required this.questions,
    required this.subtopicTitle,
    required this.onSelectTier,
  });

  final List<PracticeQuestion> questions;
  final String subtopicTitle;
  final void Function(String tier) onSelectTier;

  static const _tierOrder = ['Easy', 'Medium', 'Challenge', 'Hard', 'Advanced'];

  @override
  Widget build(BuildContext context) {
    final byTier = <String, List<PracticeQuestion>>{};
    for (final q in questions) {
      byTier.putIfAbsent(q.difficulty, () => []).add(q);
    }
    final tiers = _tierOrder.where(byTier.containsKey).toList();

    if (tiers.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No practice questions for this topic yet — check back soon.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Choose a difficulty', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          '$subtopicTitle — pick a level to practice.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        for (final tier in tiers) ...[
          _TierTile(
            tier: tier,
            count: byTier[tier]!.length,
            // Locking is per-tier, not per-question — a free student's
            // whole gated tier comes back with `locked: true` on every row
            // (see list_questions() in schema_subscriptions.sql), so the
            // first question's flag speaks for the tier.
            locked: byTier[tier]!.first.locked,
            onTap: () {
              if (byTier[tier]!.first.locked) {
                _showProDialog(context, tier);
              } else {
                onSelectTier(tier);
              }
            },
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  void _showProDialog(BuildContext context, String tier) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.workspace_premium),
        title: Text('$tier is a Pro feature'),
        content: const Text(
          'Challenge and Advanced questions need a Pro subscription. Ask '
          'a parent to contact us to upgrade your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _TierTile extends StatelessWidget {
  const _TierTile({
    required this.tier,
    required this.count,
    required this.locked,
    required this.onTap,
  });

  final String tier;
  final int count;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tierColor = _tierColor(context, tier);
    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tierColor.withValues(alpha: 0.35), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: tierColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tier,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$count question${count == 1 ? '' : 's'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (locked)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline, size: 18, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      'Pro',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              else
                Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
            ],
          ),
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
