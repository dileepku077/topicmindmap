import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/course.dart';
import '../../models/progress_status.dart';
import '../../models/subtopic.dart';
import '../../models/subtopic_mastery.dart';
import '../../models/unit.dart';
import '../../state/auth_providers.dart';
import '../../state/lesson_providers.dart';
import '../../state/practice_test_providers.dart';
import '../../state/profile_providers.dart';
import '../../state/progress_providers.dart';
import '../improve/improve_page.dart';
import '../lesson/lesson_page.dart';
import '../practice_test/practice_test_page.dart';
import '../progress_report/progress_report_page.dart';
import '../unit_test/unit_test_page.dart';
import 'curriculum_sidebar.dart';

/// The "classroom" alternative to the spatial mindmap: a left-hand list of
/// units to navigate by, and a main panel that shows a dashboard, a unit's
/// subtopics, a lesson, or a practice test — entirely by swapping what's
/// in the main panel, never by navigating to a different route. Picking a
/// subtopic goes straight to its practice test's difficulty picker rather
/// than a separate overview step — see _selectSubtopic. The unit list on
/// the left stays on screen the whole time, including while reading a
/// lesson or taking a practice test.
class ClassroomView extends ConsumerStatefulWidget {
  const ClassroomView({
    super.key,
    required this.course,
    required this.units,
    required this.subtopicsByUnit,
    required this.subtopicStatus,
    required this.subtopicScorePercent,
    required this.subtopicMedal,
    this.sidebarCollapsed = false,
    this.onToggleSidebarCollapsed,
  });

  final Course course;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final Map<String, ProgressStatus> subtopicStatus;
  final Map<String, double> subtopicScorePercent;

  /// Used by the dashboard's per-unit progress list (_HomePanel) to show a
  /// medal badge alongside each unit's score -- the sidebar/mindmap already
  /// compute this (see subtopicMedalProvider), so it just rides along here
  /// too rather than being recomputed.
  final Map<String, String> subtopicMedal;

  /// Mirrors the mindmap view's own sidebar state (see mindmap_page.dart)
  /// so minimizing the left-hand unit list to an icon rail is consistent
  /// across both views. Only takes effect at >=720px; below that the
  /// sidebar is already a drawer, opened by its own menu button regardless
  /// of this flag.
  final bool sidebarCollapsed;
  final VoidCallback? onToggleSidebarCollapsed;

  @override
  ConsumerState<ClassroomView> createState() => _ClassroomViewState();
}

class _ClassroomViewState extends ConsumerState<ClassroomView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _selectedUnitId;
  Subtopic? _selectedSubtopic;
  String? _lessonId;
  String? _lessonTitle;
  _PracticeTarget? _practice;
  _UnitTestTarget? _unitTest;
  bool _showProgressReport = false;
  bool _showImprove = false;

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
      _unitTest = null;
      _showProgressReport = false;
      _showImprove = false;
    });
  }

  void _selectUnit(String unitId) {
    setState(() {
      _selectedUnitId = unitId;
      _selectedSubtopic = null;
      _lessonId = null;
      _practice = null;
      _unitTest = null;
      _showProgressReport = false;
      _showImprove = false;
    });
  }

  /// Selecting a subtopic (from the sidebar or a unit's own subtopic list)
  /// used to land on a standalone overview with separate Lesson/Practice
  /// links -- an extra click before actually practicing anything. Now it
  /// opens the practice test's difficulty picker directly, which has its
  /// own link to the lesson at the bottom (see practice_test_page.dart).
  /// That overview page (formerly topic_detail_sheet.dart) had no other
  /// callers left in this app and was deleted.
  void _selectSubtopic(Subtopic subtopic) {
    final unitCode = ref.read(unitCodeByIdProvider)[subtopic.unitId];
    if (unitCode == null) return;
    setState(() {
      _selectedUnitId = subtopic.unitId;
      _selectedSubtopic = subtopic;
      _practice = _PracticeTarget(
        unitCode: unitCode,
        subtopicCode: subtopic.code,
        title: subtopic.title,
      );
      _lessonId = null;
      _unitTest = null;
      _showProgressReport = false;
      _showImprove = false;
    });
  }

  void _openLesson(String lessonId, String lessonTitle) {
    setState(() {
      _lessonId = lessonId;
      _lessonTitle = lessonTitle;
      _practice = null;
      _unitTest = null;
      _showProgressReport = false;
      _showImprove = false;
    });
  }

  void _openPractice(String unitCode, String subtopicCode, String title) {
    setState(() {
      _practice = _PracticeTarget(
        unitCode: unitCode,
        subtopicCode: subtopicCode,
        title: title,
      );
      _lessonId = null;
      _unitTest = null;
      _showProgressReport = false;
      _showImprove = false;
    });
  }

  void _openUnitTest(String unitCode, String unitTitle) {
    setState(() {
      _unitTest = _UnitTestTarget(unitCode: unitCode, title: unitTitle);
      _lessonId = null;
      _practice = null;
      _showProgressReport = false;
      _showImprove = false;
    });
  }

  /// Reachable straight from the dashboard's action row (_HomePanel), not
  /// tied to any unit/subtopic selection -- same reasoning as
  /// _openProgressReport for clearing the selection, so the breadcrumb
  /// reads "Home > Improve" regardless of where the student was browsing.
  void _openImprove() {
    setState(() {
      _showImprove = true;
      _selectedUnitId = null;
      _selectedSubtopic = null;
      _lessonId = null;
      _practice = null;
      _unitTest = null;
      _showProgressReport = false;
    });
  }

  void _openProgressReport({VoidCallback? afterSelect}) {
    setState(() {
      _showProgressReport = true;
      // Reachable from the sidebar at any depth, unlike the other leaf
      // panes (always opened from within a specific unit/subtopic) --
      // clear the selection so the breadcrumb shouldn't drag along
      // wherever the student happened to be browsing.
      _selectedUnitId = null;
      _selectedSubtopic = null;
      _lessonId = null;
      _practice = null;
      _unitTest = null;
      _showImprove = false;
    });
    afterSelect?.call();
  }

  /// From a lesson, practice test, unit test, or Profile & Preferences,
  /// back goes to the subtopic overview (or the unit list / home, if this
  /// was opened straight from there — e.g. the dashboard's resume card,
  /// which doesn't select a subtopic). Every answer is already saved
  /// server-side as it's picked, so leaving a unit test mid-way loses
  /// nothing — no confirmation needed.
  void _backFromLeaf() {
    setState(() {
      _lessonId = null;
      _practice = null;
      _unitTest = null;
      _showProgressReport = false;
      _showImprove = false;
    });
  }

  /// From a lesson/practice/test/settings/subtopic, back to the unit's own
  /// subtopic list — what tapping the unit's own breadcrumb crumb does.
  void _backToUnit() {
    setState(() {
      _selectedSubtopic = null;
      _lessonId = null;
      _practice = null;
      _unitTest = null;
      _showProgressReport = false;
      _showImprove = false;
    });
  }

  /// The full path from Home down to whatever's currently on screen, one
  /// [_Crumb] per level — every crumb but the last carries the callback
  /// that jumps straight back to it, so e.g. tapping "Home" from three
  /// levels deep is one tap instead of three taps of a single back arrow.
  /// The last crumb is always the current page and never tappable.
  List<_Crumb> _buildCrumbs(Unit? selectedUnit) {
    final crumbs = <_Crumb>[_Crumb('Home', _goHome)];
    if (selectedUnit != null) {
      crumbs.add(_Crumb(selectedUnit.title, _backToUnit));
    }
    final subtopic = _selectedSubtopic;
    if (subtopic != null) {
      crumbs.add(_Crumb(subtopic.title, _backFromLeaf));
    }
    if (_practice != null) {
      crumbs.add(_Crumb('Practice Test', _backFromLeaf));
    } else if (_lessonId != null) {
      crumbs.add(_Crumb(_lessonTitle ?? 'Lesson', _backFromLeaf));
    } else if (_unitTest != null) {
      crumbs.add(_Crumb('Test', _backFromLeaf));
    } else if (_showProgressReport) {
      crumbs.add(_Crumb('Progress Report', _backFromLeaf));
    } else if (_showImprove) {
      crumbs.add(_Crumb('Improve', _backFromLeaf));
    }
    final current = crumbs.removeLast();
    crumbs.add(_Crumb(current.label, null));
    return crumbs;
  }

  Widget _buildSidebar({
    VoidCallback? afterSelect,
    bool collapsed = false,
    VoidCallback? onToggleCollapsed,
  }) {
    return CurriculumSidebar(
      course: widget.course,
      units: widget.units,
      subtopicsByUnit: widget.subtopicsByUnit,
      isUnitExpanded: (unitId) => unitId == _selectedUnitId,
      selectedSubtopicId: _selectedSubtopic?.id,
      onSelectHome: () {
        _goHome();
        afterSelect?.call();
      },
      homeSelected: _selectedUnitId == null,
      onSelectUnit: (unitId) {
        _selectUnit(unitId);
        afterSelect?.call();
      },
      onSelectSubtopic: (subtopic) {
        _selectSubtopic(subtopic);
        afterSelect?.call();
      },
      onOpenProgressReport: () => _openProgressReport(afterSelect: afterSelect),
      collapsed: collapsed,
      onToggleCollapsed: onToggleCollapsed,
    );
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

    // Below this width there isn't room for a permanent 260px unit list
    // next to any usable amount of content (this is what a phone hits) --
    // the list moves into a drawer instead, opened from the menu button in
    // its own slim local bar. Above it, the list stays pinned on screen as
    // it always has, same as the mindmap view's own sidebar.
    final isNarrow = MediaQuery.sizeOf(context).width < 720;

    if (!isNarrow) {
      return Row(
        children: [
          SizedBox(
            width: widget.sidebarCollapsed ? 64 : 260,
            child: _buildSidebar(
              collapsed: widget.sidebarCollapsed,
              onToggleCollapsed: widget.onToggleSidebarCollapsed,
            ),
          ),
          VerticalDivider(
            width: 1,
            color: scheme.outlineVariant.withValues(alpha: 0.3),
          ),
          Expanded(child: _buildMain(selectedUnit)),
        ],
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      drawer: Drawer(
        child: SafeArea(
          child: _buildSidebar(afterSelect: () => Navigator.pop(context)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: scheme.surfaceContainerLow,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 44,
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Units',
                      icon: const Icon(Icons.menu),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    Expanded(
                      child: Text(
                        widget.course.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: scheme.outlineVariant.withValues(alpha: 0.3),
          ),
          Expanded(child: _buildMain(selectedUnit)),
        ],
      ),
    );
  }

  Widget _buildMain(Unit? selectedUnit) {
    // Built once per state change and threaded into whichever pane is
    // showing — every non-home pane starts with the same trail instead of
    // each rebuilding its own single-level back header.
    final breadcrumb = _BreadcrumbTrail(crumbs: _buildCrumbs(selectedUnit));

    final practice = _practice;
    if (practice != null) {
      return _LeafPane(
        breadcrumb: breadcrumb,
        child: PracticeTestPage(
          key: ValueKey(
            'practice-${practice.unitCode}-${practice.subtopicCode}',
          ),
          courseCode: widget.course.code,
          unitCode: practice.unitCode,
          subtopicCode: practice.subtopicCode,
          subtopicTitle: practice.title,
          embedded: true,
          onFinished: _backFromLeaf,
          onOpenLesson: _openLesson,
        ),
      );
    }
    final lessonId = _lessonId;
    if (lessonId != null) {
      return _LeafPane(
        breadcrumb: breadcrumb,
        child: LessonBody(
          key: ValueKey('lesson-$lessonId'),
          lessonId: lessonId,
        ),
      );
    }
    if (_showProgressReport) {
      return _LeafPane(
        breadcrumb: breadcrumb,
        child: const ProgressReportPage(embedded: true),
      );
    }
    if (_showImprove) {
      return _LeafPane(
        breadcrumb: breadcrumb,
        child: ImprovePage(
          key: ValueKey('improve-${widget.course.code}'),
          courseCode: widget.course.code,
          embedded: true,
          onFinished: _backFromLeaf,
        ),
      );
    }
    final unitTest = _unitTest;
    if (unitTest != null) {
      return _LeafPane(
        breadcrumb: breadcrumb,
        child: UnitTestPage(
          key: ValueKey('unit-test-${unitTest.unitCode}'),
          courseCode: widget.course.code,
          unitCode: unitTest.unitCode,
          unitTitle: unitTest.title,
          embedded: true,
        ),
      );
    }
    if (selectedUnit == null) {
      return _HomePanel(
        course: widget.course,
        units: widget.units,
        subtopicsByUnit: widget.subtopicsByUnit,
        subtopicStatus: widget.subtopicStatus,
        subtopicScorePercent: widget.subtopicScorePercent,
        subtopicMedal: widget.subtopicMedal,
        onResume: _openPractice,
        onOpenLesson: _openLesson,
        onStartUnitTest: _openUnitTest,
        onOpenImprove: _openImprove,
        onSelectUnit: _selectUnit,
      );
    }
    return _UnitPanel(
      breadcrumb: breadcrumb,
      unit: selectedUnit,
      subtopics: widget.subtopicsByUnit[selectedUnit.id] ?? const [],
      subtopicStatus: widget.subtopicStatus,
      onTapSubtopic: _selectSubtopic,
      onStartUnitTest: () =>
          _openUnitTest(selectedUnit.code, selectedUnit.title),
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

class _UnitTestTarget {
  const _UnitTestTarget({required this.unitCode, required this.title});

  final String unitCode;
  final String title;
}

/// One step in a [_BreadcrumbTrail] — a label and how to jump straight
/// back to it. `onTap == null` marks the current page: always the last
/// crumb in the trail, never tappable, and styled as the pane's own big
/// title rather than another link.
class _Crumb {
  const _Crumb(this.label, this.onTap);

  final String label;
  final VoidCallback? onTap;
}

/// The full path every non-home main-panel state (unit, subtopic, lesson,
/// practice) starts with — Home › Unit › Subtopic › Lesson, say — with
/// every step but the current one tappable. Replaces a single back arrow:
/// jumping from a lesson straight to Home is one tap on the first crumb
/// instead of three taps working back up one level at a time.
class _BreadcrumbTrail extends StatelessWidget {
  const _BreadcrumbTrail({required this.crumbs});

  final List<_Crumb> crumbs;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final current = crumbs.last;
    final trail = crumbs.sublist(0, crumbs.length - 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (trail.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (var i = 0; i < trail.length; i++) ...[
                  if (i > 0)
                    Icon(Icons.chevron_right, size: 15, color: scheme.outline),
                  InkWell(
                    onTap: trail[i].onTap,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 2,
                      ),
                      child: Text(
                        trail[i].label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        Text(
          current.label,
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// A lesson or a practice test, embedded in the main pane with a
/// consistent breadcrumb trail above it instead of its own AppBar.
class _LeafPane extends StatelessWidget {
  const _LeafPane({required this.breadcrumb, required this.child});

  final Widget breadcrumb;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: breadcrumb,
        ),
        Expanded(child: child),
      ],
    );
  }
}

/// The dashboard shown before a unit is picked — a personalized greeting,
/// four quick-start actions (Learn/Quiz/Improve/Test, all targeting
/// whichever subtopic was practiced most recently, or the course's first
/// if nothing has been attempted yet), and a per-unit progress list so the
/// whole course's standing is visible without drilling into each unit
/// first.
class _HomePanel extends ConsumerWidget {
  const _HomePanel({
    required this.course,
    required this.units,
    required this.subtopicsByUnit,
    required this.subtopicStatus,
    required this.subtopicScorePercent,
    required this.subtopicMedal,
    required this.onResume,
    required this.onOpenLesson,
    required this.onStartUnitTest,
    required this.onOpenImprove,
    required this.onSelectUnit,
  });

  final Course course;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final Map<String, ProgressStatus> subtopicStatus;
  final Map<String, double> subtopicScorePercent;
  final Map<String, String> subtopicMedal;

  /// (unitCode, subtopicCode, title) — opens that subtopic's practice test.
  final void Function(String unitCode, String subtopicCode, String title)
  onResume;
  final void Function(String lessonId, String lessonTitle) onOpenLesson;
  final void Function(String unitCode, String unitTitle) onStartUnitTest;
  final VoidCallback onOpenImprove;
  final void Function(String unitId) onSelectUnit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final displayName = ref.watch(profileProvider).value?.displayName;
    final mastery = ref.watch(practiceMasteryProvider).value ?? const {};
    final unitCodeById = ref.watch(unitCodeByIdProvider);

    // This course's subtopics only, newest attempt first.
    final courseSubtopicIds = {
      for (final list in subtopicsByUnit.values)
        for (final s in list) s.id,
    };
    final subtopicById = {
      for (final list in subtopicsByUnit.values)
        for (final s in list) s.id: s,
    };
    final recent =
        mastery.entries.where((e) => courseSubtopicIds.contains(e.key)).toList()
          ..sort((a, b) => b.value.updatedAt.compareTo(a.value.updatedAt));

    final mastered = units
        .where(
          (u) =>
              aggregateUnitStatus(
                (subtopicsByUnit[u.id] ?? const []).map((s) => s.id),
                subtopicStatus,
              ) ==
              ProgressStatus.mastered,
        )
        .length;

    // The Learn/Quiz/Test quick-start actions all point at the same
    // subtopic/unit: whichever was practiced most recently, or the
    // course's very first one if nothing has been attempted yet. Improve
    // needs no target -- it picks its own questions.
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_greeting()}${displayName != null ? ', $displayName' : ''}',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            user == null
                ? 'Sign in to track your progress.'
                : 'Choose what to work on next.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (user != null) ...[
            const SizedBox(height: 24),
            Wrap(
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
                        ? () =>
                              onStartUnitTest(targetUnit.code, targetUnit.title)
                        : null,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          if (user != null && units.isNotEmpty)
            _MedalSummaryRow(mastered: mastered, total: units.length),
          const SizedBox(height: 20),
          if (units.isNotEmpty)
            _UnitProgressList(
              units: units,
              subtopicsByUnit: subtopicsByUnit,
              subtopicStatus: subtopicStatus,
              subtopicScorePercent: subtopicScorePercent,
              subtopicMedal: subtopicMedal,
              onTapUnit: onSelectUnit,
            ),
          const SizedBox(height: 16),
          const _CommunityCard(),
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

/// One of the four quick-start actions on the dashboard. `onTap == null`
/// (no lesson for this subtopic yet, or an edge case with no curriculum
/// content loaded) renders as a plainly disabled tile rather than hiding
/// itself, so the set of four stays visually consistent either way.
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
  /// the other three actions' navy -- it's the app's newest, most
  /// distinctive mode and has no per-topic target the way Learn/Quiz/Test
  /// do, so it reads better as a standout than a fourth identical tile.
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

/// One row per unit, ordered same as the sidebar, each showing an
/// aggregate progress bar/percent/medal and opening straight into that
/// unit's own subtopic list on tap -- the same drill-down the sidebar's
/// own unit links already use.
class _UnitProgressList extends StatelessWidget {
  const _UnitProgressList({
    required this.units,
    required this.subtopicsByUnit,
    required this.subtopicStatus,
    required this.subtopicScorePercent,
    required this.subtopicMedal,
    required this.onTapUnit,
  });

  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final Map<String, ProgressStatus> subtopicStatus;
  final Map<String, double> subtopicScorePercent;
  final Map<String, String> subtopicMedal;
  final void Function(String unitId) onTapUnit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Topics',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        for (final unit in units) ...[
          _UnitProgressRow(
            unit: unit,
            scorePercent: aggregateUnitScorePercent(
              (subtopicsByUnit[unit.id] ?? const []).map((s) => s.id),
              subtopicScorePercent,
            ),
            medal: aggregateUnitMedal(
              (subtopicsByUnit[unit.id] ?? const []).map((s) => s.id),
              subtopicMedal,
            ),
            onTap: () => onTapUnit(unit.id),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _UnitProgressRow extends StatelessWidget {
  const _UnitProgressRow({
    required this.unit,
    required this.scorePercent,
    required this.medal,
    required this.onTap,
  });

  final Unit unit;
  final double? scorePercent;
  final String? medal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final percent = scorePercent ?? 0;
    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unit.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: (percent / 100).clamp(0, 1),
                        minHeight: 6,
                        backgroundColor: scheme.surfaceContainerHighest,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              MedalBadge(medal: medal, size: 20),
              const SizedBox(width: 6),
              Text(
                '${percent.round()}%',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: scheme.outline),
            ],
          ),
        ),
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

/// A hand-maintained link out to the parent company's own site for STEM
/// events, competitions, and volunteer/part-time opportunities relevant
/// to high school students — deliberately just a card someone updates by
/// visiting astrostemlabs.com's own events page every so often, not a
/// content pipeline: no CMS, no admin UI, nothing in this app to keep in
/// sync. Uses the app's own navy/teal system rather than the coral/gold
/// brand marks reserved for the login page's actual front door — this
/// card lives deep in the app, not at the door.
class _CommunityCard extends StatelessWidget {
  const _CommunityCard();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.campaign_outlined, color: scheme.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'From Astro STEM Labs',
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'STEM events, competitions, and volunteer or part-time '
            'opportunities for high school students, from our parent program.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => launchUrl(
              Uri.parse('https://www.astrostemlabs.com/'),
              webOnlyWindowName: '_blank',
            ),
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('Visit astrostemlabs.com'),
          ),
        ],
      ),
    );
  }
}

/// The subtopics of whichever unit is selected in the sidebar.
class _UnitPanel extends StatelessWidget {
  const _UnitPanel({
    required this.breadcrumb,
    required this.unit,
    required this.subtopics,
    required this.subtopicStatus,
    required this.onTapSubtopic,
    required this.onStartUnitTest,
  });

  final Widget breadcrumb;
  final Unit unit;
  final List<Subtopic> subtopics;
  final Map<String, ProgressStatus> subtopicStatus;
  final void Function(Subtopic subtopic) onTapSubtopic;

  /// Opens a graded mock test across every subtopic in this unit — see
  /// unit_test_page.dart. A different thing from tapping into one
  /// subtopic's own Practice Test below: no feedback until the whole
  /// paper is handed in, and it never moves a medal or a mindmap colour.
  final VoidCallback onStartUnitTest;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sorted = [...subtopics]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        breadcrumb,
        if (unit.description != null) ...[
          const SizedBox(height: 4),
          Text(
            unit.description!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        const SizedBox(height: 16),
        Material(
          color: scheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onStartUnitTest,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(Icons.fact_check_outlined, color: scheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Take a mock test',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: scheme.primary,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'A graded paper across every topic in this unit — no '
                          "feedback until you're done.",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: scheme.primary),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        for (final subtopic in sorted)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SubtopicCard(
              subtopic: subtopic,
              status: subtopicStatus[subtopic.id] ?? ProgressStatus.notStarted,
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
    required this.onTap,
  });

  final Subtopic subtopic;
  final ProgressStatus status;
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
              Icon(Icons.chevron_right, color: scheme.outline, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
