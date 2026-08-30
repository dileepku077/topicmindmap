import 'package:flutter/material.dart';

import '../../models/course.dart';
import '../../models/subtopic.dart';
import '../../models/unit.dart';

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
    required this.isUnitExpanded,
    required this.onSelectUnit,
    required this.onSelectSubtopic,
    this.onOpenProgressReport,
    this.selectedSubtopicId,
    this.onSelectHome,
    this.homeSelected = false,
    this.collapsed = false,
    this.onToggleCollapsed,
  });

  final Course course;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final bool Function(String unitId) isUnitExpanded;
  final void Function(String unitId) onSelectUnit;
  final void Function(Subtopic subtopic) onSelectSubtopic;

  /// Opens the Progress Report bar chart, embedded in place (the caller
  /// decides how; see mindmap_page.dart). Null hides the row entirely --
  /// the classroom view no longer passes this, since Progress Report
  /// lives in its own dashboard's action row now (_HomePanel); the
  /// mindmap view still does, having no dashboard of its own to put it
  /// in instead. Profile & Preferences and "How to use this app" used to
  /// have tiles here too; both now live in the account menu/AppBar at
  /// the top right instead (see mindmap_page.dart), reachable from
  /// anywhere regardless of which view is showing.
  final VoidCallback? onOpenProgressReport;
  final String? selectedSubtopicId;

  /// Null hides the "Home" row entirely — the mindmap view has no
  /// dashboard to go home to, only the classroom view does.
  final VoidCallback? onSelectHome;

  /// Whether the Home row itself should read as the active one — the
  /// classroom view's own "no unit picked yet" state. Meaningless (and
  /// ignored) when [onSelectHome] is null.
  final bool homeSelected;

  /// Whether the sidebar is shrunk to an icon-only rail — set by the
  /// caller, which also owns the width of the box this sits in (see
  /// mindmap_page.dart / classroom_view.dart). Rows just change how they
  /// render; the caller decides how much horizontal room they get.
  final bool collapsed;

  /// Null hides the collapse/expand button entirely — used when this
  /// sidebar is inside a Drawer (narrow layout), where minimizing it in
  /// place doesn't make sense.
  final VoidCallback? onToggleCollapsed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sortedUnits = [...units]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final onSelectHome = this.onSelectHome;
    final onToggleCollapsed = this.onToggleCollapsed;

    return Container(
      color: scheme.surfaceContainerLow,
      child: Column(
        children: [
          if (onToggleCollapsed != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: Row(
                mainAxisAlignment: collapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.end,
                children: [
                  Tooltip(
                    message: collapsed
                        ? 'Show full sidebar'
                        : 'Minimize sidebar',
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        collapsed ? Icons.chevron_right : Icons.chevron_left,
                        size: 22,
                      ),
                      onPressed: onToggleCollapsed,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                if (!collapsed) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(
                      course.title,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(
                      course.gradeLabel,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(fontSize: 14),
                    ),
                  ),
                ],
                if (onSelectHome != null)
                  _NavRow(
                    icon: Icons.dashboard_outlined,
                    label: 'Home',
                    selected: homeSelected,
                    onTap: onSelectHome,
                    collapsed: collapsed,
                  ),
                if (onOpenProgressReport != null)
                  _NavRow(
                    icon: Icons.bar_chart_outlined,
                    label: 'Progress Report',
                    selected: false,
                    onTap: onOpenProgressReport!,
                    collapsed: collapsed,
                  ),
                if (!collapsed)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
                    child: Text(
                      'UNITS',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        letterSpacing: 0.8,
                        fontSize: 13,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 12),
                for (final unit in sortedUnits)
                  _UnitNavRow(
                    unit: unit,
                    subtopics: subtopicsByUnit[unit.id] ?? const [],
                    expanded: isUnitExpanded(unit.id),
                    selectedSubtopicId: selectedSubtopicId,
                    onTap: () => onSelectUnit(unit.id),
                    onTapSubtopic: onSelectSubtopic,
                    collapsed: collapsed,
                  ),
              ],
            ),
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
    this.collapsed = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final iconColor = selected ? scheme.primary : scheme.onSurfaceVariant;

    final row = collapsed
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(child: Icon(icon, size: 22, color: iconColor)),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Icon(icon, size: 22, color: iconColor),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? scheme.primary : scheme.onSurface,
                  ),
                ),
              ],
            ),
          );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: collapsed ? 4 : 8, vertical: 2),
      child: Material(
        color: selected
            ? scheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: collapsed ? Tooltip(message: label, child: row) : row,
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
    required this.expanded,
    required this.selectedSubtopicId,
    required this.onTap,
    required this.onTapSubtopic,
    this.collapsed = false,
  });

  final Unit unit;
  final List<Subtopic> subtopics;
  final bool expanded;
  final String? selectedSubtopicId;
  final VoidCallback onTap;
  final void Function(Subtopic subtopic) onTapSubtopic;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final subtopicCount = subtopics.length;
    final sortedSubtopics = [...subtopics]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    // Plain, not status-colored -- the dashboard's own per-unit progress
    // list already shows completion; this nav list stays a simple way to
    // jump to a topic, same treatment as the Home row above it.
    final iconColor = expanded ? scheme.primary : scheme.onSurfaceVariant;

    if (collapsed) {
      // No room for the title or an expanded subtopic list at rail width
      // — just a tappable icon. Tapping still drives the caller's normal
      // select/expand logic (it just isn't visible here), so switching
      // back to full width picks up right where the rail left off.
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Material(
          color: expanded
              ? scheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Tooltip(
              message: unit.title,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Icon(Icons.topic_outlined, size: 18, color: iconColor),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: expanded
                ? scheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
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
                    Icon(Icons.topic_outlined, size: 17, color: iconColor),
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
                              fontSize: 17,
                              fontWeight: expanded
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: expanded
                                  ? scheme.primary
                                  : scheme.onSurface,
                            ),
                          ),
                          Text(
                            '$subtopicCount ${subtopicCount == 1 ? 'topic' : 'topics'}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      expanded ? Icons.expand_more : Icons.chevron_right,
                      size: 20,
                      color: expanded
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
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

/// One subtopic, nested under its expanded unit in the sidebar — just a
/// title to tap, no status icon or score: this list is for jumping to a
/// topic quickly, not for reading progress (see the dashboard's own
/// per-unit progress list, and the difficulty picker's per-tier medals,
/// for that).
class _SubtopicNavRow extends StatelessWidget {
  const _SubtopicNavRow({
    required this.subtopic,
    required this.selected,
    required this.onTap,
  });

  final Subtopic subtopic;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected
          ? scheme.primary.withValues(alpha: 0.14)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  subtopic.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? scheme.primary : scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
