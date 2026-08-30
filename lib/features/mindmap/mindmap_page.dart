import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/brand_badge.dart';
import '../../models/course.dart';
import '../../models/profile.dart';
import '../../models/progress_status.dart';
import '../../models/subtopic.dart';
import '../../models/unit.dart';
import '../../state/auth_providers.dart';
import '../../state/curriculum_providers.dart';
import '../../state/profile_providers.dart';
import '../../state/progress_providers.dart';
import '../admin/admin_page.dart';
import '../auth/complete_profile_page.dart';
import '../classroom/classroom_view.dart';
import '../classroom/curriculum_sidebar.dart';
import '../lesson/lesson_page.dart';
import '../practice_test/practice_test_page.dart';
import '../progress_report/progress_report_page.dart';
import '../settings/settings_page.dart';
import '../topic_detail/topic_detail_sheet.dart';
import 'widgets/hoverable_node.dart';
import 'widgets/mindmap_node_widget.dart';

const _rootId = 'root';

/// The two ways to browse the curriculum — a spatial mindmap, or the
/// classroom view (left-hand unit list + a resume-where-you-left-off
/// dashboard, ClassroomView). Same underlying data and subtopic detail
/// sheet either way; some students navigate a list faster than a map.
enum _TopicViewMode { mindmap, tree }

// A large, fixed logical canvas the mindmap lives on. Nodes are positioned
// freely within it (in canvas coordinates) and the InteractiveViewer lets
// the user pan/zoom around it — same idea as Coggle's infinite board.
const _canvasSize = Size(4400, 4400);
const _canvasCenter = Offset(2200, 2200);

// Distance from the root to the first unit on each side, and the gap left
// between two units' fans on the same side (see placeSide) — units grow
// outward toward the left/right margins in a roughly horizontal row, the
// way a horizontal mind map's primary branches do; only their subtopics
// branch vertically off of that.
//
// 200 (the previous value) brought some units' near edge uncomfortably
// close to the root pill for a long single-line title — nudged back out a
// bit while staying well short of the original 260. _unitRowGap is
// unchanged; it's the gap between two units' own leaf fans stacked on the
// same side, not the root-to-unit distance this controls.
const _unitOffsetX = 230.0;
const _unitRowGap = 85.0;

// Subtopics ring their unit like the hour marks on a wall clock — evenly
// spaced all the way around at one constant radius, rather than bunched
// into a partial arc on the outward side the way this used to work. See
// _unitFanReach below: whatever a full ring's reach back toward the root
// works out to, placeSide already spaces units in the row far enough
// apart to clear it, so this doesn't need its own "leave a blind cone
// toward the root" carve-out the old arc version needed.
const _leafMinRadius = 128.0;
// NOT safe to shorten below this: computing every real leaf pair's
// on-screen (dx, dy) against the subtopic box (now 248x~48, after another
// font-size increase) analytically turned up an actual overlap below this
// for some real subtopic counts found in seed.sql (4 through 9 per unit).
// 258 is the smallest value with zero overlap across all of them at the
// current box size.
const _leafTargetChord = 258.0;

// Zoom bounds for the mindmap canvas — shared by InteractiveViewer's own
// pinch/drag-scale gestures, the explicit Cmd/Ctrl+scroll zoom below, and
// _fitToContent's own fit-to-viewport zoom, so all three agree on how far
// in/out the student (or the auto-fit) can go. Lower than it used to be —
// _fitToContent needs the headroom to actually fit a fully-expanded, dense
// course (several units each showing 8-9 subtopics) without cropping it.
const _minZoom = 0.18;
const _maxZoom = 2.2;

class MindmapPage extends ConsumerStatefulWidget {
  const MindmapPage({super.key});

  @override
  ConsumerState<MindmapPage> createState() => _MindmapPageState();
}

class _MindmapPageState extends ConsumerState<MindmapPage> {
  final TransformationController _transformController =
      TransformationController();

  /// Center position of every currently-visible node, in canvas coordinates.
  /// Free-dragging a node just overwrites its entry here.
  final Map<String, Offset> _positions = {};
  final Set<String> _expandedUnitIds = {};

  bool _layoutInitialized = false;
  bool _canvasGesturesEnabled = true;
  Size _lastViewportSize = Size.zero;
  String? _layoutCourseId;

  /// The user's manual pick for this session, if they've toggled it —
  /// takes priority over their saved default_view preference so a
  /// deliberate switch never gets silently reverted mid-session.
  _TopicViewMode? _viewModeOverride;

  /// Whether the left-hand curriculum sidebar is shrunk to an icon-only
  /// rail instead of its normal width — toggled by the button inside
  /// [CurriculumSidebar] itself, not the AppBar. A manual per-session
  /// choice, not a saved preference — same treatment as _viewModeOverride.
  /// Only meaningful at >=720px; below that the sidebar is already a
  /// drawer and this has no effect.
  bool _sidebarCollapsed = false;

  /// A lesson or practice test opened from the mindmap canvas, shown in
  /// place of the canvas rather than as its own route — same reasoning
  /// the classroom view already follows, just applied here too now that
  /// the mindmap has a sidebar of its own to lose. Null means "show the
  /// canvas"; at most one of these two is ever set at a time.
  String? _embeddedLessonId;
  String? _embeddedLessonTitle;
  _MindmapPracticeTarget? _embeddedPractice;
  bool _embeddedSettings = false;
  bool _embeddedProgressReport = false;

  void _openEmbeddedSettings() {
    setState(() {
      _embeddedSettings = true;
      _embeddedLessonId = null;
      _embeddedPractice = null;
      _embeddedProgressReport = false;
    });
  }

  void _openEmbeddedProgressReport() {
    setState(() {
      _embeddedProgressReport = true;
      _embeddedLessonId = null;
      _embeddedPractice = null;
      _embeddedSettings = false;
    });
  }

  void _openEmbeddedLesson(String lessonId, String lessonTitle) {
    setState(() {
      _embeddedLessonId = lessonId;
      _embeddedLessonTitle = lessonTitle;
      _embeddedPractice = null;
      _embeddedSettings = false;
      _embeddedProgressReport = false;
    });
  }

  void _openEmbeddedPractice(
    String unitCode,
    String subtopicCode,
    String title,
  ) {
    setState(() {
      _embeddedPractice = _MindmapPracticeTarget(
        unitCode: unitCode,
        subtopicCode: subtopicCode,
        title: title,
      );
      _embeddedLessonId = null;
      _embeddedSettings = false;
      _embeddedProgressReport = false;
    });
  }

  void _closeEmbedded() {
    setState(() {
      _embeddedLessonId = null;
      _embeddedPractice = null;
      _embeddedSettings = false;
      _embeddedProgressReport = false;
    });
  }

  /// Whether Cmd/Ctrl is currently held — tracked from real keyboard events
  /// (not from the scroll event itself) so it's already up to date *before*
  /// a scroll tick arrives. InteractiveViewer has its own built-in
  /// wheel-to-zoom behavior that isn't something a Listener further down
  /// the tree can preempt per-event (there's no reliable way to "win" that
  /// race), so the only clean way to stop it double-processing the same
  /// tick as our own zoom is to disable its scaleEnabled/panEnabled outright
  /// while this is true.
  bool _zoomModifierHeld = false;

  Map<String, List<Subtopic>> _subtopicsByUnit = {};

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _transformController.dispose();
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    final held =
        HardwareKeyboard.instance.isMetaPressed ||
        HardwareKeyboard.instance.isControlPressed;
    if (held != _zoomModifierHeld) {
      setState(() => _zoomModifierHeld = held);
    }
    return false;
  }

  void _ensureLayout(
    String courseId,
    List<Unit> units,
    List<Subtopic> subtopics,
  ) {
    if (_layoutCourseId != courseId) {
      // Switched grades: start that grade's mindmap fresh rather than
      // mixing its units into whatever was dragged around for the last one.
      _layoutCourseId = courseId;
      _positions.clear();
      _expandedUnitIds.clear();
      _layoutInitialized = false;
    }

    _subtopicsByUnit = {
      for (final unit in units)
        unit.id: subtopics.where((s) => s.unitId == unit.id).toList()
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex)),
    };

    if (_layoutInitialized) return;
    _layoutInitialized = true;

    _positions[_rootId] = _canvasCenter;

    // Fan the units out left/right of the root, alternating sides so both
    // fill up evenly — the classic two-sided mindmap silhouette.
    final sortedUnits = [...units]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final rightUnits = <Unit>[];
    final leftUnits = <Unit>[];
    for (var i = 0; i < sortedUnits.length; i++) {
      (i.isEven ? rightUnits : leftUnits).add(sortedUnits[i]);
    }

    placeSide(rightUnits, 1);
    placeSide(leftUnits, -1);

    WidgetsBinding.instance.addPostFrameCallback((_) => _fitToContent());
  }

  /// Relative polar placement (angle in degrees measured off the "outward"
  /// direction, radius in px) for each of [count] subtopics, evenly spaced
  /// all the way around a full circle at one constant radius — like the
  /// hour marks on a wall clock. Radius is whatever keeps adjacent leaves
  /// at least [_leafTargetChord] apart on that circle, which shrinks as
  /// [count] grows (more marks fit around the same clock face) down to
  /// [_leafMinRadius].
  List<({double angleDeg, double radius})> _leafLayout(int count) {
    if (count <= 0) return const [];
    if (count == 1) return const [(angleDeg: 0, radius: _leafMinRadius)];

    final angleStep = 360.0 / count;
    final spacingRad = angleStep * math.pi / 180;
    final radius = math.max(
      _leafMinRadius,
      _leafTargetChord / (2 * math.sin(spacingRad / 2)),
    );
    return [
      for (var i = 0; i < count; i++) (angleDeg: i * angleStep, radius: radius),
    ];
  }

  /// How far a unit's own leaf fan (see [_ensureSubtopicPositions]) reaches
  /// outward (away from the root) and — for a wide enough fan — back
  /// toward the root, measured from the unit's own center. Used to give
  /// each unit in a horizontal row just enough room that its fan can never
  /// reach into a neighboring unit's fan.
  ({double towardRoot, double outward}) _unitFanReach(Unit unit) {
    final count = _subtopicsByUnit[unit.id]?.length ?? 0;
    if (count == 0) return (towardRoot: 0, outward: 0);
    var maxOutward = 0.0, maxTowardRoot = 0.0;
    for (final leaf in _leafLayout(count)) {
      // angleDeg is already measured relative to "outward" — reach along
      // that axis is independent of which side (left/right) this ends up
      // placed on, so this can be computed once, unsigned.
      final x = leaf.radius * math.cos(leaf.angleDeg * math.pi / 180);
      maxOutward = math.max(maxOutward, x);
      maxTowardRoot = math.max(maxTowardRoot, -x);
    }
    return (towardRoot: maxTowardRoot, outward: maxOutward);
  }

  /// Lines [side]'s units up in a horizontal row extending outward from the
  /// root — the primary branches of a horizontal mind map grow toward the
  /// left/right margins, not up and down — each one just far enough past
  /// the last that its leaf fan (see [_unitFanReach]) can't reach into the
  /// previous unit's fan. Subtopics do all of the vertical branching.
  ///
  /// The first unit in the row gets this same treatment against the root
  /// itself, not just against a neighbor — now that subtopics ring their
  /// unit all the way around (see [_leafLayout]), a unit's own fan reaches
  /// back toward the root too, and without this a unit with several
  /// subtopics could put one right on top of (or past) the root pill.
  /// [_unitOffsetX] ends up as the closest a subtopic ever gets to the
  /// root, not the unit node itself — a unit with a wide fan simply sits
  /// further out to keep that same clearance, rather than every unit
  /// sitting at a fixed distance regardless of how many subtopics ring it.
  void placeSide(List<Unit> side, double sign) {
    if (side.isEmpty) return;
    var cursorX = _canvasCenter.dx;
    var previousOutwardReach = 0.0;
    for (var i = 0; i < side.length; i++) {
      final unit = side[i];
      final reach = _unitFanReach(unit);
      final gap = i == 0 ? _unitOffsetX : (previousOutwardReach + _unitRowGap);
      cursorX += sign * (gap + reach.towardRoot);
      _positions[unit.id] = Offset(cursorX, _canvasCenter.dy);
      previousOutwardReach = reach.outward;
    }
  }

  void _ensureSubtopicPositions(Unit unit) {
    final subtopics = _subtopicsByUnit[unit.id] ?? const [];
    if (subtopics.every((s) => _positions.containsKey(s.id))) return;

    final unitPos = _positions[unit.id]!;
    final sideSign = unitPos.dx >= _canvasCenter.dx ? 1.0 : -1.0;
    // "Outward" — directly away from the root — is the center of the leaf
    // fan; 0° for a right-side unit, 180° for a left-side one.
    final outwardDeg = sideSign > 0 ? 0.0 : 180.0;

    // Every unit already sits far enough from its row-neighbors for this
    // exact fan (see _unitFanReach), so it can never reach into a
    // neighboring unit's space — subtopics stay right beside their own
    // topic, spread around it like leaves around a branch tip rather than
    // stacked in a column to one side.
    final leaves = _leafLayout(subtopics.length);
    for (var i = 0; i < subtopics.length; i++) {
      final subtopic = subtopics[i];
      if (_positions.containsKey(subtopic.id)) continue;
      final leaf = leaves[i];
      final angleRad = (outwardDeg + leaf.angleDeg) * math.pi / 180;
      _positions[subtopic.id] =
          unitPos +
          Offset(
            leaf.radius * math.cos(angleRad),
            leaf.radius * math.sin(angleRad),
          );
    }
  }

  /// Re-fits the viewer to whatever's currently visible (the root, every
  /// unit, and the subtopics of every expanded unit) — computing a zoom
  /// level that fits it all in the viewport at once, so a student never
  /// has to scroll or manually zoom out just to see the whole map. Called
  /// after the first layout, after every expand/collapse, after a
  /// viewport resize, and from the explicit "Reset view" button — every
  /// one of those is a moment where what needs to fit on screen just
  /// changed, which is exactly when re-fitting makes sense.
  void _fitToContent() {
    if (_lastViewportSize == Size.zero) return;
    final root = _positions[_rootId];
    if (root == null) return;

    var minX = root.dx, maxX = root.dx, minY = root.dy, maxY = root.dy;
    void include(Offset p) {
      minX = math.min(minX, p.dx);
      maxX = math.max(maxX, p.dx);
      minY = math.min(minY, p.dy);
      maxY = math.max(maxY, p.dy);
    }

    for (final unitId in _subtopicsByUnit.keys) {
      final pos = _positions[unitId];
      if (pos != null) include(pos);
    }
    for (final unitId in _expandedUnitIds) {
      for (final subtopic in _subtopicsByUnit[unitId] ?? const <Subtopic>[]) {
        final pos = _positions[subtopic.id];
        if (pos != null) include(pos);
      }
    }

    final contentCenter = Offset((minX + maxX) / 2, (minY + maxY) / 2);

    // Padding around the bounding box of node *centers* gathered above, so
    // the widest boxes (units, up to 280 logical px — see
    // mindmap_node_widget.dart) don't end up flush against the viewport
    // edge. Nodes are much shorter than they are wide, so less padding is
    // needed vertically than horizontally.
    const horizontalPadding = 170.0;
    const verticalPadding = 90.0;
    final contentWidth = (maxX - minX) + horizontalPadding * 2;
    final contentHeight = (maxY - minY) + verticalPadding * 2;

    final fitScale = math
        .min(
          contentWidth > 0 ? _lastViewportSize.width / contentWidth : _maxZoom,
          contentHeight > 0
              ? _lastViewportSize.height / contentHeight
              : _maxZoom,
        )
        .clamp(_minZoom, _maxZoom);

    setState(() {
      _transformController.value = Matrix4.identity()
        ..translateByDouble(
          _lastViewportSize.width / 2 - contentCenter.dx * fitScale,
          _lastViewportSize.height / 2 - contentCenter.dy * fitScale,
          0,
          1,
        )
        // Scaling z too (not just x/y) matters: getMaxScaleOnAxis() (used
        // to read this scale back out elsewhere, e.g. the tree view's own
        // zoom) takes the max across all three axes, so leaving z at 1
        // would make it impossible to ever read back a scale below 1.
        ..scaleByDouble(fitScale, fitScale, fitScale, 1);
    });
  }

  /// Cmd/Ctrl + scroll (trackpad two-finger scroll or a mouse wheel) zooms
  /// the canvas toward the cursor, Coggle/Lucidchart-style. Plain scroll is
  /// left alone so InteractiveViewer's own default pan/zoom behavior keeps
  /// working exactly as before. Only runs while [_zoomModifierHeld] is
  /// true, at which point InteractiveViewer's own scaleEnabled/panEnabled
  /// are already turned off (see build()) so it can't also react to the
  /// same tick — without that, InteractiveViewer's built-in wheel handling
  /// and this one would both apply a zoom to the same scroll tick and
  /// compound into a runaway zoom-out.
  ///
  /// Wired up on a Listener *above* InteractiveViewer (outside its Transform)
  /// so [event.localPosition] is in stable viewport coordinates, unaffected
  /// by the very transform this is about to change — reading a position
  /// from *inside* the transformed subtree could observe a stale transform
  /// (rebuilds don't happen synchronously) and, combined with a fresh read
  /// of the transform for the scale math, drift the zoom pivot further off
  /// with every tick until the canvas scrolled entirely out of view.
  void _handleMindmapScroll(PointerSignalEvent event) {
    if (!_zoomModifierHeld || event is! PointerScrollEvent) return;
    setState(() {
      _transformController.value = computeZoomedTransform(
        oldMatrix: _transformController.value,
        viewportPoint: event.localPosition,
        scrollDeltaY: event.scrollDelta.dy,
        minZoom: _minZoom,
        maxZoom: _maxZoom,
      );
    });
  }

  void _moveNode(String nodeId, Offset delta) {
    final scale = _transformController.value.getMaxScaleOnAxis();
    setState(() {
      _positions[nodeId] = (_positions[nodeId] ?? Offset.zero) + delta / scale;
    });
  }

  /// Drags a unit together with every subtopic already placed under it
  /// (whether or not currently expanded) — the whole branch moves as one
  /// piece, the way it would in a real mindmap, instead of leaving the
  /// subtopics behind.
  void _moveUnit(String unitId, Offset delta) {
    final scale = _transformController.value.getMaxScaleOnAxis();
    final scaledDelta = delta / scale;
    setState(() {
      _positions[unitId] = (_positions[unitId] ?? Offset.zero) + scaledDelta;
      for (final subtopic in _subtopicsByUnit[unitId] ?? const <Subtopic>[]) {
        final pos = _positions[subtopic.id];
        if (pos != null) {
          _positions[subtopic.id] = pos + scaledDelta;
        }
      }
    });
  }

  /// Bumped to force-remount [ClassroomView] (via its key) back to its own
  /// initial state — its unit/subtopic/lesson/practice selection is
  /// private to its State, so short of threading a reset callback all the
  /// way down, a fresh instance is the simplest way to land it back on its
  /// dashboard from outside. Harmless to also do this while the mindmap is
  /// showing instead — ClassroomView just isn't mounted then.
  int _classroomResetNonce = 0;

  /// Resets both surfaces' notion of "home" at once — whichever one is
  /// actually visible is what the student sees change. The mindmap has no
  /// separate dashboard to go home to the way the classroom view does, so
  /// its own "home" is just collapsing every expanded unit and re-fitting
  /// the view, back to the same top-level map a student sees on first
  /// opening this course.
  void _goHome() {
    setState(() {
      _expandedUnitIds.clear();
      _classroomResetNonce++;
      _embeddedLessonId = null;
      _embeddedPractice = null;
      _embeddedSettings = false;
      _embeddedProgressReport = false;
    });
    _fitToContent();
  }

  void _toggleUnit(Unit unit) {
    setState(() {
      if (_expandedUnitIds.contains(unit.id)) {
        _expandedUnitIds.remove(unit.id);
      } else {
        _ensureSubtopicPositions(unit);
        _expandedUnitIds.add(unit.id);
      }
    });
    _fitToContent();
  }

  /// The sidebar (see [CurriculumSidebar]) only knows unit/subtopic ids,
  /// not the canvas positioning this page tracks by [Unit]/[Subtopic]
  /// object — these two adapt a sidebar tap into exactly what tapping the
  /// same unit/subtopic node on the canvas itself would do, so the two
  /// ways of navigating stay in sync rather than growing separate rules.
  void _toggleUnitById(String unitId, List<Unit> units) {
    for (final unit in units) {
      if (unit.id == unitId) {
        _toggleUnit(unit);
        return;
      }
    }
  }

  void _openSubtopicFromSidebar(
    Subtopic subtopic,
    List<Unit> units,
    Course course,
    Map<String, ProgressStatus> subtopicStatus,
  ) {
    if (!_expandedUnitIds.contains(subtopic.unitId)) {
      Unit? unit;
      for (final candidate in units) {
        if (candidate.id == subtopic.unitId) {
          unit = candidate;
          break;
        }
      }
      if (unit != null) {
        setState(() {
          _ensureSubtopicPositions(unit!);
          _expandedUnitIds.add(unit.id);
        });
        _fitToContent();
      }
    }
    final status = subtopicStatus[subtopic.id] ?? ProgressStatus.notStarted;
    showTopicDetailSheet(
      context,
      subtopic: subtopic,
      color: status.color,
      courseCode: course.code,
      onOpenLesson: _openEmbeddedLesson,
      onOpenPractice: (unitCode) =>
          _openEmbeddedPractice(unitCode, subtopic.code, subtopic.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    // An admin's "Home" is the admin screen, not a course -- they aren't
    // a student, so the mindmap/classroom picker and every course-related
    // fetch below would just be noise for that account. Not gated behind
    // the profile finishing its (async) load: for the rare admin account
    // that means one extra frame of the ordinary course view before this
    // swaps in, which is a better tradeoff than adding a loading gate
    // every student would also pay for on every load.
    final profile = ref.watch(profileProvider).value;
    if (profile?.isAdmin == true) {
      return const AdminPage();
    }
    // Google sign-ins never pass through the email/password form's grade
    // and age fields (login_page.dart), so a first-time Google student can
    // reach here with either unset. Age is only ever asked for a Google
    // account specifically (isGoogleAccount) -- an existing email/password
    // account predating schema_age_check.sql also has age == null, but it
    // already ran the gate at signup once, so there's no reason to
    // retroactively interrupt it here too. Ask whatever's still missing, in
    // place of the usual content, same as an admin seeing AdminPage instead
    // -- CompleteProfilePage invalidates profileProvider itself as each
    // question is answered, so this just naturally falls through once both
    // are set.
    final needsGrade =
        profile != null && !profile.isAdmin && profile.grade == null;
    final needsAge =
        profile != null &&
        !profile.isAdmin &&
        profile.age == null &&
        isGoogleAccount(ref.watch(currentUserProvider));
    if (needsGrade || needsAge) {
      return CompleteProfilePage(needsGrade: needsGrade, needsAge: needsAge);
    }

    final coursesAsync = ref.watch(coursesProvider);
    final unitsAsync = ref.watch(unitsProvider);
    final subtopicsAsync = ref.watch(subtopicsProvider);
    final user = ref.watch(currentUserProvider);
    final subtopicStatus = ref.watch(subtopicStatusProvider);
    final subtopicScorePercent = ref.watch(subtopicScorePercentProvider);
    final subtopicMedal = ref.watch(subtopicMedalProvider);

    // The saved preference only takes effect until the student manually
    // toggles the view themselves this session (_viewModeOverride).
    final savedDefaultView = profile?.defaultView;
    final viewMode =
        _viewModeOverride ??
        (savedDefaultView == DefaultView.classroom
            ? _TopicViewMode.tree
            : _TopicViewMode.mindmap);

    // Below this width there isn't room for the mindmap canvas to be
    // usable at all (this is what a phone hits) -- the classroom (tree)
    // view is the only one offered, and it handles its own narrow layout
    // (its unit list becomes a drawer) independently. This overrides the
    // student's own mindmap/classroom choice only for display purposes;
    // their actual preference is untouched, so widening the window back
    // out returns to whichever view they'd picked.
    final isNarrow = MediaQuery.sizeOf(context).width < 720;
    final effectiveViewMode = isNarrow ? _TopicViewMode.tree : viewMode;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: 'Home',
              child: InkWell(
                onTap: _goHome,
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BrandBadge(size: 28),
                      SizedBox(width: 8),
                      Text('Astro STEM Labs'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const _GradeDropdown(),
          ],
        ),
        actions: [
          // The mindmap canvas isn't usable at phone width, so there's
          // nothing to toggle to there -- classroom is the only view on
          // offer, silently, rather than showing a picker that does
          // nothing visible.
          if (!isNarrow)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: SegmentedButton<_TopicViewMode>(
                segments: const [
                  ButtonSegment(
                    value: _TopicViewMode.mindmap,
                    icon: Icon(Icons.hub_outlined, size: 18),
                    tooltip: 'Mindmap view',
                  ),
                  ButtonSegment(
                    value: _TopicViewMode.tree,
                    icon: Icon(Icons.account_tree_outlined, size: 18),
                    tooltip: 'Classroom view',
                  ),
                ],
                selected: {viewMode},
                showSelectedIcon: false,
                onSelectionChanged: (selection) =>
                    setState(() => _viewModeOverride = selection.first),
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          if (effectiveViewMode == _TopicViewMode.mindmap)
            IconButton(
              tooltip: 'Reset view',
              icon: const Icon(Icons.center_focus_strong),
              onPressed: _fitToContent,
            ),
          if (user == null)
            TextButton(
              onPressed: () => context.push('/login'),
              child: const Text('Sign in'),
            )
          else
            // "Profile & Preferences" isn't offered here — the sidebar's
            // own link to it (CurriculumSidebar, always reachable: pinned
            // in wide layouts, via the drawer in the narrow classroom
            // layout) opens it embedded, keeping this AppBar and the
            // sidebar itself on screen. A second entry point here would
            // just be the old full-screen route that loses both.
            PopupMenuButton<String>(
              icon: const Icon(Icons.account_circle),
              onSelected: (value) {
                if (value == 'sign_out') {
                  ref.read(supabaseClientProvider).auth.signOut();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Text(user.email ?? 'Signed in'),
                ),
                const PopupMenuItem(value: 'sign_out', child: Text('Sign out')),
              ],
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
        child: coursesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Failed to load curriculum: $error')),
          data: (_) => unitsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) =>
                Center(child: Text('Failed to load curriculum: $error')),
            data: (_) => subtopicsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text('Failed to load curriculum: $error')),
              data: (_) {
                final course = ref.watch(selectedCourseProvider);
                if (course == null) {
                  return const Center(
                    child: Text('No courses configured yet.'),
                  );
                }
                final units = ref.watch(courseUnitsProvider);
                final subtopics = ref.watch(courseSubtopicsProvider);
                _ensureLayout(course.id, units, subtopics);

                if (effectiveViewMode == _TopicViewMode.tree) {
                  return ClassroomView(
                    key: ValueKey('classroom-$_classroomResetNonce'),
                    course: course,
                    units: units,
                    subtopicsByUnit: _subtopicsByUnit,
                    subtopicStatus: subtopicStatus,
                    subtopicScorePercent: subtopicScorePercent,
                    sidebarCollapsed: _sidebarCollapsed,
                    onToggleSidebarCollapsed: () =>
                        setState(() => _sidebarCollapsed = !_sidebarCollapsed),
                  );
                }

                // Only reachable at >=720px -- effectiveViewMode forces
                // tree below that, so the sidebar here never has to
                // collapse into a drawer the way the classroom view's
                // own does.
                return Row(
                  children: [
                    SizedBox(
                      width: _sidebarCollapsed ? 64 : 260,
                      child: CurriculumSidebar(
                        course: course,
                        units: units,
                        subtopicsByUnit: _subtopicsByUnit,
                        subtopicStatus: subtopicStatus,
                        subtopicScorePercent: subtopicScorePercent,
                        isUnitExpanded: (unitId) =>
                            _expandedUnitIds.contains(unitId),
                        onSelectHome: _goHome,
                        homeSelected: _expandedUnitIds.isEmpty,
                        onSelectUnit: (unitId) =>
                            _toggleUnitById(unitId, units),
                        onSelectSubtopic: (subtopic) =>
                            _openSubtopicFromSidebar(
                              subtopic,
                              units,
                              course,
                              subtopicStatus,
                            ),
                        collapsed: _sidebarCollapsed,
                        onToggleCollapsed: () => setState(
                          () => _sidebarCollapsed = !_sidebarCollapsed,
                        ),
                        onOpenSettings: _openEmbeddedSettings,
                        onOpenProgressReport: _openEmbeddedProgressReport,
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                      color: Theme.of(context).colorScheme.outlineVariant
                          .withValues(alpha: 0.3),
                    ),
                    Expanded(
                      child: _embeddedSettings
                          ? _MindmapEmbeddedPane(
                              title: 'Profile & Preferences',
                              onBack: _closeEmbedded,
                              child: const SettingsPage(embedded: true),
                            )
                          : _embeddedProgressReport
                          ? _MindmapEmbeddedPane(
                              title: 'Progress Report',
                              onBack: _closeEmbedded,
                              child: const ProgressReportPage(embedded: true),
                            )
                          : _embeddedPractice != null
                          ? _MindmapEmbeddedPane(
                              title: _embeddedPractice!.title,
                              onBack: _closeEmbedded,
                              child: PracticeTestPage(
                                key: ValueKey(
                                  'practice-${_embeddedPractice!.unitCode}-${_embeddedPractice!.subtopicCode}',
                                ),
                                courseCode: course.code,
                                unitCode: _embeddedPractice!.unitCode,
                                subtopicCode: _embeddedPractice!.subtopicCode,
                                subtopicTitle: _embeddedPractice!.title,
                                embedded: true,
                                onFinished: _closeEmbedded,
                              ),
                            )
                          : _embeddedLessonId != null
                          ? _MindmapEmbeddedPane(
                              title: _embeddedLessonTitle ?? 'Lesson',
                              onBack: _closeEmbedded,
                              child: LessonBody(
                                key: ValueKey('lesson-$_embeddedLessonId'),
                                lessonId: _embeddedLessonId!,
                              ),
                            )
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                final viewportSize = constraints.biggest;
                                if (viewportSize != _lastViewportSize) {
                                  final wasZero =
                                      _lastViewportSize == Size.zero;
                                  _lastViewportSize = viewportSize;
                                  if (wasZero) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                          (_) => _fitToContent(),
                                        );
                                  }
                                }
                                return Listener(
                                  behavior: HitTestBehavior.opaque,
                                  onPointerSignal: _handleMindmapScroll,
                                  child: InteractiveViewer(
                                    transformationController:
                                        _transformController,
                                    constrained: false,
                                    // Disabled for the duration of any node-level
                                    // pointer interaction (see _DraggableNode) so
                                    // InteractiveViewer's own pan/scale recognizer
                                    // never competes with — or nudges the canvas
                                    // during — a tap or drag on a node. Also
                                    // disabled while Cmd/Ctrl is held so its own
                                    // built-in wheel-to-zoom doesn't
                                    // double-process the same scroll tick our
                                    // custom zoom handler is already applying
                                    // (see _handleMindmapScroll).
                                    panEnabled:
                                        _canvasGesturesEnabled &&
                                        !_zoomModifierHeld,
                                    scaleEnabled:
                                        _canvasGesturesEnabled &&
                                        !_zoomModifierHeld,
                                    minScale: _minZoom,
                                    maxScale: _maxZoom,
                                    boundaryMargin: const EdgeInsets.all(1200),
                                    child: SizedBox(
                                      width: _canvasSize.width,
                                      height: _canvasSize.height,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned.fill(
                                            child: CustomPaint(
                                              painter: _MindmapEdgePainter(
                                                positions: _positions,
                                                units: units,
                                                subtopicsByUnit:
                                                    _subtopicsByUnit,
                                                expandedUnitIds:
                                                    _expandedUnitIds,
                                                subtopicStatus: subtopicStatus,
                                              ),
                                            ),
                                          ),
                                          ..._buildNodes(
                                            course,
                                            units,
                                            subtopicStatus,
                                            subtopicScorePercent,
                                            subtopicMedal,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNodes(
    Course course,
    List<Unit> units,
    Map<String, ProgressStatus> subtopicStatus,
    Map<String, double> subtopicScorePercent,
    Map<String, String> subtopicMedal,
  ) {
    final nodes = <Widget>[];

    final rootPos = _positions[_rootId];
    if (rootPos != null) {
      nodes.add(
        _DraggableNode(
          position: rootPos,
          onDragStart: () => setState(() => _canvasGesturesEnabled = false),
          onDragUpdate: (delta) => _moveNode(_rootId, delta),
          onDragEnd: () => setState(() => _canvasGesturesEnabled = true),
          // Same collapse-everything-back-to-units behavior as tapping
          // "Home" in the sidebar or the app title — a quick way to back
          // out of however many units a student has fanned open, without
          // hunting for either of those.
          onTap: _goHome,
          child: HoverableNode(
            message: 'Collapse every unit back to this view.',
            highlightColor: Theme.of(context).colorScheme.primary,
            child: RootNodeWidget(label: course.gradeLabel),
          ),
        ),
      );
    }

    for (final unit in units) {
      final unitPos = _positions[unit.id];
      if (unitPos == null) continue;

      final subtopicIds = (_subtopicsByUnit[unit.id] ?? const []).map(
        (s) => s.id,
      );
      final unitStatus = aggregateUnitStatus(subtopicIds, subtopicStatus);
      final unitScorePercent = aggregateUnitScorePercent(
        subtopicIds,
        subtopicScorePercent,
      );
      final unitMedal = aggregateUnitMedal(subtopicIds, subtopicMedal);
      final subtopicsInUnit = _subtopicsByUnit[unit.id] ?? const <Subtopic>[];
      nodes.add(
        _DraggableNode(
          position: unitPos,
          onDragStart: () => setState(() => _canvasGesturesEnabled = false),
          onDragUpdate: (delta) => _moveUnit(unit.id, delta),
          onDragEnd: () => setState(() => _canvasGesturesEnabled = true),
          onTap: () => _toggleUnit(unit),
          child: HoverableNode(
            // The node itself no longer shows "unit N of M" / topic count —
            // see UnitNodeWidget's own doc comment — so that context moves
            // into the one place a student already looks to learn more
            // about a node: the hover tooltip.
            message:
                '${unitStatus.hoverMessage(noun: 'unit', scorePercent: unitScorePercent)} Unit ${unit.orderIndex + 1} of ${units.length}, '
                '${subtopicsInUnit.length} '
                '${subtopicsInUnit.length == 1 ? 'topic' : 'topics'}.',
            highlightColor: unitStatus.color,
            child: UnitNodeWidget(
              unit: unit,
              status: unitStatus,
              collapsed: !_expandedUnitIds.contains(unit.id),
              scorePercent: unitScorePercent,
              medal: unitMedal,
            ),
          ),
        ),
      );

      if (!_expandedUnitIds.contains(unit.id)) continue;
      for (final subtopic in subtopicsInUnit) {
        final subPos = _positions[subtopic.id];
        if (subPos == null) continue;
        final status = subtopicStatus[subtopic.id] ?? ProgressStatus.notStarted;
        nodes.add(
          _DraggableNode(
            position: subPos,
            onDragStart: () => setState(() => _canvasGesturesEnabled = false),
            onDragUpdate: (delta) => _moveNode(subtopic.id, delta),
            onDragEnd: () => setState(() => _canvasGesturesEnabled = true),
            onTap: () => showTopicDetailSheet(
              context,
              subtopic: subtopic,
              color: status.color,
              courseCode: course.code,
              onOpenLesson: _openEmbeddedLesson,
              onOpenPractice: (unitCode) => _openEmbeddedPractice(
                unitCode,
                subtopic.code,
                subtopic.title,
              ),
            ),
            child: HoverableNode(
              message:
                  '${status.hoverMessage(scorePercent: subtopicScorePercent[subtopic.id])} Topic ${subtopic.orderIndex + 1} of '
                  '${subtopicsInUnit.length} in this unit.',
              highlightColor: status.color,
              child: SubtopicNodeWidget(subtopic: subtopic, status: status),
            ),
          ),
        );
      }
    }

    return nodes;
  }
}

class _MindmapPracticeTarget {
  const _MindmapPracticeTarget({
    required this.unitCode,
    required this.subtopicCode,
    required this.title,
  });

  final String unitCode;
  final String subtopicCode;
  final String title;
}

/// Wraps an embedded lesson or practice test with a small "back to
/// mindmap" header — the canvas's equivalent of the classroom view's
/// breadcrumb trail, just one level deep since the canvas itself (not
/// another pane) is always what's underneath.
class _MindmapEmbeddedPane extends StatelessWidget {
  const _MindmapEmbeddedPane({
    required this.title,
    required this.onBack,
    required this.child,
  });

  final String title;
  final VoidCallback onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 18),
                        SizedBox(width: 6),
                        Text('Mindmap'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

/// AppBar chip that shows the currently-selected grade and opens a menu to
/// switch to another. Hidden until courses have loaded.
class _GradeDropdown extends ConsumerWidget {
  const _GradeDropdown();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(visibleCoursesProvider);
    final selected = ref.watch(selectedCourseProvider);
    if (courses.isEmpty || selected == null) return const SizedBox.shrink();

    return PopupMenuButton<String>(
      tooltip: 'Choose grade',
      onSelected: (value) =>
          ref.read(selectedCourseIdProvider.notifier).select(value),
      itemBuilder: (context) => [
        for (final course in courses)
          PopupMenuItem(value: course.id, child: Text(course.gradeLabel)),
      ],
      child: Builder(
        builder: (context) {
          // Theme-derived, not hardcoded white: the AppBar's own background
          // already flips between near-black (dark theme) and near-white
          // (light theme) with no override, so a fixed white-on-white
          // pill made this chip unreadable — and effectively invisible —
          // in light mode.
          final onSurface = Theme.of(context).colorScheme.onSurface;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selected.gradeLabel,
                  style: TextStyle(
                    color: onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.expand_more, color: onSurface, size: 18),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Wraps a node in a draggable, tappable handle positioned at [position]
/// (its center) in the parent Stack's coordinate space.
///
/// This uses raw `Listener` pointer callbacks rather than `GestureDetector`.
/// The node sits inside an `InteractiveViewer` (for canvas pan/zoom), and
/// `InteractiveViewer` runs its own pan/scale gesture recognizer that
/// competes with — and can swallow — a descendant `GestureDetector`'s tap
/// or pan recognizers in the gesture arena, a well-known Flutter pitfall.
/// `Listener` bypasses the arena entirely: every pointer along the hit path
/// gets the raw down/move/up events, so we can reliably tell tap from drag
/// ourselves and disable the viewer's `panEnabled` the instant a node-drag
/// starts, before `InteractiveViewer` ever gets a chance to claim it.
class _DraggableNode extends StatefulWidget {
  const _DraggableNode({
    required this.position,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.child,
    this.onTap,
  });

  final Offset position;
  final VoidCallback onDragStart;
  final void Function(Offset delta) onDragUpdate;
  final VoidCallback onDragEnd;
  final VoidCallback? onTap;
  final Widget child;

  @override
  State<_DraggableNode> createState() => _DraggableNodeState();
}

class _DraggableNodeState extends State<_DraggableNode> {
  // A real mouse or trackpad click almost always carries a few pixels of
  // incidental jitter between press and release. A tight threshold here
  // misclassifies an intended click as a drag and silently swallows the
  // tap, so this is deliberately forgiving — comfortably above typical
  // click jitter, comfortably below a deliberate drag.
  static const _tapDistanceThreshold = 12.0;

  double _movedDistance = 0;
  bool _active = false;

  void _handlePointerDown(PointerDownEvent event) {
    _movedDistance = 0;
    _active = true;
    widget.onDragStart();
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!_active) return;
    _movedDistance += event.delta.distance;
    widget.onDragUpdate(event.delta);
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (!_active) return;
    _active = false;
    widget.onDragEnd();
    if (_movedDistance < _tapDistanceThreshold && widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (!_active) return;
    _active = false;
    widget.onDragEnd();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: _handlePointerDown,
            onPointerMove: _handlePointerMove,
            onPointerUp: _handlePointerUp,
            onPointerCancel: _handlePointerCancel,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _MindmapEdgePainter extends CustomPainter {
  _MindmapEdgePainter({
    required this.positions,
    required this.units,
    required this.subtopicsByUnit,
    required this.expandedUnitIds,
    required this.subtopicStatus,
  });

  final Map<String, Offset> positions;
  final List<Unit> units;
  final Map<String, List<Subtopic>> subtopicsByUnit;
  final Set<String> expandedUnitIds;
  final Map<String, ProgressStatus> subtopicStatus;

  @override
  void paint(Canvas canvas, Size size) {
    final rootPos = positions[_rootId];
    if (rootPos == null) return;

    // Units on the same side now sit in a horizontal row at the root's own
    // height (see placeSide), so a straight root-to-unit line for a
    // farther unit would run directly through any closer unit sitting
    // between it and the root — reading as a chain from unit to unit
    // instead of every unit connecting only to the root. Ranking each
    // unit by its distance from the root lets its curve bow just enough
    // to visibly clear whatever's closer on the same row.
    final rowIndex = <String, int>{};
    final right = <Unit>[], left = <Unit>[];
    for (final unit in units) {
      final pos = positions[unit.id];
      if (pos == null) continue;
      (pos.dx >= rootPos.dx ? right : left).add(unit);
    }
    for (final side in [right, left]) {
      side.sort(
        (a, b) => (positions[a.id]!.dx - rootPos.dx).abs().compareTo(
          (positions[b.id]!.dx - rootPos.dx).abs(),
        ),
      );
      for (var i = 0; i < side.length; i++) {
        rowIndex[side[i].id] = i;
      }
    }

    for (final unit in units) {
      final unitPos = positions[unit.id];
      if (unitPos == null) continue;
      final subtopicIds = (subtopicsByUnit[unit.id] ?? const []).map(
        (s) => s.id,
      );
      final unitStatus = aggregateUnitStatus(subtopicIds, subtopicStatus);
      final index = rowIndex[unit.id] ?? 0;
      final bowDirection = index.isEven ? -1.0 : 1.0;
      final bow = index == 0 ? 0.0 : bowDirection * (60.0 + 55.0 * index);
      _drawCurve(canvas, rootPos, unitPos, unitStatus.color, 4, bow: bow);

      if (!expandedUnitIds.contains(unit.id)) continue;
      for (final subtopic in subtopicsByUnit[unit.id] ?? const <Subtopic>[]) {
        final subPos = positions[subtopic.id];
        if (subPos == null) continue;
        final status = subtopicStatus[subtopic.id] ?? ProgressStatus.notStarted;
        _drawCurve(canvas, unitPos, subPos, status.color, 2.25);
      }
    }
  }

  void _drawCurve(
    Canvas canvas,
    Offset start,
    Offset end,
    Color color,
    double width, {
    double bow = 0,
  }) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    final midX = (start.dx + end.dx) / 2;
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(midX, start.dy + bow, midX, end.dy + bow, end.dx, end.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MindmapEdgePainter oldDelegate) => true;
}

/// Given the canvas's current transform, zooms toward [viewportPoint] (a
/// position in stable, untransformed viewport coordinates) by an amount
/// derived from [scrollDeltaY], clamped to [minZoom]/[maxZoom]. The canvas
/// point currently under [viewportPoint] stays under it after the zoom.
/// A pure function (no widget/controller state) so this can be exercised
/// directly in a unit test, independent of how the scroll event arrived.
Matrix4 computeZoomedTransform({
  required Matrix4 oldMatrix,
  required Offset viewportPoint,
  required double scrollDeltaY,
  required double minZoom,
  required double maxZoom,
}) {
  final oldScale = oldMatrix.getMaxScaleOnAxis();
  final oldTranslation = oldMatrix.getTranslation();
  final canvasPoint = Offset(
    (viewportPoint.dx - oldTranslation.x) / oldScale,
    (viewportPoint.dy - oldTranslation.y) / oldScale,
  );
  final zoomFactor = math.exp(-scrollDeltaY / 200);
  final newScale = (oldScale * zoomFactor).clamp(minZoom, maxZoom);
  final newTranslation = Offset(
    viewportPoint.dx - canvasPoint.dx * newScale,
    viewportPoint.dy - canvasPoint.dy * newScale,
  );
  return Matrix4.identity()
    ..translateByDouble(newTranslation.dx, newTranslation.dy, 0, 1)
    // Scale z too — see the comment on the equivalent line in
    // _fitToContent for why leaving it at 1 breaks reading the scale back
    // out via getMaxScaleOnAxis().
    ..scaleByDouble(newScale, newScale, newScale, 1);
}
