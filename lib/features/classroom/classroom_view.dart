import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
import 'curriculum_sidebar.dart';

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
    required this.subtopicMedal,
  });

  final Course course;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final Map<String, ProgressStatus> subtopicStatus;
  final Map<String, double> subtopicScorePercent;
  final Map<String, String> subtopicMedal;

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

  /// From a lesson/practice/subtopic, back to the unit's own subtopic
  /// list — what tapping the unit's own breadcrumb crumb does.
  void _backToUnit() {
    setState(() {
      _selectedSubtopic = null;
      _lessonId = null;
      _practice = null;
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
    }
    final current = crumbs.removeLast();
    crumbs.add(_Crumb(current.label, null));
    return crumbs;
  }

  Widget _buildSidebar({VoidCallback? afterSelect}) {
    return CurriculumSidebar(
      course: widget.course,
      units: widget.units,
      subtopicsByUnit: widget.subtopicsByUnit,
      subtopicStatus: widget.subtopicStatus,
      subtopicMedal: widget.subtopicMedal,
      subtopicScorePercent: widget.subtopicScorePercent,
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
          SizedBox(width: 260, child: _buildSidebar()),
          VerticalDivider(width: 1, color: scheme.outlineVariant.withValues(alpha: 0.3)),
          Expanded(child: _buildMain(selectedUnit)),
        ],
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      drawer: Drawer(child: SafeArea(child: _buildSidebar(afterSelect: () => Navigator.pop(context)))),
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
          Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.3)),
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
        breadcrumb: breadcrumb,
        child: LessonBody(key: ValueKey('lesson-$lessonId'), lessonId: lessonId),
      );
    }
    final subtopic = _selectedSubtopic;
    if (subtopic != null) {
      return _SubtopicPane(
        breadcrumb: breadcrumb,
        subtopic: subtopic,
        courseCode: widget.course.code,
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
      breadcrumb: breadcrumb,
      unit: selectedUnit,
      subtopics: widget.subtopicsByUnit[selectedUnit.id] ?? const [],
      subtopicStatus: widget.subtopicStatus,
      subtopicScorePercent: widget.subtopicScorePercent,
      subtopicMedal: widget.subtopicMedal,
      onTapSubtopic: _selectSubtopic,
      onStartUnitTest: () {
        final uri = Uri(
          path: '/unit-test/${widget.course.code}/${selectedUnit.code}',
          queryParameters: {'title': selectedUnit.title},
        );
        context.push(uri.toString());
      },
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
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
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
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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

/// The inline equivalent of the mindmap's modal subtopic-detail sheet —
/// same [SubtopicOverview] content, just in the main pane with a
/// breadcrumb trail instead of a dismissable sheet.
class _SubtopicPane extends StatelessWidget {
  const _SubtopicPane({
    required this.breadcrumb,
    required this.subtopic,
    required this.courseCode,
    required this.onOpenLesson,
    required this.onOpenPractice,
  });

  final Widget breadcrumb;
  final Subtopic subtopic;
  final String courseCode;
  final void Function(String lessonId, String lessonTitle) onOpenLesson;
  final void Function(String unitCode) onOpenPractice;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        breadcrumb,
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
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
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
    required this.subtopicScorePercent,
    required this.subtopicMedal,
    required this.onTapSubtopic,
    required this.onStartUnitTest,
  });

  final Widget breadcrumb;
  final Unit unit;
  final List<Subtopic> subtopics;
  final Map<String, ProgressStatus> subtopicStatus;
  final Map<String, double> subtopicScorePercent;
  final Map<String, String> subtopicMedal;
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
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
              scorePercent: subtopicScorePercent[subtopic.id],
              medal: subtopicMedal[subtopic.id],
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
    required this.medal,
    required this.onTap,
  });

  final Subtopic subtopic;
  final ProgressStatus status;
  final double? scorePercent;
  final String? medal;
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
              if (medal != null && medal != 'None') ...[
                MedalBadge(medal: medal, size: 18),
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
