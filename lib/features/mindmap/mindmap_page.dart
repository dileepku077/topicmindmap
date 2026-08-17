import 'dart:math' as math;

import 'package:flutter/material.dart';
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
import 'widgets/mindmap_node_widget.dart';

const _rootId = 'root';

// A large, fixed logical canvas the mindmap lives on. Nodes are positioned
// freely within it (in canvas coordinates) and the InteractiveViewer lets
// the user pan/zoom around it — same idea as Coggle's infinite board.
const _canvasSize = Size(4400, 4400);
const _canvasCenter = Offset(2200, 2200);

// Horizontal distance from the root to a unit — generous on purpose so the
// first-glance topic list has real breathing room around it, not a tight
// cluster.
const _unitOffsetX = 340.0;
const _subtopicNodeHeight = 56.0;

// The minimum vertical territory a unit gets even with zero subtopics, and
// the guaranteed gap of empty canvas left between two units' territories —
// this is what keeps the collapsed topic list visibly spread out and
// guarantees one unit's subtopics can never reach into a neighbor's.
const _minUnitSlotHeight = 170.0;
const _unitSlotGap = 90.0;

// Subtopics fan out around their unit like leaves around a branch tip
// instead of stacking in a column to one side. They're spread across an
// arc centered on the "outward" direction (away from the root) — up to
// this many degrees wide, growing with how many there are to fit — with
// only a blind cone directly back toward the root left clear so nothing
// crosses over the connecting line back to the parent.
const _leafMaxSpanDeg = 240.0;
const _leafSpanPerGap = 40.0;
const _leafMinRadius = 180.0;
const _leafTargetChord = 185.0;

class MindmapPage extends ConsumerStatefulWidget {
  const MindmapPage({super.key});

  @override
  ConsumerState<MindmapPage> createState() => _MindmapPageState();
}

class _MindmapPageState extends ConsumerState<MindmapPage> {
  final TransformationController _transformController = TransformationController();

  /// Center position of every currently-visible node, in canvas coordinates.
  /// Free-dragging a node just overwrites its entry here.
  final Map<String, Offset> _positions = {};
  final Set<String> _expandedUnitIds = {};

  bool _layoutInitialized = false;
  bool _canvasGesturesEnabled = true;
  Size _lastViewportSize = Size.zero;
  String? _layoutCourseId;

  Map<String, List<Subtopic>> _subtopicsByUnit = {};

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _ensureLayout(String courseId, List<Unit> units, List<Subtopic> subtopics) {
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
    final sortedUnits = [...units]..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final rightUnits = <Unit>[];
    final leftUnits = <Unit>[];
    for (var i = 0; i < sortedUnits.length; i++) {
      (i.isEven ? rightUnits : leftUnits).add(sortedUnits[i]);
    }

    placeSide(rightUnits, 1);
    placeSide(leftUnits, -1);

    WidgetsBinding.instance.addPostFrameCallback((_) => _centerView());
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

  /// Height of the vertical territory a unit needs to fit its own leaf fan
  /// (see [_ensureSubtopicPositions]), plus breathing room. Units are given
  /// this much room from the very first layout — whether or not they're
  /// expanded yet — so a topic with a long subtopic list already has a
  /// wide-enough gap to its neighbors before the user ever taps it, and its
  /// subtopics never have to encroach on a neighboring topic's space to
  /// avoid overlapping it.
  double _unitSlotHeight(Unit unit) {
    final count = _subtopicsByUnit[unit.id]?.length ?? 0;
    if (count == 0) return _minUnitSlotHeight;
    var maxAbsY = 0.0;
    for (final leaf in _leafLayout(count)) {
      final y = leaf.radius * math.sin(leaf.angleDeg * math.pi / 180);
      maxAbsY = math.max(maxAbsY, y.abs());
    }
    return math.max(_minUnitSlotHeight, 2 * maxAbsY + _subtopicNodeHeight + 30);
  }

  /// Stacks [side]'s units top-to-bottom, each centered in its own
  /// non-overlapping vertical slot (see [_unitSlotHeight]), separated by a
  /// fixed gap of guaranteed-empty canvas.
  void placeSide(List<Unit> side, double sign) {
    if (side.isEmpty) return;
    final slotHeights = [for (final unit in side) _unitSlotHeight(unit)];
    final totalHeight =
        slotHeights.fold<double>(0, (sum, h) => sum + h) + _unitSlotGap * (side.length - 1);
    var top = _canvasCenter.dy - totalHeight / 2;
    for (var i = 0; i < side.length; i++) {
      final centerY = top + slotHeights[i] / 2;
      _positions[side[i].id] = Offset(_canvasCenter.dx + sign * _unitOffsetX, centerY);
      top += slotHeights[i] + _unitSlotGap;
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

    // Every unit already owns enough vertical territory for this exact fan
    // (see _unitSlotHeight), so it can never reach into a neighboring
    // unit's space — subtopics stay right beside their own topic, spread
    // around it like leaves around a branch tip rather than stacked in a
    // column to one side.
    final leaves = _leafLayout(subtopics.length);
    for (var i = 0; i < subtopics.length; i++) {
      final subtopic = subtopics[i];
      if (_positions.containsKey(subtopic.id)) continue;
      final leaf = leaves[i];
      final angleRad = (outwardDeg + leaf.angleDeg) * math.pi / 180;
      _positions[subtopic.id] = unitPos +
          Offset(leaf.radius * math.cos(angleRad), leaf.radius * math.sin(angleRad));
    }
  }

  void _centerView() {
    if (_lastViewportSize == Size.zero) return;
    final root = _positions[_rootId];
    if (root == null) return;
    setState(() {
      _transformController.value = Matrix4.identity()
        ..translateByDouble(
          _lastViewportSize.width / 2 - root.dx,
          _lastViewportSize.height / 2 - root.dy,
          0,
          1,
        );
    });
  }

  void _moveNode(String nodeId, Offset delta) {
    final scale = _transformController.value.getMaxScaleOnAxis();
    setState(() {
      _positions[nodeId] = (_positions[nodeId] ?? Offset.zero) + delta / scale;
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
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesProvider);
    final unitsAsync = ref.watch(unitsProvider);
    final subtopicsAsync = ref.watch(subtopicsProvider);
    final user = ref.watch(currentUserProvider);
    final subtopicStatus = ref.watch(subtopicStatusProvider);

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
          IconButton(
            tooltip: 'Reset view',
            icon: const Icon(Icons.center_focus_strong),
            onPressed: _centerView,
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
          error: (error, _) => Center(child: Text('Failed to load curriculum: $error')),
          data: (_) => unitsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Failed to load curriculum: $error')),
          data: (_) => subtopicsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Failed to load curriculum: $error')),
            data: (_) {
              final course = ref.watch(selectedCourseProvider);
              if (course == null) {
                return const Center(child: Text('No courses configured yet.'));
              }
              final units = ref.watch(courseUnitsProvider);
              final subtopics = ref.watch(courseSubtopicsProvider);
              _ensureLayout(course.id, units, subtopics);
              return LayoutBuilder(
                builder: (context, constraints) {
                  final viewportSize = constraints.biggest;
                  if (viewportSize != _lastViewportSize) {
                    final wasZero = _lastViewportSize == Size.zero;
                    _lastViewportSize = viewportSize;
                    if (wasZero) {
                      WidgetsBinding.instance.addPostFrameCallback((_) => _centerView());
                    }
                  }
                  return InteractiveViewer(
                    transformationController: _transformController,
                    constrained: false,
                    // Disabled for the duration of any node-level pointer
                    // interaction (see _DraggableNode) so InteractiveViewer's
                    // own pan/scale recognizer never competes with — or
                    // nudges the canvas during — a tap or drag on a node.
                    panEnabled: _canvasGesturesEnabled,
                    scaleEnabled: _canvasGesturesEnabled,
                    minScale: 0.3,
                    maxScale: 2.2,
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
                          ..._buildNodes(course, units, subtopicStatus),
                        ],
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
          child: RootNodeWidget(label: 'Grade ${course.grade} Math'),
        ),
      );
    }

    for (final unit in units) {
      final unitPos = _positions[unit.id];
      if (unitPos == null) continue;

      final subtopicIds = (_subtopicsByUnit[unit.id] ?? const []).map((s) => s.id);
      final unitStatus = aggregateUnitStatus(subtopicIds, subtopicStatus);
      nodes.add(
        _DraggableNode(
          position: unitPos,
          onDragStart: () => setState(() => _canvasGesturesEnabled = false),
          onDragUpdate: (delta) => _moveNode(unit.id, delta),
          onDragEnd: () => setState(() => _canvasGesturesEnabled = true),
          onTap: () => _toggleUnit(unit),
          child: UnitNodeWidget(
            unit: unit,
            status: unitStatus,
            subtopicCount: (_subtopicsByUnit[unit.id] ?? const []).length,
            collapsed: !_expandedUnitIds.contains(unit.id),
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
            child: SubtopicNodeWidget(
              subtopic: subtopic,
              status: status,
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
      onSelected: (value) => ref.read(selectedCourseIdProvider.notifier).select(value),
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

    for (final unit in units) {
      final unitPos = positions[unit.id];
      if (unitPos == null) continue;
      final subtopicIds = (subtopicsByUnit[unit.id] ?? const []).map((s) => s.id);
      final unitStatus = aggregateUnitStatus(subtopicIds, subtopicStatus);
      _drawCurve(canvas, rootPos, unitPos, unitStatus.color, 4);

      if (!expandedUnitIds.contains(unit.id)) continue;
      for (final subtopic in subtopicsByUnit[unit.id] ?? const <Subtopic>[]) {
        final subPos = positions[subtopic.id];
        if (subPos == null) continue;
        final status = subtopicStatus[subtopic.id] ?? ProgressStatus.notStarted;
        _drawCurve(canvas, unitPos, subPos, status.color, 2.25);
      }
    }
  }

  void _drawCurve(Canvas canvas, Offset start, Offset end, Color color, double width) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    final midX = (start.dx + end.dx) / 2;
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(midX, start.dy, midX, end.dy, end.dx, end.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MindmapEdgePainter oldDelegate) => true;
}
