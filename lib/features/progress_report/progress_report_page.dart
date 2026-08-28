import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/brand_badge.dart';
import '../../models/progress_status.dart';
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

/// One bar. [percent] is already resolved to 0-100 by whichever chart
/// built it — the overall chart's "25% per difficulty level" scheme and a
/// per-difficulty chart's "fraction of topics that cleared this one tier"
/// are different shapes of number, so there's no single total/completed
/// pair that fits both; each chart just hands over the finished percent
/// plus a human-readable [detail] for the tooltip. [hasData] is false
/// when there was nothing at all to assess (no topic in this unit has
/// this tier, or the unit has no topics yet) — distinct from a real 0%.
class _Bar {
  const _Bar({
    required this.unitTitle,
    required this.percent,
    required this.detail,
    required this.hasData,
  });

  final String unitTitle;
  final double percent;
  final String detail;
  final bool hasData;
}

const _chartHeight = 150.0;
const _barWidth = 44.0;
const _columnWidth = 96.0;

/// Bar charts of practice-test progress in the current course: an overall
/// mastery % per unit, plus one chart per difficulty tier (Easy, Medium,
/// Challenge/Hard, Advanced) showing what fraction of that unit's topics
/// have fully cleared that tier. Colored with the same traffic-signal
/// palette (ProgressStatus.fromScorePercent) already used on the mindmap
/// and sidebar. Reachable from the sidebar's "Progress Report" link,
/// embedded in the main pane the same way Profile & Preferences is (see
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
      final reportAsync = ref.watch(progressReportProvider(course.code));

      body = reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Could not load your progress report: $error')),
        data: (rows) {
          final overallBars = <_Bar>[];
          final tierCharts = <_TierBucket, List<_Bar>>{};
          for (final unit in units) {
            final unitRows = rows.where((r) => r.unitCode == unit.code).toList();

            // Overall: each topic (subtopic) is worth 25% per difficulty
            // level it has fully cleared — Easy/Medium/Challenge-or-Hard/
            // Advanced — out of a fixed 4 slots, not however many tiers
            // that topic actually has. A course/topic missing a level
            // (e.g. MCR3U/MHF4U have no Challenge or Advanced split) just
            // leaves that slot at 0%, capping what it can reach — same
            // rule uniformly, no special-casing per course. The unit's
            // own bar is the plain average of its topics' percents.
            final subtopicCodes = unitRows.map((r) => r.subtopicCode).toSet();
            final subtopicPercents = <double>[];
            for (final subtopicCode in subtopicCodes) {
              final subtopicRows = unitRows
                  .where((r) => r.subtopicCode == subtopicCode)
                  .toList();
              var completedSlots = 0;
              for (final bucket in _TierBucket.values) {
                final matching = subtopicRows.where((r) => _bucketFor(r.difficulty) == bucket);
                if (matching.isNotEmpty && matching.every((r) => r.isComplete)) {
                  completedSlots++;
                }
              }
              subtopicPercents.add(completedSlots * 25.0);
            }
            final unitPercent = subtopicPercents.isEmpty
                ? 0.0
                : subtopicPercents.reduce((a, b) => a + b) / subtopicPercents.length;
            overallBars.add(
              _Bar(
                unitTitle: unit.title,
                percent: unitPercent,
                hasData: subtopicPercents.isNotEmpty,
                detail: subtopicPercents.isEmpty
                    ? 'No practice questions yet.'
                    : '${unitPercent.round()}% — averaged across '
                          '${subtopicPercents.length} '
                          '${subtopicPercents.length == 1 ? 'topic' : 'topics'} '
                          '(25% per difficulty level fully completed)',
              ),
            );

            // Per-difficulty: what fraction of this unit's topics have
            // fully cleared this one specific tier — unrelated to the 25%
            // weighting above, which is only about the combined score.
            for (final bucket in _TierBucket.values) {
              final bucketRows = unitRows
                  .where((r) => _bucketFor(r.difficulty) == bucket)
                  .toList();
              if (bucketRows.isEmpty) continue;
              final completed = bucketRows.where((r) => r.isComplete).length;
              (tierCharts[bucket] ??= []).add(
                _Bar(
                  unitTitle: unit.title,
                  percent: 100.0 * completed / bucketRows.length,
                  hasData: true,
                  detail: '$completed of ${bucketRows.length} topics complete',
                ),
              );
            }
          }
          return _ProgressReportBody(
            courseTitle: course.title,
            overallBars: overallBars,
            tierCharts: tierCharts,
          );
        },
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
}

class _ProgressReportBody extends StatelessWidget {
  const _ProgressReportBody({
    required this.courseTitle,
    required this.overallBars,
    required this.tierCharts,
  });

  final String courseTitle;
  final List<_Bar> overallBars;
  final Map<_TierBucket, List<_Bar>> tierCharts;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (overallBars.isEmpty) {
      return const Center(child: Text('No topics to report on yet.'));
    }

    final assessable = overallBars.where((b) => b.hasData).toList();
    final overall = assessable.isEmpty
        ? 0.0
        : assessable.map((b) => b.percent).reduce((a, b) => a + b) / assessable.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress Report',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Each topic in $courseTitle is worth 25% per difficulty level '
            '(Easy, Medium, Challenge/Hard, Advanced) fully completed in Practice '
            'Test — a topic missing a level (or a course without one) simply '
            'can\'t fill that 25%. A unit\'s bar is the average across its topics.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: ProgressStatus.fromScorePercent(
                    overall,
                  ).color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: ProgressStatus.fromScorePercent(
                      overall,
                    ).color.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'Overall mastery: ${overall.round()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: ProgressStatus.fromScorePercent(overall).color,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _Legend()),
            ],
          ),
          const SizedBox(height: 24),
          _ChartSection(title: 'Overall, by unit', bars: overallBars),
          for (final bucket in _TierBucket.values)
            if (tierCharts[bucket] case final bars? when bars.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: _ChartSection(title: bucket.label, bars: bars),
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
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        for (final status in ProgressStatus.values)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: status.color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Text(status.label, style: Theme.of(context).textTheme.bodySmall),
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

class _BarColumn extends StatelessWidget {
  const _BarColumn({required this.bar});

  final _Bar bar;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final status = !bar.hasData
        ? ProgressStatus.notStarted
        : ProgressStatus.fromScorePercent(bar.percent);
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
                    if (bar.percent > 0)
                      Text(
                        '${bar.percent.round()}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: status.color,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Container(
                      width: _barWidth,
                      height: barHeight < 3 ? 3 : barHeight,
                      decoration: BoxDecoration(
                        color: status.color,
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
