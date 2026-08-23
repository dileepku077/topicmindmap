import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/course.dart';
import '../../models/progress_status.dart';
import '../../models/subtopic.dart';
import '../../models/subtopic_mastery.dart';
import '../../models/unit.dart';
import '../../state/progress_providers.dart';

/// The left-hand unit/subtopic list shared by the classroom view and the
/// mindmap view — same accordion (tap a unit, its subtopics expand in
/// place; tap another, the previous one collapses) either way, but what
/// "expanded" and "selected" mean differs by caller:
///
/// - The classroom view has exactly one unit open at a time (its own
///   single accordion state, [ClassroomView._selectedUnitId]) and a
///   persistent "currently viewed" subtopic to highlight.
/// - The mindmap view can have several units expanded on the canvas at
///   once ([_MindmapPageState._expandedUnitIds] is a set), and has no
///   persistent subtopic selection — tapping one just opens its detail
///   sheet and closes again.
///
/// [isUnitExpanded] and [selectedSubtopicId] are left to the caller so
/// this widget doesn't have to assume either model.
class CurriculumSidebar extends StatelessWidget {
  const CurriculumSidebar({
    super.key,
    required this.course,
    required this.units,
    required this.subtopicsByUnit,
    required this.subtopicStatus,
    required this.subtopicMedal,
    required this.isUnitExpanded,
    required this.onSelectUnit,
    required this.onSelectSubtopic,
    this.selectedSubtopicId,
    this.onSelectHome,
    this.homeSelected = false,
  });

  final Course course;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final Map<String, ProgressStatus> subtopicStatus;
  final Map<String, String> subtopicMedal;
  final bool Function(String unitId) isUnitExpanded;
  final void Function(String unitId) onSelectUnit;
  final void Function(Subtopic subtopic) onSelectSubtopic;
  final String? selectedSubtopicId;

  /// Null hides the "Home" row entirely — the mindmap view has no
  /// dashboard to go home to, only the classroom view does.
  final VoidCallback? onSelectHome;

  /// Whether the Home row itself should read as the active one — the
  /// classroom view's own "no unit picked yet" state. Meaningless (and
  /// ignored) when [onSelectHome] is null.
  final bool homeSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sortedUnits = [...units]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final onSelectHome = this.onSelectHome;

    return Container(
      color: scheme.surfaceContainerLow,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              course.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              course.gradeLabel,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          if (onSelectHome != null)
            _NavRow(
              icon: Icons.dashboard_outlined,
              label: 'Home',
              selected: homeSelected,
              onTap: onSelectHome,
            ),
          _NavRow(
            icon: Icons.person_outline,
            label: 'Profile & Preferences',
            selected: false,
            onTap: () => context.push('/settings'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
            child: Text(
              'UNITS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 0.8,
              ),
            ),
          ),
          for (final unit in sortedUnits)
            _UnitNavRow(
              unit: unit,
              subtopics: subtopicsByUnit[unit.id] ?? const [],
              subtopicStatus: subtopicStatus,
              subtopicMedal: subtopicMedal,
              status: aggregateUnitStatus(
                (subtopicsByUnit[unit.id] ?? const []).map((s) => s.id),
                subtopicStatus,
              ),
              medal: aggregateUnitMedal(
                (subtopicsByUnit[unit.id] ?? const []).map((s) => s.id),
                subtopicMedal,
              ),
              expanded: isUnitExpanded(unit.id),
              selectedSubtopicId: selectedSubtopicId,
              onTap: () => onSelectUnit(unit.id),
              onTapSubtopic: onSelectSubtopic,
            ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: selected ? scheme.primary.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? scheme.primary : scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A unit row that expands in place to list its subtopics directly in the
/// sidebar when selected — [expanded] is driven entirely by the caller
/// (see [CurriculumSidebar]), so what "only one open at a time" vs.
/// "several open at once" means is the caller's choice, not this widget's.
class _UnitNavRow extends StatelessWidget {
  const _UnitNavRow({
    required this.unit,
    required this.subtopics,
    required this.subtopicStatus,
    required this.subtopicMedal,
    required this.status,
    required this.medal,
    required this.expanded,
    required this.selectedSubtopicId,
    required this.onTap,
    required this.onTapSubtopic,
  });

  final Unit unit;
  final List<Subtopic> subtopics;
  final Map<String, ProgressStatus> subtopicStatus;
  final Map<String, String> subtopicMedal;
  final ProgressStatus status;

  /// The worst medal among this unit's attempted subtopics — see
  /// `aggregateUnitMedal` — or null if none have been attempted yet.
  final String? medal;
  final bool expanded;
  final String? selectedSubtopicId;
  final VoidCallback onTap;
  final void Function(Subtopic subtopic) onTapSubtopic;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final subtopicCount = subtopics.length;
    final sortedSubtopics = [...subtopics]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: expanded ? scheme.primary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: expanded ? scheme.primary : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(status.icon, size: 15, color: status.color),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unit.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: expanded ? FontWeight.w700 : FontWeight.w500,
                              color: expanded ? scheme.primary : scheme.onSurface,
                            ),
                          ),
                          Text(
                            '$subtopicCount ${subtopicCount == 1 ? 'topic' : 'topics'}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (medal != null && medal != 'None') ...[
                      MedalBadge(medal: medal, size: 15),
                      const SizedBox(width: 6),
                    ],
                    Icon(
                      expanded ? Icons.expand_more : Icons.chevron_right,
                      size: 18,
                      color: expanded ? scheme.primary : scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: !expanded
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.only(left: 27, top: 2, bottom: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final subtopic in sortedSubtopics)
                          _SubtopicNavRow(
                            subtopic: subtopic,
                            status: subtopicStatus[subtopic.id] ?? ProgressStatus.notStarted,
                            medal: subtopicMedal[subtopic.id],
                            selected: subtopic.id == selectedSubtopicId,
                            onTap: () => onTapSubtopic(subtopic),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// One subtopic, nested under its expanded unit in the sidebar — compact
/// compared to the main pane's own subtopic cards, since it only needs to
/// support quick jumping straight to that subtopic, not carry a score
/// badge.
class _SubtopicNavRow extends StatelessWidget {
  const _SubtopicNavRow({
    required this.subtopic,
    required this.status,
    required this.medal,
    required this.selected,
    required this.onTap,
  });

  final Subtopic subtopic;
  final ProgressStatus status;
  final String? medal;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? scheme.primary.withValues(alpha: 0.14) : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          child: Row(
            children: [
              Icon(status.icon, size: 13, color: status.color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subtopic.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? scheme.primary : scheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (medal != null && medal != 'None') ...[
                const SizedBox(width: 6),
                MedalBadge(medal: medal, size: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
