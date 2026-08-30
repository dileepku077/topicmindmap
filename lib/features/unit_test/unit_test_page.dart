import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/brand_badge.dart';
import '../../models/progress_status.dart';
import '../../models/subtopic.dart';
import '../../models/unit_test.dart';
import '../../state/curriculum_providers.dart';
import '../../state/lesson_providers.dart';
import '../../state/unit_test_providers.dart';
import '../lesson/lesson_page.dart';

/// A graded mock test covering a whole unit — every subtopic in one
/// paper, one answer per question with no retry, and no feedback at all
/// until the paper is handed in. See supabase/schema_unit_tests.sql for
/// why this is a different feature from Practice Test rather than a mode
/// of it, and math-tutor's astro_sections.sql (Jithu) for the original
/// design this was ported from.
class UnitTestPage extends ConsumerStatefulWidget {
  const UnitTestPage({
    super.key,
    required this.courseCode,
    required this.unitCode,
    required this.unitTitle,
    this.embedded = false,
  });

  final String courseCode;
  final String unitCode;
  final String unitTitle;

  /// True when embedded in the classroom view's main pane (with its own
  /// breadcrumb trail above it, see classroom_view.dart) instead of shown
  /// as a full-screen route — same convention PracticeTestPage already
  /// uses. Embedded mode skips this widget's own Scaffold/AppBar/close
  /// button entirely; the breadcrumb's own crumbs are the way back, and
  /// since every answer is saved as it's picked, there's nothing to
  /// confirm on the way out.
  final bool embedded;

  @override
  ConsumerState<UnitTestPage> createState() => _UnitTestPageState();
}

class _UnitTestPageState extends ConsumerState<UnitTestPage> {
  UnitTestStart? _start;
  List<UnitTestItem> _paper = const [];
  final Map<int, int> _answers = {};
  int _index = 0;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  UnitTestScore? _score;
  List<UnitTestBreakdown> _breakdown = const [];
  List<UnitTestReview> _review = const [];
  bool _showReview = false;

  @override
  void initState() {
    super.initState();
    _begin();
  }

  Future<void> _begin() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(unitTestRepositoryProvider);
      final start = await repo.start(
        courseCode: widget.courseCode,
        unitCode: widget.unitCode,
      );
      final paper = await repo.paper(start.testId);
      if (!mounted) return;
      setState(() {
        _start = start;
        _paper = paper;
        _answers.clear();
        for (final item in paper) {
          if (item.chosenIndex != null)
            _answers[item.itemNo] = item.chosenIndex!;
        }
        // A resumed paper opens at the first unanswered question rather
        // than at the top, so coming back from a dropped connection
        // doesn't mean scrolling past work already done.
        final firstUnanswered = paper.indexWhere((i) => i.chosenIndex == null);
        _index = firstUnanswered < 0 ? 0 : firstUnanswered;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'That test could not be started: $error';
        _loading = false;
      });
    }
  }

  Future<void> _choose(int chosen) async {
    final item = _paper[_index];
    setState(() {
      _answers[item.itemNo] = chosen;
      _saving = true;
    });
    try {
      await ref
          .read(unitTestRepositoryProvider)
          .answer(
            testId: _start!.testId,
            itemNo: item.itemNo,
            chosenIndex: chosen,
          );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('That answer did not save. Tap it again.'),
          ),
        );
      }
    }
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    try {
      final repo = ref.read(unitTestRepositoryProvider);
      final score = await repo.finish(_start!.testId);
      final breakdown = await repo.result(_start!.testId);
      final review = await repo.review(_start!.testId);
      if (!mounted) return;
      setState(() {
        _score = score;
        _breakdown = breakdown;
        _review = review;
        _saving = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'That test could not be marked: $error';
      });
    }
  }

  void _goBack() => setState(() => _index--);

  void _goNext() => setState(() => _index++);

  void _toggleReview() => setState(() => _showReview = !_showReview);

  Future<void> _retake() async {
    setState(() {
      _score = null;
      _breakdown = const [];
      _review = const [];
      _showReview = false;
    });
    await _begin();
  }

  Future<void> _confirmLeave() async {
    if (_score != null) {
      if (mounted) context.pop();
      return;
    }
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Leave the test?'),
        content: const Text(
          'Your answers are saved. Coming back opens the same paper at the '
          "first question you haven't answered.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep going'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final answered = _answers.length;
    final total = _paper.length;

    final content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: _body(context),
        ),
      ),
    );

    if (widget.embedded) {
      return Column(
        children: [
          if (_score == null && total > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$answered / $total answered',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          Expanded(child: content),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Leave the test',
          onPressed: _confirmLeave,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandBadge(size: 26),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _score != null ? 'Your result' : '${widget.unitTitle} — Test',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (_score == null && total > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '$answered / $total',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(child: content),
    );
  }

  Widget _body(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 120),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: _begin, child: const Text('Try again')),
          ],
        ),
      );
    }
    if (_score != null) {
      return _ResultsView(
        courseCode: widget.courseCode,
        unitCode: widget.unitCode,
        score: _score!,
        breakdown: _breakdown,
        review: _review,
        showReview: _showReview,
        saving: _saving,
        onToggleReview: _toggleReview,
        onRetake: _retake,
      );
    }
    if (_paper.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: Text('This unit has no test available yet.')),
      );
    }
    return _PaperView(
      paper: _paper,
      answers: _answers,
      index: _index,
      isWarmup: _start!.isWarmup,
      saving: _saving,
      onChoose: _choose,
      onBack: _goBack,
      onNext: _goNext,
      onFinish: _finish,
    );
  }
}

class _PaperView extends StatelessWidget {
  const _PaperView({
    required this.paper,
    required this.answers,
    required this.index,
    required this.isWarmup,
    required this.saving,
    required this.onChoose,
    required this.onBack,
    required this.onNext,
    required this.onFinish,
  });

  final List<UnitTestItem> paper;
  final Map<int, int> answers;
  final int index;
  final bool isWarmup;
  final bool saving;
  final void Function(int chosenIndex) onChoose;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final item = paper[index];
    final chosen = answers[item.itemNo];
    final isLast = index + 1 >= paper.length;
    final allAnswered = answers.length >= paper.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Question ${index + 1} of ${paper.length}  ·  ${item.difficulty}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            if (isWarmup)
              Text(
                'WARM-UP',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: scheme.secondary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: (index + 1) / paper.length,
            minHeight: 5,
            backgroundColor: scheme.surfaceContainerHighest,
          ),
        ),
        const SizedBox(height: 20),
        SelectableText(
          item.prompt,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        // Nothing here says whether the choice was right. A picked option
        // just looks picked, and stays changeable until the paper is
        // handed in — no per-tap feedback the way Practice Test gives.
        for (var i = 0; i < item.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _TestOptionTile(
              text: item.options[i].text,
              picked: chosen == i,
              enabled: !saving,
              onTap: () => onChoose(i),
            ),
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            if (index > 0) ...[
              OutlinedButton(onPressed: onBack, child: const Text('Back')),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: isLast
                  ? FilledButton(
                      onPressed: !allAnswered || saving ? null : onFinish,
                      child: Text(saving ? 'Saving…' : 'Hand it in'),
                    )
                  : FilledButton(onPressed: onNext, child: const Text('Next')),
            ),
          ],
        ),
        if (isLast && !allAnswered) ...[
          const SizedBox(height: 10),
          Text(
            '${paper.length - answers.length} still unanswered. '
            'Use Back to find them.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}

class _TestOptionTile extends StatelessWidget {
  const _TestOptionTile({
    required this.text,
    required this.picked,
    required this.enabled,
    required this.onTap,
  });

  final String text;
  final bool picked;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: picked
          ? scheme.primary.withValues(alpha: 0.08)
          : scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: picked ? scheme.primary : scheme.outlineVariant,
              width: picked ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                picked
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 18,
                color: picked ? scheme.primary : scheme.outlineVariant,
              ),
              const SizedBox(width: 12),
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

class _ResultsView extends ConsumerWidget {
  const _ResultsView({
    required this.courseCode,
    required this.unitCode,
    required this.score,
    required this.breakdown,
    required this.review,
    required this.showReview,
    required this.saving,
    required this.onToggleReview,
    required this.onRetake,
  });

  final String courseCode;
  final String unitCode;
  final UnitTestScore score;
  final List<UnitTestBreakdown> breakdown;
  final List<UnitTestReview> review;
  final bool showReview;
  final bool saving;
  final VoidCallback onToggleReview;
  final VoidCallback onRetake;

  /// subtopic_code -> title, resolved from whatever curriculum content is
  /// already loaded — a unit test never needs its own copy of this data.
  Map<String, String> _subtopicTitles(WidgetRef ref) {
    final units = ref.watch(unitsProvider).value ?? const [];
    final unit = units.where((u) => u.code == unitCode).firstOrNull;
    if (unit == null) return const {};
    final subtopics = ref.watch(subtopicsProvider).value ?? const <Subtopic>[];
    return {
      for (final s in subtopics.where((s) => s.unitId == unit.id))
        s.code: s.title,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final titles = _subtopicTitles(ref);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        Text(
          '${score.scorePercent}%',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            // This is the student's own score, not a question's
            // difficulty -- colored with the app's one progress palette
            // (ProgressStatus) rather than a separate scale, same
            // reasoning as everywhere else progress shows up.
            color: ProgressStatus.fromScorePercent(
              score.scorePercent.toDouble(),
            ).color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${score.correct} of ${score.total} right'
          '${score.seconds >= 60 ? '  ·  ${score.seconds ~/ 60} min' : ''}'
          '${score.isWarmup ? '  ·  warm-up paper' : ''}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'This test does not affect your medals or mindmap progress — take '
          'it again whenever you like.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 28),
        Text(
          'Where the marks went',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        for (final row in breakdown)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _BreakdownRow(
              title: titles[row.subtopicCode] ?? row.subtopicCode,
              row: row,
              lessonId: lessonIdFor(
                courseCode: courseCode,
                subtopicCode: row.subtopicCode,
              ),
            ),
          ),
        if (review.isNotEmpty) ...[
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onToggleReview,
              icon: Icon(showReview ? Icons.expand_less : Icons.expand_more),
              label: Text(
                showReview ? 'Hide the questions' : 'Go through the questions',
              ),
            ),
          ),
          if (showReview)
            for (final row in review)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ReviewRow(
                  row: row,
                  subtopicTitle: titles[row.subtopicCode],
                ),
              ),
        ],
        const SizedBox(height: 20),
        FilledButton(
          onPressed: saving ? null : onRetake,
          child: Text(saving ? 'Saving…' : 'Take it again'),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.pop(),
          style: TextButton.styleFrom(foregroundColor: scheme.onSurfaceVariant),
          child: const Text('Back to the unit'),
        ),
      ],
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.title,
    required this.row,
    required this.lessonId,
  });

  final String title;
  final UnitTestBreakdown row;
  final String? lessonId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            '${row.got}/${row.asked}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 44,
            child: Text(
              '${row.percent}%',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          if (lessonId != null)
            IconButton(
              tooltip: 'Review the lesson',
              icon: const Icon(Icons.menu_book_outlined, size: 20),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => LessonPage(lessonId: lessonId!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.row, required this.subtopicTitle});

  final UnitTestReview row;
  final String? subtopicTitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = row.wasCorrect ? Colors.green : scheme.error;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                row.wasCorrect ? Icons.check_circle : Icons.cancel,
                size: 18,
                color: color,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${subtopicTitle ?? row.subtopicCode} · ${row.difficulty}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            row.prompt,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (row.chosenText != null) ...[
            const SizedBox(height: 6),
            Text(
              'You answered: ${row.chosenText}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (!row.wasCorrect && row.feedback != null) ...[
            const SizedBox(height: 4),
            Text(row.feedback!, style: TextStyle(color: color, fontSize: 12.5)),
          ],
        ],
      ),
    );
  }
}
