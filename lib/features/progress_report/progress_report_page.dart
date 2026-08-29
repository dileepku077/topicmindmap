import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/brand_badge.dart';
import '../../domain/mastery_calculator.dart';
import '../../domain/mastery_config.dart';
import '../../models/subtopic.dart';
import '../../models/subtopic_attempt_stat.dart';
import '../../models/subtopic_mastery.dart';
import '../../models/unit.dart';
import '../../state/curriculum_providers.dart';
import '../../state/progress_providers.dart';

/// One difficulty's own chart gets its own bucket — 'Hard' and 'Challenge'
/// share one (same rank, never both in the same course; see
/// award_medal()'s own comment on this in schema_practice.sql), so a
/// course using either label still gets exactly four charts, not five.
enum _TierBucket { easy, medium, challengeOrHard, advanced }

extension on _TierBucket {
  String get label => switch (this) {
    _TierBucket.easy => 'Easy',
    _TierBucket.medium => 'Medium',
    _TierBucket.challengeOrHard => 'Challenge / Hard',
    _TierBucket.advanced => 'Advanced',
  };
}

_TierBucket? _bucketFor(String difficulty) => switch (difficulty) {
  'Easy' => _TierBucket.easy,
  'Medium' => _TierBucket.medium,
  'Hard' || 'Challenge' => _TierBucket.challengeOrHard,
  'Advanced' => _TierBucket.advanced,
  _ => null,
};

/// One bar. [percent] and [medal] are already resolved by whichever chart
/// built it — the overall chart's weighted mastery % and a per-difficulty
/// chart's plain accuracy % are different numbers, but both render the
/// same way. [hasData] is false when there wasn't enough evidence to
/// report anything (see MasteryResult.insufficientData) — distinct from a
/// real 0%.
class _Bar {
  const _Bar({
    required this.unitTitle,
    required this.percent,
    required this.medal,
    required this.detail,
    required this.hasData,
  });

  final String unitTitle;
  final double percent;
  final String medal;
  final String detail;
  final bool hasData;
}

const _chartHeight = 150.0;
const _barWidth = 44.0;
const _columnWidth = 96.0;
const _config = MasteryConfig.standard;

/// A course's mastery report: an overall mastery % and medal, "topics
/// mastered" count, a "next goal" suggestion, a mastery-by-unit chart, and
/// four difficulty-accuracy charts (Easy/Medium/Challenge-or-Hard/
/// Advanced). Mastery is deliberately not the same number as how much
/// practice has been attempted — see lib/domain/mastery_calculator.dart —
/// a student who's attempted a lot but mostly gotten questions wrong reads
/// as low mastery here even though their completion count is high.
///
/// Reachable from the sidebar's "Progress Report" link, embedded in the
/// main pane the same way Profile & Preferences is (see
/// mindmap_page.dart / classroom_view.dart) so the sidebar stays on
/// screen.
class ProgressReportPage extends ConsumerWidget {
  const ProgressReportPage({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(selectedCourseProvider);

    final Widget body;
    if (course == null) {
      body = const Center(child: Text('No course selected.'));
    } else {
      final units = [...ref.watch(courseUnitsProvider)]
        ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      final subtopics = ref.watch(courseSubtopicsProvider);
      final statsAsync = ref.watch(subtopicAttemptStatsProvider(course.code));

      body = statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Could not load your progress report: $error')),
        data: (rows) => _buildReport(course.title, units, subtopics, rows),
      );
    }

    if (embedded) return body;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrandBadge(size: 28),
            SizedBox(width: 10),
            Text('Progress Report'),
          ],
        ),
      ),
      body: body,
    );
  }

  Widget _buildReport(
    String courseTitle,
    List<Unit> units,
    List<Subtopic> subtopics,
    List<SubtopicAttemptStat> rows,
  ) {
    // Every topic in the curriculum, whether or not it's been touched —
    // "X of Y topics mastered" needs Y to be the whole course, not just
    // whatever's been attempted so far.
    var totalTopics = 0;
    var topicsMastered = 0;

    final overallBars = <_Bar>[];
    final tierCharts = <_TierBucket, List<_Bar>>{};
    final courseHasBucket = {
      for (final bucket in _TierBucket.values)
        bucket: rows.any((r) => _bucketFor(r.difficulty) == bucket),
    };

    final courseStats = <String, _Pooled>{};
    var nextGoal = _NextGoal.none;

    for (final unit in units) {
      final unitSubtopics = subtopics.where((s) => s.unitId == unit.id).toList();
      totalTopics += unitSubtopics.length;

      // Pool every subtopic's attempts in this unit into one set of
      // DifficultyStats, per difficulty, then run the SAME calculator
      // used everywhere else — a unit's mastery is a real weighted
      // calculation over all its evidence, not an average of its topics'
      // separately-rounded percentages.
      final pooled = <String, _Pooled>{};
      for (final subtopic in unitSubtopics) {
        final subtopicRows = rows.where(
          (r) => r.unitCode == unit.code && r.subtopicCode == subtopic.code,
        );
        final subtopicPooled = <String, _Pooled>{};
        for (final row in subtopicRows) {
          (pooled[row.difficulty] ??= _Pooled()).add(row);
          (subtopicPooled[row.difficulty] ??= _Pooled()).add(row);
          (courseStats[row.difficulty] ??= _Pooled()).add(row);
        }
        final subtopicResult = calculateMastery(
          subtopicPooled.entries.map((e) => e.value.toStats(e.key)).toList(),
        );
        if (!subtopicResult.insufficientData &&
            (subtopicResult.medal == 'Gold' || subtopicResult.medal == 'Diamond')) {
          topicsMastered++;
        }
      }

      final unitResult = calculateMastery(
        pooled.entries.map((e) => e.value.toStats(e.key)).toList(),
      );

      overallBars.add(
        _Bar(
          unitTitle: unit.title,
          percent: unitResult.masteryPercent,
          medal: unitResult.medal,
          hasData: !unitResult.insufficientData,
          detail: unitResult.insufficientData
              ? 'Keep practicing — not enough attempts yet to score this unit.'
              : '${unitResult.masteryPercent.round()}% mastery — '
                    '${unitResult.medal} — ${unitResult.totalAttempted} questions attempted',
        ),
      );

      if (!unitResult.insufficientData) {
        final gap = _gapToNextMedal(unitResult.medal, unitResult.masteryPercent);
        if (gap != null && gap.gap > 0 && gap.gap < nextGoal.gap) {
          nextGoal = _NextGoal(
            unitTitle: unit.title,
            currentPercent: unitResult.masteryPercent,
            currentMedal: unitResult.medal,
            targetPercent: gap.target,
            targetMedal: gap.targetMedal,
            gap: gap.gap,
          );
        }
      }

      for (final bucket in _TierBucket.values) {
        if (!courseHasBucket[bucket]!) continue;
        final bucketRows = rows.where(
          (r) => r.unitCode == unit.code && _bucketFor(r.difficulty) == bucket,
        );
        final p = _Pooled();
        for (final row in bucketRows) {
          p.add(row);
        }
        final stats = p.toStats(bucket.label);
        final insufficient = stats.attempted < _config.minAttemptsForRating;
        (tierCharts[bucket] ??= []).add(
          _Bar(
            unitTitle: unit.title,
            percent: stats.accuracyPercent,
            medal: insufficient ? 'None' : bandForPercent(stats.accuracyPercent),
            hasData: stats.attempted > 0 && !insufficient,
            detail: stats.attempted == 0
                ? 'Not attempted yet.'
                : insufficient
                ? 'Only ${stats.attempted} attempted so far — a few more before this scores.'
                : '${stats.accuracyPercent.round()}% accuracy, first try '
                      '(${stats.correct} of ${stats.attempted} attempted)',
          ),
        );
      }
    }

    final courseResult = calculateMastery(
      courseStats.entries.map((e) => e.value.toStats(e.key)).toList(),
    );

    return _ProgressReportBody(
      courseTitle: courseTitle,
      overall: courseResult,
      topicsMastered: topicsMastered,
      totalTopics: totalTopics,
      overallBars: overallBars,
      tierCharts: tierCharts,
      nextGoal: nextGoal,
    );
  }
}

/// Accumulates raw attempt/correct/first-try counts across however many
/// rows (subtopics, tiers) get pooled into one bucket, then converts to
/// the DifficultyStats shape calculateMastery() actually takes.
class _Pooled {
  int attempted = 0;
  int correct = 0;
  int firstTryCorrect = 0;

  void add(SubtopicAttemptStat row) {
    attempted += row.attempted;
    correct += row.correct;
    firstTryCorrect += row.firstTryCorrect;
  }

  double get accuracyPercent => attempted == 0 ? 0 : 100.0 * firstTryCorrect / attempted;

  DifficultyStats toStats(String difficulty) => DifficultyStats(
    difficulty: difficulty,
    attempted: attempted,
    correct: correct,
    firstTryCorrect: firstTryCorrect,
  );
}

/// How far a medal is from the next one up, and what that next one is —
/// used to find the unit closest to leveling up for the "Next Goal" card.
class _MedalGap {
  const _MedalGap({required this.gap, required this.target, required this.targetMedal});
  final double gap;
  final double target;
  final String targetMedal;
}

_MedalGap? _gapToNextMedal(String medal, double percent) {
  final (target, targetMedal) = switch (medal) {
    'None' => (_config.bronzeThreshold, 'Bronze'),
    'Bronze' => (_config.silverThreshold, 'Silver'),
    'Silver' => (_config.goldThreshold, 'Gold'),
    'Gold' => (_config.diamondThreshold, 'Diamond'),
    _ => (null, null), // Diamond — nothing higher to aim for
  };
  if (target == null || targetMedal == null) return null;
  return _MedalGap(gap: target - percent, target: target, targetMedal: targetMedal);
}

class _NextGoal {
  const _NextGoal({
    required this.unitTitle,
    required this.currentPercent,
    required this.currentMedal,
    required this.targetPercent,
    required this.targetMedal,
    required this.gap,
  });

  final String? unitTitle;
  final double currentPercent;
  final String currentMedal;
  final double targetPercent;
  final String? targetMedal;
  final double gap;

  static const none = _NextGoal(
    unitTitle: null,
    currentPercent: 0,
    currentMedal: 'None',
    targetPercent: 0,
    targetMedal: null,
    gap: double.infinity,
  );

  bool get hasGoal => unitTitle != null;
}

class _ProgressReportBody extends StatelessWidget {
  const _ProgressReportBody({
    required this.courseTitle,
    required this.overall,
    required this.topicsMastered,
    required this.totalTopics,
    required this.overallBars,
    required this.tierCharts,
    required this.nextGoal,
  });

  final String courseTitle;
  final MasteryResult overall;
  final int topicsMastered;
  final int totalTopics;
  final List<_Bar> overallBars;
  final Map<_TierBucket, List<_Bar>> tierCharts;
  final _NextGoal nextGoal;

  @override
  Widget build(BuildContext context) {
    if (overallBars.isEmpty) {
      return const Center(child: Text('No topics to report on yet.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OverallCard(
            courseTitle: courseTitle,
            overall: overall,
            topicsMastered: topicsMastered,
            totalTopics: totalTopics,
          ),
          const SizedBox(height: 14),
          if (nextGoal.hasGoal) _NextGoalCard(goal: nextGoal),
          const SizedBox(height: 20),
          Text(
            'Mastery % weighs harder questions more than easy ones, and needs a '
            'few attempts before it means anything — it\'s a different number '
            'from how much you\'ve practiced.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          const _Legend(),
          const SizedBox(height: 20),
          _ChartSection(title: 'Mastery, by unit', bars: overallBars),
          for (final bucket in _TierBucket.values)
            if (tierCharts[bucket] case final bars? when bars.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: _ChartSection(title: '${bucket.label} accuracy', bars: bars),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: _MissingTierNote(label: bucket.label),
              ),
        ],
      ),
    );
  }
}

class _OverallCard extends StatelessWidget {
  const _OverallCard({
    required this.courseTitle,
    required this.overall,
    required this.topicsMastered,
    required this.totalTopics,
  });

  final String courseTitle;
  final MasteryResult overall;
  final int topicsMastered;
  final int totalTopics;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _medalOrNeutralColor(overall.medal);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            courseTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          if (overall.insufficientData) ...[
            Text(
              'Keep practicing — we\'re still learning about your progress.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${overall.masteryPercent.round()}%',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Overall Mastery',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _MedalPill(medal: overall.medal),
            const SizedBox(height: 10),
            Text(
              '$topicsMastered / $totalTopics topics mastered',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}

class _NextGoalCard extends StatelessWidget {
  const _NextGoalCard({required this.goal});

  final _NextGoal goal;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.flag_outlined, color: scheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎯 Your next goal',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: scheme.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  '${goal.unitTitle} — ${goal.currentPercent.round()}%. '
                  'Raise it to ${goal.targetPercent.round()}% to reach ${goal.targetMedal}.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MedalPill extends StatelessWidget {
  const _MedalPill({required this.medal});

  final String medal;

  @override
  Widget build(BuildContext context) {
    if (medal == 'None') return const SizedBox.shrink();
    final color = medalColor(medal);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MedalBadge(medal: medal, size: 18),
          const SizedBox(width: 6),
          Text(medal, style: TextStyle(color: color, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _MissingTierNote extends StatelessWidget {
  const _MissingTierNote({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          'This course doesn\'t have a $label tier.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _ChartSection extends StatelessWidget {
  const _ChartSection({required this.title, required this.bars});

  final String title;
  final List<_Bar> bars;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        SizedBox(
          height: _chartHeight + 66,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _YAxis(),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [for (final bar in bars) _BarColumn(bar: bar)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        for (final medal in const ['Bronze', 'Silver', 'Gold', 'Diamond'])
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: medalColor(medal), shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Text(medal, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
      ],
    );
  }
}

class _YAxis extends StatelessWidget {
  const _YAxis();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: _chartHeight,
      width: 36,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final tick in const [100, 75, 50, 25, 0])
            Text(
              '$tick%',
              style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
            ),
        ],
      ),
    );
  }
}

/// Neutral grey for 'None'/insufficient data, otherwise the medal's own
/// color (see medalColor() in subtopic_mastery.dart) — used instead of
/// ProgressStatus.fromScorePercent's bands here since this page's numbers
/// are scored against the medal thresholds directly, not that separate
/// traffic-signal scale.
Color _medalOrNeutralColor(String medal) => medal == 'None' ? const Color(0xFF9AA0A6) : medalColor(medal);

class _BarColumn extends StatelessWidget {
  const _BarColumn({required this.bar});

  final _Bar bar;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = bar.hasData ? _medalOrNeutralColor(bar.medal) : const Color(0xFF9AA0A6);
    final barHeight = (_chartHeight * (bar.percent / 100)).clamp(0.0, _chartHeight);

    return SizedBox(
      width: _columnWidth,
      child: Tooltip(
        message: '${bar.unitTitle}\n${bar.detail}',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _chartHeight,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (bar.hasData)
                      Text(
                        '${bar.percent.round()}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      )
                    else
                      Icon(Icons.more_horiz, size: 14, color: color),
                    const SizedBox(height: 4),
                    Container(
                      width: _barWidth,
                      height: !bar.hasData
                          ? 3
                          : (barHeight < 3 ? 3 : barHeight),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 44,
              child: Text(
                bar.unitTitle,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
