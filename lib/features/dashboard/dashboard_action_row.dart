import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/course.dart';
import '../../models/subtopic.dart';
import '../../models/unit.dart';
import '../../state/auth_providers.dart';
import '../../state/lesson_providers.dart';
import '../../state/practice_test_providers.dart';
import '../../state/progress_providers.dart';

/// Learn / Quiz / Improve / Test / Progress Report — the same five
/// quick-start actions on both the classroom view's dashboard
/// (_HomePanel) and the spatial mindmap view (mindmap_page.dart), so
/// there's one place that decides what "next" means rather than two
/// copies drifting apart. Learn/Quiz/Test all target the same subtopic:
/// whichever was practiced most recently in this course, or the course's
/// first subtopic if nothing has been attempted yet. Improve and Progress
/// Report need no target of their own.
class DashboardActionRow extends ConsumerWidget {
  const DashboardActionRow({
    super.key,
    required this.course,
    required this.units,
    required this.subtopicsByUnit,
    required this.onOpenLesson,
    required this.onResume,
    required this.onOpenImprove,
    required this.onStartUnitTest,
    required this.onOpenProgressReport,
  });

  final Course course;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final void Function(String lessonId, String lessonTitle) onOpenLesson;

  /// (unitCode, subtopicCode, title) — opens that subtopic's quiz.
  final void Function(String unitCode, String subtopicCode, String title)
  onResume;
  final VoidCallback onOpenImprove;
  final void Function(String unitCode, String unitTitle) onStartUnitTest;
  final VoidCallback onOpenProgressReport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final mastery = ref.watch(practiceMasteryProvider).value ?? const {};
    final unitCodeById = ref.watch(unitCodeByIdProvider);

    final courseSubtopicIds = {
      for (final list in subtopicsByUnit.values)
        for (final s in list) s.id,
    };
    final subtopicById = {
      for (final list in subtopicsByUnit.values)
        for (final s in list) s.id: s,
    };
    // Newest attempt first, this course's subtopics only.
    final recent =
        mastery.entries.where((e) => courseSubtopicIds.contains(e.key)).toList()
          ..sort((a, b) => b.value.updatedAt.compareTo(a.value.updatedAt));

    Unit? findUnit(String? unitId) {
      if (unitId == null) return null;
      for (final unit in units) {
        if (unit.id == unitId) return unit;
      }
      return null;
    }

    final resumeSubtopic = recent.isNotEmpty
        ? subtopicById[recent.first.key]
        : null;
    final fallbackUnit = units.isNotEmpty ? units.first : null;
    final fallbackSubtopics = fallbackUnit != null
        ? (subtopicsByUnit[fallbackUnit.id] ?? const <Subtopic>[])
        : const <Subtopic>[];
    final targetSubtopic =
        resumeSubtopic ??
        (fallbackSubtopics.isNotEmpty ? fallbackSubtopics.first : null);
    final targetUnit = findUnit(targetSubtopic?.unitId) ?? fallbackUnit;
    final targetUnitCode = targetSubtopic != null
        ? unitCodeById[targetSubtopic.unitId]
        : null;
    final lessonId = targetSubtopic != null
        ? lessonIdFor(
            courseCode: course.code,
            subtopicCode: targetSubtopic.code,
          )
        : null;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SizedBox(
          width: 150,
          child: _ActionCard(
            icon: Icons.menu_book_outlined,
            label: 'Learn',
            onTap: (lessonId != null && targetSubtopic != null)
                ? () => onOpenLesson(lessonId, targetSubtopic.title)
                : null,
          ),
        ),
        SizedBox(
          width: 150,
          child: _ActionCard(
            icon: Icons.edit_note_outlined,
            label: 'Quiz',
            onTap: (targetSubtopic != null && targetUnitCode != null)
                ? () => onResume(
                    targetUnitCode,
                    targetSubtopic.code,
                    targetSubtopic.title,
                  )
                : null,
          ),
        ),
        SizedBox(
          width: 150,
          child: _ActionCard(
            icon: Icons.trending_up_outlined,
            label: 'Improve',
            onTap: onOpenImprove,
            featured: true,
          ),
        ),
        SizedBox(
          width: 150,
          child: _ActionCard(
            icon: Icons.fact_check_outlined,
            label: 'Test',
            onTap: targetUnit != null
                ? () => onStartUnitTest(targetUnit.code, targetUnit.title)
                : null,
          ),
        ),
        SizedBox(
          width: 150,
          child: _ActionCard(
            icon: Icons.bar_chart_outlined,
            label: 'Progress Report',
            onTap: onOpenProgressReport,
          ),
        ),
      ],
    );
  }
}

/// One of the five quick-start actions. `onTap == null` (no lesson for
/// this subtopic yet, or an edge case with no curriculum content loaded)
/// renders as a plainly disabled tile rather than hiding itself, so the
/// row stays visually consistent either way.
class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.featured = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  /// Picks out Improve in gold (theme.dart's brand tertiary) rather than
  /// the other actions' navy -- it's the app's newest, most distinctive
  /// mode and has no per-topic target the way Learn/Quiz/Test do, so it
  /// reads better as a standout than an identical tile.
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;
    final accent = featured ? scheme.tertiary : scheme.primary;
    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 26, color: enabled ? accent : scheme.outline),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: enabled ? null : scheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
