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
    required this.expandedUnitIds,
    required this.onToggleUnit,
    required this.onTapSubtopic,
  });

  final Course course;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final Map<String, ProgressStatus> subtopicStatus;
  final Set<String> expandedUnitIds;
  final void Function(Unit unit) onToggleUnit;
  final void Function(Subtopic subtopic, ProgressStatus status) onTapSubtopic;

  @override
  Widget build(BuildContext context) {
    final sortedUnits = [...units]..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        ConstrainedBox(
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
                    expanded: expandedUnitIds.contains(unit.id),
                    onToggle: () => onToggleUnit(unit),
                    onTapSubtopic: onTapSubtopic,
                  ),
                ),
            ],
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
    required this.expanded,
    required this.onToggle,
    required this.onTapSubtopic,
  });

  final Unit unit;
  final List<Subtopic> subtopics;
  final Map<String, ProgressStatus> subtopicStatus;
  final bool expanded;
  final VoidCallback onToggle;
  final void Function(Subtopic subtopic, ProgressStatus status) onTapSubtopic;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final status = aggregateUnitStatus(subtopics.map((s) => s.id), subtopicStatus);

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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(status.icon, color: status.color, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      unit.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: status.color.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${subtopics.length}',
                      style: TextStyle(
                        color: status.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(Icons.expand_more, size: 22),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 180),
            crossFadeState: expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.3)),
                for (final subtopic in subtopics)
                  _SubtopicRow(
                    subtopic: subtopic,
                    status: subtopicStatus[subtopic.id] ?? ProgressStatus.notStarted,
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
  });

  final Subtopic subtopic;
  final ProgressStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(44, 10, 14, 10),
        child: Row(
          children: [
            Icon(status.icon, color: status.color, size: 16),
            const SizedBox(width: 12),
            Expanded(
              child: Text(subtopic.title, style: const TextStyle(fontSize: 13.5)),
            ),
            Icon(Icons.chevron_right, size: 18, color: Theme.of(context).colorScheme.outline),
          ],
        ),
      ),
    );
  }
}
