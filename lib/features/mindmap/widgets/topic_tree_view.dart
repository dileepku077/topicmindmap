import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../models/course.dart';
import '../../../models/progress_status.dart';
import '../../../models/subtopic.dart';
import '../../../models/unit.dart';
import '../../../state/progress_providers.dart';

/// A plain, scrollable outline of the same curriculum the mindmap shows —
/// course title at top, units as collapsible sections, subtopics indented
/// underneath. Some students read a straightforward list faster than a
/// spatial map; this is the same data, same traffic-signal colors, same
/// tap targets, just laid out top-to-bottom instead of branching outward.
class TopicTreeView extends StatelessWidget {
  const TopicTreeView({
    super.key,
    required this.course,
    required this.units,
    required this.subtopicsByUnit,
    required this.subtopicStatus,
    required this.subtopicScorePercent,
    required this.expandedUnitIds,
    required this.onToggleUnit,
    required this.onTapSubtopic,
    this.scale = 1.0,
    this.zoomModifierHeld = false,
    this.onScrollSignal,
  });

  final Course course;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final Map<String, ProgressStatus> subtopicStatus;
  final Map<String, double> subtopicScorePercent;
  final Set<String> expandedUnitIds;
  final void Function(Unit unit) onToggleUnit;
  final void Function(Subtopic subtopic, ProgressStatus status) onTapSubtopic;

  /// Row/text scale driven by the page's Cmd/Ctrl+scroll zoom handling —
  /// this view has no spatial canvas to pan/zoom, so "zoom" just scales
  /// the rows up or down.
  final double scale;

  /// Whether Cmd/Ctrl is currently held. The list's own scroll physics are
  /// switched off while this is true so a Cmd/Ctrl+scroll used to zoom
  /// doesn't *also* scroll the list at the same time — otherwise both
  /// [onScrollSignal] and the ListView's own wheel handling would react to
  /// the same tick.
  final bool zoomModifierHeld;

  /// Raw pointer-signal passthrough so the page can detect Cmd/Ctrl+scroll
  /// over this list and adjust [scale].
  final void Function(PointerSignalEvent event)? onScrollSignal;

  @override
  Widget build(BuildContext context) {
    final sortedUnits = [...units]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      physics: zoomModifierHeld ? const NeverScrollableScrollPhysics() : null,
      children: [
        Listener(
          onPointerSignal: onScrollSignal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 4),
                  child: Text(
                    'Grade ${course.grade} Math',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          (Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.fontSize ??
                              24) *
                          scale,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                for (final unit in sortedUnits)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _UnitSection(
                      unit: unit,
                      subtopics: subtopicsByUnit[unit.id] ?? const [],
                      subtopicStatus: subtopicStatus,
                      subtopicScorePercent: subtopicScorePercent,
                      expanded: expandedUnitIds.contains(unit.id),
                      scale: scale,
                      onToggle: () => onToggleUnit(unit),
                      onTapSubtopic: onTapSubtopic,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UnitSection extends StatelessWidget {
  const _UnitSection({
    required this.unit,
    required this.subtopics,
    required this.subtopicStatus,
    required this.subtopicScorePercent,
    required this.expanded,
    required this.onToggle,
    required this.onTapSubtopic,
    this.scale = 1.0,
  });

  final Unit unit;
  final List<Subtopic> subtopics;
  final Map<String, ProgressStatus> subtopicStatus;
  final Map<String, double> subtopicScorePercent;
  final bool expanded;
  final double scale;
  final VoidCallback onToggle;
  final void Function(Subtopic subtopic, ProgressStatus status) onTapSubtopic;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final subtopicIds = subtopics.map((s) => s.id);
    final status = aggregateUnitStatus(subtopicIds, subtopicStatus);
    final scorePercent = aggregateUnitScorePercent(
      subtopicIds,
      subtopicScorePercent,
    );

    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 14 * scale,
                vertical: 12 * scale,
              ),
              child: Row(
                children: [
                  Icon(status.icon, color: status.color, size: 20 * scale),
                  SizedBox(width: 12 * scale),
                  Expanded(
                    child: Text(
                      unit.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15 * scale,
                      ),
                    ),
                  ),
                  if (scorePercent != null) ...[
                    Text(
                      '${scorePercent.round()}%',
                      style: TextStyle(
                        color: status.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 13 * scale,
                      ),
                    ),
                    SizedBox(width: 10 * scale),
                  ],
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8 * scale,
                      vertical: 2 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: status.color.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${subtopics.length}',
                      style: TextStyle(
                        color: status.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 11 * scale,
                      ),
                    ),
                  ),
                  SizedBox(width: 6 * scale),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(Icons.expand_more, size: 22 * scale),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 180),
            crossFadeState: expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Divider(
                  height: 1,
                  color: scheme.outlineVariant.withValues(alpha: 0.3),
                ),
                for (final subtopic in subtopics)
                  _SubtopicRow(
                    subtopic: subtopic,
                    status:
                        subtopicStatus[subtopic.id] ??
                        ProgressStatus.notStarted,
                    scorePercent: subtopicScorePercent[subtopic.id],
                    scale: scale,
                    onTap: () => onTapSubtopic(
                      subtopic,
                      subtopicStatus[subtopic.id] ?? ProgressStatus.notStarted,
                    ),
                  ),
                const SizedBox(height: 4),
              ],
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _SubtopicRow extends StatelessWidget {
  const _SubtopicRow({
    required this.subtopic,
    required this.status,
    required this.onTap,
    this.scorePercent,
    this.scale = 1.0,
  });

  final Subtopic subtopic;
  final ProgressStatus status;
  final double? scorePercent;
  final double scale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          44 * scale,
          10 * scale,
          14 * scale,
          10 * scale,
        ),
        child: Row(
          children: [
            Icon(status.icon, color: status.color, size: 16 * scale),
            SizedBox(width: 12 * scale),
            Expanded(
              child: Text(
                subtopic.title,
                style: TextStyle(fontSize: 13.5 * scale),
              ),
            ),
            if (scorePercent != null) ...[
              Text(
                '${scorePercent!.round()}%',
                style: TextStyle(
                  color: status.color,
                  fontWeight: FontWeight.w800,
                  fontSize: 12 * scale,
                ),
              ),
              SizedBox(width: 10 * scale),
            ],
            Icon(
              Icons.chevron_right,
              size: 18 * scale,
              color: Theme.of(context).colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}
