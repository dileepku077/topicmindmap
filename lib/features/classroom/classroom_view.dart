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

/// The "classroom" alternative to the spatial mindmap: a left-hand list of
/// units to navigate by, and a main panel that either shows a personalized
/// dashboard (a "pick up where you left off" card, plus an overall
/// progress summary) or the subtopics of whichever unit is selected.
///
/// Same underlying data and the same subtopic detail sheet as the mindmap
/// — this is a different way to navigate to it, not a different feature.
class ClassroomView extends ConsumerStatefulWidget {
  const ClassroomView({
    super.key,
    required this.course,
    required this.units,
    required this.subtopicsByUnit,
    required this.subtopicStatus,
    required this.subtopicScorePercent,
    required this.onTapSubtopic,
  });

  final Course course;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final Map<String, ProgressStatus> subtopicStatus;
  final Map<String, double> subtopicScorePercent;
  final void Function(Subtopic subtopic, ProgressStatus status) onTapSubtopic;

  @override
  ConsumerState<ClassroomView> createState() => _ClassroomViewState();
}

class _ClassroomViewState extends ConsumerState<ClassroomView> {
  String? _selectedUnitId;

  @override
  void didUpdateWidget(covariant ClassroomView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Don't leave a unit from the previous course selected after switching
    // courses in the grade dropdown.
    if (oldWidget.course.id != widget.course.id) {
      _selectedUnitId = null;
    }
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
            onSelectHome: () => setState(() => _selectedUnitId = null),
            onSelectUnit: (id) => setState(() => _selectedUnitId = id),
          ),
        ),
        VerticalDivider(width: 1, color: scheme.outlineVariant.withValues(alpha: 0.3)),
        Expanded(
          child: selectedUnit == null
              ? _HomePanel(
                  course: widget.course,
                  units: widget.units,
                  subtopicsByUnit: widget.subtopicsByUnit,
                  subtopicStatus: widget.subtopicStatus,
                  onSelectUnit: (id) => setState(() => _selectedUnitId = id),
                )
              : _UnitPanel(
                  unit: selectedUnit,
                  subtopics: widget.subtopicsByUnit[selectedUnit.id] ?? const [],
                  subtopicStatus: widget.subtopicStatus,
                  subtopicScorePercent: widget.subtopicScorePercent,
                  onTapSubtopic: widget.onTapSubtopic,
                  onBack: () => setState(() => _selectedUnitId = null),
                ),
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
    required this.onSelectHome,
    required this.onSelectUnit,
  });

  final Course course;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final Map<String, ProgressStatus> subtopicStatus;
  final String? selectedUnitId;
  final VoidCallback onSelectHome;
  final void Function(String unitId) onSelectUnit;

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
              subtopicCount: subtopicsByUnit[unit.id]?.length ?? 0,
              status: aggregateUnitStatus(
                (subtopicsByUnit[unit.id] ?? const []).map((s) => s.id),
                subtopicStatus,
              ),
              selected: unit.id == selectedUnitId,
              onTap: () => onSelectUnit(unit.id),
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

class _UnitNavRow extends StatelessWidget {
  const _UnitNavRow({
    required this.unit,
    required this.subtopicCount,
    required this.status,
    required this.selected,
    required this.onTap,
  });

  final Unit unit;
  final int subtopicCount;
  final ProgressStatus status;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: selected ? scheme.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: selected ? scheme.primary : Colors.transparent,
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
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? scheme.primary : scheme.onSurface,
                        ),
                      ),
                      Text(
                        '$subtopicCount ${subtopicCount == 1 ? 'topic' : 'topics'}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
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

/// The dashboard shown before a unit is picked — a personalized greeting,
/// a card resuming whichever subtopic was practiced most recently in this
/// course, and an overall progress summary.
class _HomePanel extends ConsumerWidget {
  const _HomePanel({
    required this.course,
    required this.units,
    required this.subtopicsByUnit,
    required this.subtopicStatus,
    required this.onSelectUnit,
  });

  final Course course;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final Map<String, ProgressStatus> subtopicStatus;
  final void Function(String unitId) onSelectUnit;

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
              courseCode: course.code,
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
    required this.courseCode,
  });

  final Subtopic? subtopic;
  final SubtopicMastery mastery;
  final String? unitCode;
  final String courseCode;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
            subtopic!.title,
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
              onPressed: () {
                final uri = Uri(
                  path: '/practice/$courseCode/$unitCode/${subtopic!.code}',
                  queryParameters: {'title': subtopic!.title},
                );
                context.push(uri.toString());
              },
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
  final void Function(Subtopic subtopic, ProgressStatus status) onTapSubtopic;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final sorted = [...subtopics]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
              tooltip: 'Back to home',
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                unit.title,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
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
              onTap: () => onTapSubtopic(
                subtopic,
                subtopicStatus[subtopic.id] ?? ProgressStatus.notStarted,
              ),
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
