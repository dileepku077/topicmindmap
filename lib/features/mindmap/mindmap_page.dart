import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/course.dart';
import '../../models/progress_status.dart';
import '../../models/subtopic.dart';
import '../../models/unit.dart';
import '../../state/auth_providers.dart';
import '../../state/curriculum_providers.dart';
import '../../state/progress_providers.dart';
import '../topic_detail/topic_detail_sheet.dart';
import 'widgets/hoverable_node.dart';
import 'widgets/mindmap_node_widget.dart';
import 'widgets/topic_tree_view.dart';

const _rootId = 'root';

/// The two ways to browse the curriculum — a spatial mindmap, or a plain
/// top-to-bottom outline. Same data and tap targets either way; some
/// students read a list faster than they read a map.
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
const _unitOffsetX = 250.0;
const _unitRowGap = 70.0;

// Subtopics fan out around their unit like leaves around a branch tip
// instead of stacking in a column to one side. They're spread across an
// arc centered on the "outward" direction (away from the root) — up to
// this many degrees wide, growing with how many there are to fit — with
// only a blind cone directly back toward the root left clear so nothing
// crosses over the connecting line back to the parent.
const _leafMaxSpanDeg = 230.0;
const _leafSpanPerGap = 34.0;
const _leafMinRadius = 130.0;
const _leafTargetChord = 145.0;

// Zoom bounds for the mindmap canvas — shared by InteractiveViewer's own
// pinch/drag-scale gestures and the explicit Cmd/Ctrl+scroll zoom below, so
// both routes agree on how far in/out the student can go.
const _minZoom = 0.3;
const _maxZoom = 2.2;

// Zoom bounds for the tree/list view's text+row scale (no spatial canvas to
// pinch there, so "zoom" just means bigger/smaller rows).
const _minTreeScale = 0.75;
const _maxTreeScale = 1.75;

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
  _TopicViewMode _viewMode = _TopicViewMode.mindmap;

  /// Row/text scale for the tree view's Cmd/Ctrl+scroll zoom — the tree is a
  /// plain list, so "zoom" scales its rows rather than panning a canvas.
  double _treeScale = 1.0;

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
  /// direction, radius in px) for each of [count] subtopics. The arc widens
  /// as [count] grows — a couple of leaves stay close together rather than
  /// being flung to the far top/bottom of the available space, the way an
  /// actual small cluster of leaves would — capped at [_leafMaxSpanDeg] so
  /// it never wraps back around toward the root. Radius is whatever keeps
  /// adjacent leaves comfortably apart at that angular spacing; alternating
  /// leaves sit slightly closer in so the ring reads as organic rather than
  /// a perfectly uniform circle.
  List<({double angleDeg, double radius})> _leafLayout(int count) {
    if (count <= 0) return const [];
    if (count == 1) return const [(angleDeg: 0, radius: _leafMinRadius)];

    final span = math.min(_leafMaxSpanDeg, _leafSpanPerGap * (count - 1));
    final angleStep = span / (count - 1);
    final spacingRad = angleStep * math.pi / 180;
    final radius = math.max(
      _leafMinRadius,
      _leafTargetChord / (2 * math.sin(spacingRad / 2)),
    );
    return [
      for (var i = 0; i < count; i++)
        (
          angleDeg: -span / 2 + i * angleStep,
          radius: radius * (i.isEven ? 1.0 : 0.88),
        ),
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
  void placeSide(List<Unit> side, double sign) {
    if (side.isEmpty) return;
    var cursorX = _canvasCenter.dx + sign * _unitOffsetX;
    var previousOutwardReach = 0.0;
    for (var i = 0; i < side.length; i++) {
      final unit = side[i];
      final reach = _unitFanReach(unit);
      if (i > 0) {
        cursorX +=
            sign * (previousOutwardReach + _unitRowGap + reach.towardRoot);
      }
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

  /// Re-centers the viewer on whatever's currently visible (the root,
  /// every unit, and the subtopics of every expanded unit) — at whatever
  /// zoom level the student currently has set (never auto-shrinking text
  /// to force everything into view, and never resetting a manual zoom).
  /// Called after the first layout and after every expand/collapse.
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
    final scale = _transformController.value.getMaxScaleOnAxis();

    setState(() {
      _transformController.value = Matrix4.identity()
        ..translateByDouble(
          _lastViewportSize.width / 2 - contentCenter.dx * scale,
          _lastViewportSize.height / 2 - contentCenter.dy * scale,
          0,
          1,
        )
        // Scaling z too (not just x/y) matters: getMaxScaleOnAxis() (used
        // to read this scale back out, e.g. next time this runs) takes the
        // max across all three axes, so leaving z at 1 would make it
        // impossible to ever read back a scale below 1.
        ..scaleByDouble(scale, scale, scale, 1);
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

  /// Same Cmd/Ctrl+scroll convention for the tree view, but there's no
  /// canvas to pan/zoom there — it just scales row text/icons up or down.
  /// Only runs while [_zoomModifierHeld] is true, at which point the
  /// ListView's own scroll physics are switched to non-scrollable (see
  /// TopicTreeView's use of [_zoomModifierHeld]) so this doesn't also
  /// scroll the list at the same time.
  void _handleTreeScroll(PointerSignalEvent event) {
    if (!_zoomModifierHeld || event is! PointerScrollEvent) return;
    final zoomFactor = math.exp(-event.scrollDelta.dy / 200);
    setState(() {
      _treeScale = (_treeScale * zoomFactor).clamp(
        _minTreeScale,
        _maxTreeScale,
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

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesProvider);
    final unitsAsync = ref.watch(unitsProvider);
    final subtopicsAsync = ref.watch(subtopicsProvider);
    final user = ref.watch(currentUserProvider);
    final subtopicStatus = ref.watch(subtopicStatusProvider);
    final subtopicScorePercent = ref.watch(subtopicScorePercentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Math Mindmap'),
            SizedBox(width: 12),
            _GradeDropdown(),
          ],
        ),
        actions: [
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
                  tooltip: 'List view',
                ),
              ],
              selected: {_viewMode},
              showSelectedIcon: false,
              onSelectionChanged: (selection) =>
                  setState(() => _viewMode = selection.first),
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          if (_viewMode == _TopicViewMode.mindmap)
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

                if (_viewMode == _TopicViewMode.tree) {
                  return TopicTreeView(
                    course: course,
                    units: units,
                    subtopicsByUnit: _subtopicsByUnit,
                    subtopicStatus: subtopicStatus,
                    subtopicScorePercent: subtopicScorePercent,
                    expandedUnitIds: _expandedUnitIds,
                    scale: _treeScale,
                    zoomModifierHeld: _zoomModifierHeld,
                    onScrollSignal: _handleTreeScroll,
                    onToggleUnit: _toggleUnit,
                    onTapSubtopic: (subtopic, status) => showTopicDetailSheet(
                      context,
                      subtopic: subtopic,
                      color: status.color,
                      courseCode: course.code,
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final viewportSize = constraints.biggest;
                    if (viewportSize != _lastViewportSize) {
                      final wasZero = _lastViewportSize == Size.zero;
                      _lastViewportSize = viewportSize;
                      if (wasZero) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) => _fitToContent(),
                        );
                      }
                    }
                    return Listener(
                      behavior: HitTestBehavior.opaque,
                      onPointerSignal: _handleMindmapScroll,
                      child: InteractiveViewer(
                        transformationController: _transformController,
                        constrained: false,
                        // Disabled for the duration of any node-level
                        // pointer interaction (see _DraggableNode) so
                        // InteractiveViewer's own pan/scale recognizer
                        // never competes with — or nudges the canvas
                        // during — a tap or drag on a node. Also disabled
                        // while Cmd/Ctrl is held so its own built-in
                        // wheel-to-zoom doesn't double-process the same
                        // scroll tick our custom zoom handler is already
                        // applying (see _handleMindmapScroll).
                        panEnabled:
                            _canvasGesturesEnabled && !_zoomModifierHeld,
                        scaleEnabled:
                            _canvasGesturesEnabled && !_zoomModifierHeld,
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
                                    subtopicsByUnit: _subtopicsByUnit,
                                    expandedUnitIds: _expandedUnitIds,
                                    subtopicStatus: subtopicStatus,
                                  ),
                                ),
                              ),
                              ..._buildNodes(
                                course,
                                units,
                                subtopicStatus,
                                subtopicScorePercent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
          child: RootNodeWidget(label: course.gradeLabel),
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
      nodes.add(
        _DraggableNode(
          position: unitPos,
          onDragStart: () => setState(() => _canvasGesturesEnabled = false),
          onDragUpdate: (delta) => _moveUnit(unit.id, delta),
          onDragEnd: () => setState(() => _canvasGesturesEnabled = true),
          onTap: () => _toggleUnit(unit),
          child: HoverableNode(
            message: unitStatus.hoverMessage(
              noun: 'unit',
              scorePercent: unitScorePercent,
            ),
            highlightColor: unitStatus.color,
            child: UnitNodeWidget(
              unit: unit,
              status: unitStatus,
              subtopicCount: (_subtopicsByUnit[unit.id] ?? const []).length,
              collapsed: !_expandedUnitIds.contains(unit.id),
              sequenceNumber: unit.orderIndex + 1,
              scorePercent: unitScorePercent,
            ),
          ),
        ),
      );

      if (!_expandedUnitIds.contains(unit.id)) continue;
      for (final subtopic in _subtopicsByUnit[unit.id] ?? const <Subtopic>[]) {
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
            ),
            child: HoverableNode(
              message: status.hoverMessage(
                scorePercent: subtopicScorePercent[subtopic.id],
              ),
              highlightColor: status.color,
              child: SubtopicNodeWidget(
                subtopic: subtopic,
                status: status,
                sequenceNumber: subtopic.orderIndex + 1,
                scorePercent: subtopicScorePercent[subtopic.id],
              ),
            ),
          ),
        );
      }
    }

    return nodes;
  }
}

/// AppBar chip that shows the currently-selected grade and opens a menu to
/// switch to another. Hidden until courses have loaded.
class _GradeDropdown extends ConsumerWidget {
  const _GradeDropdown();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesProvider).value ?? const [];
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selected.gradeLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more, color: Colors.white, size: 18),
          ],
        ),
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
