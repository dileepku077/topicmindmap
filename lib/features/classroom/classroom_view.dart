import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/course.dart';
import '../../models/progress_status.dart';
import '../../models/subtopic.dart';
import '../../models/subtopic_mastery.dart';
import '../../models/unit.dart';
import '../../state/auth_providers.dart';
import '../../state/practice_test_providers.dart';
import '../../state/profile_providers.dart';
import '../../state/progress_providers.dart';
import '../lesson/lesson_page.dart';
import '../practice_test/practice_test_page.dart';
import '../topic_detail/topic_detail_sheet.dart';

/// The "classroom" alternative to the spatial mindmap: a left-hand list of
/// units to navigate by, and a main panel that shows a dashboard, a unit's
/// subtopics, a subtopic's overview, a lesson, or a practice test —
/// entirely by swapping what's in the main panel, never by navigating to a
/// different route. The unit list on the left stays on screen the whole
/// time, including while reading a lesson or taking a practice test.
///
/// (The spatial mindmap still opens lessons/practice tests as their own
/// full-screen routes via a modal sheet — see topic_detail_sheet.dart. That
/// makes sense there since the mindmap has no side panel to lose; here it
/// would defeat the point of having one.)
class ClassroomView extends ConsumerStatefulWidget {
  const ClassroomView({
    super.key,
    required this.course,
    required this.units,
    required this.subtopicsByUnit,
    required this.subtopicStatus,
    required this.subtopicScorePercent,
  });

  final Course course;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final Map<String, ProgressStatus> subtopicStatus;
  final Map<String, double> subtopicScorePercent;

  @override
  ConsumerState<ClassroomView> createState() => _ClassroomViewState();
}

class _ClassroomViewState extends ConsumerState<ClassroomView> {
  String? _selectedUnitId;
  Subtopic? _selectedSubtopic;
  String? _lessonId;
  String? _lessonTitle;
  _PracticeTarget? _practice;

  @override
  void didUpdateWidget(covariant ClassroomView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Don't leave a unit/subtopic/lesson/practice from the previous course
    // showing after switching courses in the grade dropdown.
    if (oldWidget.course.id != widget.course.id) {
      _goHome();
    }
  }

  void _goHome() {
    setState(() {
      _selectedUnitId = null;
      _selectedSubtopic = null;
      _lessonId = null;
      _practice = null;
    });
  }

  void _selectUnit(String unitId) {
    setState(() {
      _selectedUnitId = unitId;
      _selectedSubtopic = null;
      _lessonId = null;
      _practice = null;
    });
  }

  void _selectSubtopic(Subtopic subtopic) {
    setState(() {
      _selectedUnitId = subtopic.unitId;
      _selectedSubtopic = subtopic;
      _lessonId = null;
      _practice = null;
    });
  }

  void _openLesson(String lessonId, String lessonTitle) {
    setState(() {
      _lessonId = lessonId;
      _lessonTitle = lessonTitle;
      _practice = null;
    });
  }

  void _openPractice(String unitCode, String subtopicCode, String title) {
    setState(() {
      _practice = _PracticeTarget(unitCode: unitCode, subtopicCode: subtopicCode, title: title);
      _lessonId = null;
    });
  }

  /// From a lesson or practice test, back goes to the subtopic overview
  /// (or the unit list / home, if this was opened straight from there —
  /// e.g. the dashboard's resume card, which doesn't select a subtopic).
  void _backFromLeaf() {
    setState(() {
      _lessonId = null;
      _practice = null;
    });
  }

  void _backFromSubtopic() {
    setState(() => _selectedSubtopic = null);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Unit? selectedUnit;
    for (final unit in widget.units) {
      if (unit.id == _selectedUnitId) {
        selectedUnit = unit;
        break;
      }
    }

    return Row(
      children: [
        SizedBox(
          width: 260,
          child: _Sidebar(
            course: widget.course,
            units: widget.units,
            subtopicsByUnit: widget.subtopicsByUnit,
            subtopicStatus: widget.subtopicStatus,
            selectedUnitId: _selectedUnitId,
            selectedSubtopicId: _selectedSubtopic?.id,
            onSelectHome: _goHome,
            onSelectUnit: _selectUnit,
            onSelectSubtopic: _selectSubtopic,
          ),
        ),
        VerticalDivider(width: 1, color: scheme.outlineVariant.withValues(alpha: 0.3)),
        Expanded(child: _buildMain(selectedUnit)),
      ],
    );
  }

  Widget _buildMain(Unit? selectedUnit) {
    final practice = _practice;
    if (practice != null) {
      return _LeafPane(
        title: practice.title,
        onBack: _backFromLeaf,
        child: PracticeTestPage(
          key: ValueKey('practice-${practice.unitCode}-${practice.subtopicCode}'),
          courseCode: widget.course.code,
          unitCode: practice.unitCode,
          subtopicCode: practice.subtopicCode,
          subtopicTitle: practice.title,
          embedded: true,
          onFinished: _backFromLeaf,
        ),
      );
    }
    final lessonId = _lessonId;
    if (lessonId != null) {
      return _LeafPane(
        title: _lessonTitle ?? 'Lesson',
        onBack: _backFromLeaf,
        child: LessonBody(key: ValueKey('lesson-$lessonId'), lessonId: lessonId),
      );
    }
    final subtopic = _selectedSubtopic;
    if (subtopic != null) {
      return _SubtopicPane(
        subtopic: subtopic,
        courseCode: widget.course.code,
        onBack: _backFromSubtopic,
        onOpenLesson: _openLesson,
        onOpenPractice: (unitCode) =>
            _openPractice(unitCode, subtopic.code, subtopic.title),
      );
    }
    if (selectedUnit == null) {
      return _HomePanel(
        course: widget.course,
        units: widget.units,
        subtopicsByUnit: widget.subtopicsByUnit,
        subtopicStatus: widget.subtopicStatus,
        onResume: _openPractice,
      );
    }
    return _UnitPanel(
      unit: selectedUnit,
      subtopics: widget.subtopicsByUnit[selectedUnit.id] ?? const [],
      subtopicStatus: widget.subtopicStatus,
      subtopicScorePercent: widget.subtopicScorePercent,
      onTapSubtopic: _selectSubtopic,
      onBack: _goHome,
    );
  }
}

class _PracticeTarget {
  const _PracticeTarget({
    required this.unitCode,
    required this.subtopicCode,
    required this.title,
  });

  final String unitCode;
  final String subtopicCode;
  final String title;
}

/// A back button, optionally with a title next to it — the header every
/// non-home main-panel state (unit, subtopic, lesson, practice) starts
/// with, so "back" always lands in a predictable, consistent spot.
class _PaneHeader extends StatelessWidget {
  const _PaneHeader({required this.onBack, this.title});

  final VoidCallback onBack;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: 'Back',
        ),
        if (title != null) ...[
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title!,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ],
    );
  }
}

/// A lesson or a practice test, embedded in the main pane with a
/// consistent back+title header above it instead of its own AppBar.
class _LeafPane extends StatelessWidget {
  const _LeafPane({required this.title, required this.onBack, required this.child});

  final String title;
  final VoidCallback onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: _PaneHeader(onBack: onBack, title: title),
        ),
        Expanded(child: child),
      ],
    );
  }
}

/// The inline equivalent of the mindmap's modal subtopic-detail sheet —
/// same [SubtopicOverview] content, just in the main pane with a back
/// button instead of a dismissable sheet.
class _SubtopicPane extends StatelessWidget {
  const _SubtopicPane({
    required this.subtopic,
    required this.courseCode,
    required this.onBack,
    required this.onOpenLesson,
    required this.onOpenPractice,
  });

  final Subtopic subtopic;
  final String courseCode;
  final VoidCallback onBack;
  final void Function(String lessonId, String lessonTitle) onOpenLesson;
  final void Function(String unitCode) onOpenPractice;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _PaneHeader(onBack: onBack),
        const SizedBox(height: 12),
        SubtopicOverview(
          subtopic: subtopic,
          courseCode: courseCode,
          onOpenLesson: onOpenLesson,
          onOpenPractice: onOpenPractice,
        ),
      ],
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.course,
    required this.units,
    required this.subtopicsByUnit,
    required this.subtopicStatus,
    required this.selectedUnitId,
    required this.selectedSubtopicId,
    required this.onSelectHome,
    required this.onSelectUnit,
    required this.onSelectSubtopic,
  });

  final Course course;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final Map<String, ProgressStatus> subtopicStatus;
  final String? selectedUnitId;
  final String? selectedSubtopicId;
  final VoidCallback onSelectHome;
  final void Function(String unitId) onSelectUnit;
  final void Function(Subtopic subtopic) onSelectSubtopic;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sortedUnits = [...units]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

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
          _NavRow(
            icon: Icons.dashboard_outlined,
            label: 'Home',
            selected: selectedUnitId == null,
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
              status: aggregateUnitStatus(
                (subtopicsByUnit[unit.id] ?? const []).map((s) => s.id),
                subtopicStatus,
              ),
              expanded: unit.id == selectedUnitId,
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
/// sidebar when selected — [expanded] is driven by the parent's own
/// selected-unit state (see [ClassroomView._selectUnit] /
/// [ClassroomView._selectSubtopic]), so picking a different unit
/// automatically collapses whichever one was open before: only one unit's
/// subtopic list is ever expanded at a time, accordion-style.
class _UnitNavRow extends StatelessWidget {
  const _UnitNavRow({
    required this.unit,
    required this.subtopics,
    required this.subtopicStatus,
    required this.status,
    required this.expanded,
    required this.selectedSubtopicId,
    required this.onTap,
    required this.onTapSubtopic,
  });

  final Unit unit;
  final List<Subtopic> subtopics;
  final Map<String, ProgressStatus> subtopicStatus;
  final ProgressStatus status;
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
/// compared to [_SubtopicCard] (the main pane's version) since it only
/// needs to support quick jumping straight to that subtopic, not carry a
/// score badge.
class _SubtopicNavRow extends StatelessWidget {
  const _SubtopicNavRow({
    required this.subtopic,
    required this.status,
    required this.selected,
    required this.onTap,
  });

  final Subtopic subtopic;
  final ProgressStatus status;
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
            ],
          ),
        ),
      ),
    );
  }
}

/// The dashboard shown before a unit is picked — a personalized greeting,
/// a card resuming whichever subtopic was practiced most recently in this
/// course, and an overall progress summary.
class _HomePanel extends ConsumerWidget {
  const _HomePanel({
    required this.course,
    required this.units,
    required this.subtopicsByUnit,
    required this.subtopicStatus,
    required this.onResume,
  });

  final Course course;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final Map<String, ProgressStatus> subtopicStatus;

  /// (unitCode, subtopicCode, title) — opens that subtopic's practice test.
  final void Function(String unitCode, String subtopicCode, String title) onResume;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final displayName = ref.watch(profileProvider).value?.displayName;
    final mastery = ref.watch(practiceMasteryProvider).value ?? const {};
    final unitCodeById = ref.watch(unitCodeByIdProvider);

    // This course's subtopics only, newest attempt first.
    final courseSubtopicIds = {
      for (final list in subtopicsByUnit.values) for (final s in list) s.id,
    };
    final subtopicById = {
      for (final list in subtopicsByUnit.values) for (final s in list) s.id: s,
    };
    final recent =
        mastery.entries.where((e) => courseSubtopicIds.contains(e.key)).toList()
          ..sort((a, b) => b.value.updatedAt.compareTo(a.value.updatedAt));

    final mastered = units
        .where(
          (u) => aggregateUnitStatus(
            (subtopicsByUnit[u.id] ?? const []).map((s) => s.id),
            subtopicStatus,
          ) == ProgressStatus.mastered,
        )
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_greeting()}${displayName != null ? ', $displayName' : ''}',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            user == null
                ? 'Sign in to track your progress and pick up where you left off.'
                : 'Pick up where you left off, or start something new.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          if (user != null && recent.isNotEmpty)
            _ResumeCard(
              subtopic: subtopicById[recent.first.key],
              mastery: recent.first.value,
              unitCode: unitCodeById[subtopicById[recent.first.key]?.unitId],
              onContinue: (unitCode, subtopicCode, title) =>
                  onResume(unitCode, subtopicCode, title),
            )
          else
            _EmptyHomeCard(signedIn: user != null),
          const SizedBox(height: 16),
          if (user != null && units.isNotEmpty)
            _MedalSummaryRow(mastered: mastered, total: units.length),
        ],
      ),
    );
  }

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _ResumeCard extends StatelessWidget {
  const _ResumeCard({
    required this.subtopic,
    required this.mastery,
    required this.unitCode,
    required this.onContinue,
  });

  final Subtopic? subtopic;
  final SubtopicMastery mastery;
  final String? unitCode;
  final void Function(String unitCode, String subtopicCode, String title) onContinue;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final subtopic = this.subtopic;
    final unitCode = this.unitCode;
    if (subtopic == null || unitCode == null) {
      return const _EmptyHomeCard(signedIn: true);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PICK UP WHERE YOU LEFT OFF',
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.75),
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtopic.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: scheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${mastery.bestFirstTry} of ${mastery.totalQuestions} correct on the first try',
            style: TextStyle(color: scheme.onPrimary.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (mastery.scorePercent / 100).clamp(0, 1),
              minHeight: 8,
              backgroundColor: scheme.onPrimary.withValues(alpha: 0.25),
              valueColor: AlwaysStoppedAnimation(scheme.onPrimary),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: scheme.onPrimary,
                foregroundColor: scheme.primary,
              ),
              onPressed: () => onContinue(unitCode, subtopic.code, subtopic.title),
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHomeCard extends StatelessWidget {
  const _EmptyHomeCard({required this.signedIn});

  final bool signedIn;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        signedIn
            ? "You haven't started a practice test yet — pick a unit from the left to begin."
            : 'Pick a unit from the left to explore this course.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _MedalSummaryRow extends StatelessWidget {
  const _MedalSummaryRow({required this.mastered, required this.total});

  final int mastered;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.emoji_events_outlined, color: scheme.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$mastered of $total ${total == 1 ? 'unit has' : 'units have'} solid progress',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// The subtopics of whichever unit is selected in the sidebar.
class _UnitPanel extends StatelessWidget {
  const _UnitPanel({
    required this.unit,
    required this.subtopics,
    required this.subtopicStatus,
    required this.subtopicScorePercent,
    required this.onTapSubtopic,
    required this.onBack,
  });

  final Unit unit;
  final List<Subtopic> subtopics;
  final Map<String, ProgressStatus> subtopicStatus;
  final Map<String, double> subtopicScorePercent;
  final void Function(Subtopic subtopic) onTapSubtopic;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final sorted = [...subtopics]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _PaneHeader(onBack: onBack, title: unit.title),
        if (unit.description != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 48),
            child: Text(
              unit.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
        const SizedBox(height: 20),
        for (final subtopic in sorted)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SubtopicCard(
              subtopic: subtopic,
              status: subtopicStatus[subtopic.id] ?? ProgressStatus.notStarted,
              scorePercent: subtopicScorePercent[subtopic.id],
              onTap: () => onTapSubtopic(subtopic),
            ),
          ),
      ],
    );
  }
}

class _SubtopicCard extends StatelessWidget {
  const _SubtopicCard({
    required this.subtopic,
    required this.status,
    required this.scorePercent,
    required this.onTap,
  });

  final Subtopic subtopic;
  final ProgressStatus status;
  final double? scorePercent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(status.icon, color: status.color, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  subtopic.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              if (scorePercent != null) ...[
                Text(
                  '${scorePercent!.round()}%',
                  style: TextStyle(color: status.color, fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 10),
              ],
              Icon(Icons.chevron_right, color: scheme.outline, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
