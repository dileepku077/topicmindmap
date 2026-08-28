import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/brand_badge.dart';
import '../../models/progress_status.dart';
import '../../models/subtopic_progress.dart';
import '../../state/curriculum_providers.dart';
import '../../state/progress_providers.dart';

/// One unit's bar — mastery % rolled up across every subtopic and
/// difficulty tier in it, once its course's units/subtopics and progress
/// rows have both been resolved and matched up by (unitCode,
/// subtopicCode). Rolling up to the unit ("topic") level rather than
/// showing one bar per subtopic keeps the chart to a handful of bars per
/// course instead of dozens.
class _Bar {
  const _Bar({
    required this.unitTitle,
    required this.subtopicCount,
    required this.tiersTotal,
    required this.tiersCompleted,
    required this.masteryPercent,
  });

  final String unitTitle;
  final int subtopicCount;
  final int tiersTotal;
  final int tiersCompleted;
  final double masteryPercent;
}

const _chartHeight = 220.0;
const _barWidth = 56.0;
const _columnWidth = 110.0;

/// A bar chart of mastery % in the current course — one bar per unit
/// ("topic"), colored with the same traffic-signal palette
/// (ProgressStatus.fromScorePercent) already used on the mindmap and
/// sidebar, so "what does orange mean here" never needs re-explaining.
/// Deliberately one bar per unit rather than per subtopic — a handful of
/// bars reads at a glance, where dozens of subtopic bars wouldn't.
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
      final reportAsync = ref.watch(progressReportProvider(course.code));

      body = reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Could not load your progress report: $error')),
        data: (rows) {
          final byKey = <String, SubtopicProgress>{
            for (final row in rows) '${row.unitCode}/${row.subtopicCode}': row,
          };
          final bars = <_Bar>[];
          for (final unit in units) {
            final unitSubtopics = subtopics.where((s) => s.unitId == unit.id);
            var tiersTotal = 0;
            var tiersCompleted = 0;
            for (final subtopic in unitSubtopics) {
              final row = byKey['${unit.code}/${subtopic.code}'];
              tiersTotal += row?.tiersTotal ?? 0;
              tiersCompleted += row?.tiersCompleted ?? 0;
            }
            bars.add(
              _Bar(
                unitTitle: unit.title,
                subtopicCount: unitSubtopics.length,
                tiersTotal: tiersTotal,
                tiersCompleted: tiersCompleted,
                // Weighted by tier count across the whole unit, not a
                // plain average of each subtopic's own %, so a subtopic
                // with more tiers pulls the unit's bar proportionally
                // more than one with fewer.
                masteryPercent: tiersTotal == 0
                    ? 0
                    : 100.0 * tiersCompleted / tiersTotal,
              ),
            );
          }
          return _ProgressReportBody(courseTitle: course.title, bars: bars);
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
  const _ProgressReportBody({required this.courseTitle, required this.bars});

  final String courseTitle;
  final List<_Bar> bars;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (bars.isEmpty) {
      return const Center(child: Text('No topics to report on yet.'));
    }

    final assessable = bars.where((b) => b.tiersTotal > 0).toList();
    final overall = assessable.isEmpty
        ? 0.0
        : assessable.map((b) => b.masteryPercent).reduce((a, b) => a + b) /
            assessable.length;

    return Padding(
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
            'Mastery % is how many difficulty tiers (Easy, Medium, Hard/Challenge, '
            'Advanced) you\'ve fully completed in Practice Test, across every topic '
            'in each unit of $courseTitle.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: ProgressStatus.fromScorePercent(overall).color.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: ProgressStatus.fromScorePercent(overall).color.withValues(
                      alpha: 0.4,
                    ),
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
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _YAxis(),
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
      ),
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
    final status = bar.tiersTotal == 0
        ? ProgressStatus.notStarted
        : ProgressStatus.fromScorePercent(bar.masteryPercent);
    final barHeight = (_chartHeight * (bar.masteryPercent / 100)).clamp(0.0, _chartHeight);

    return SizedBox(
      width: _columnWidth,
      child: Tooltip(
        message: bar.tiersTotal == 0
            ? '${bar.unitTitle}\nNo practice questions yet.'
            : '${bar.unitTitle}\n'
                  '${bar.masteryPercent.round()}% mastered '
                  '(${bar.tiersCompleted} of ${bar.tiersTotal} difficulty tiers '
                  'complete across ${bar.subtopicCount} '
                  '${bar.subtopicCount == 1 ? 'topic' : 'topics'})',
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
                    if (bar.masteryPercent > 0)
                      Text(
                        '${bar.masteryPercent.round()}%',
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
              height: 48,
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
