import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
const _canvasSize = Size(3200, 3200);
const _canvasCenter = Offset(1600, 1600);

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

  Map<String, List<Subtopic>> _subtopicsByUnit = {};

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _ensureLayout(List<Unit> units, List<Subtopic> subtopics) {
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
    const unitOffsetX = 240.0;
    const unitSpacingY = 100.0;
    void placeSide(List<Unit> side, double sign) {
      final totalHeight = (side.length - 1) * unitSpacingY;
      final startY = _canvasCenter.dy - totalHeight / 2;
      for (var i = 0; i < side.length; i++) {
        _positions[side[i].id] =
            Offset(_canvasCenter.dx + sign * unitOffsetX, startY + i * unitSpacingY);
      }
    }

    placeSide(rightUnits, 1);
    placeSide(leftUnits, -1);

    WidgetsBinding.instance.addPostFrameCallback((_) => _centerView());
  }

  void _ensureSubtopicPositions(Unit unit) {
    final subtopics = _subtopicsByUnit[unit.id] ?? const [];
    final missing = subtopics.where((s) => !_positions.containsKey(s.id)).toList();
    if (missing.isEmpty) return;

    final unitPos = _positions[unit.id]!;
    final sideSign = unitPos.dx >= _canvasCenter.dx ? 1.0 : -1.0;
    const subOffsetX = 210.0;
    const subSpacingY = 48.0;
    final totalHeight = (subtopics.length - 1) * subSpacingY;
    final startY = unitPos.dy - totalHeight / 2;
    for (var i = 0; i < subtopics.length; i++) {
      final subtopic = subtopics[i];
      if (_positions.containsKey(subtopic.id)) continue;
      _positions[subtopic.id] =
          Offset(unitPos.dx + sideSign * subOffsetX, startY + i * subSpacingY);
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
    final unitsAsync = ref.watch(unitsProvider);
    final subtopicsAsync = ref.watch(subtopicsProvider);
    final user = ref.watch(currentUserProvider);
    final subtopicStatus = ref.watch(subtopicStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade 10 Math Mindmap'),
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
        child: unitsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Failed to load curriculum: $error')),
          data: (units) => subtopicsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Failed to load curriculum: $error')),
            data: (subtopics) {
              _ensureLayout(units, subtopics);
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
                          ..._buildNodes(units, subtopicStatus),
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
    );
  }

  List<Widget> _buildNodes(List<Unit> units, Map<String, ProgressStatus> subtopicStatus) {
    final nodes = <Widget>[];

    final rootPos = _positions[_rootId];
    if (rootPos != null) {
      nodes.add(
        _DraggableNode(
          position: rootPos,
          onDragStart: () => setState(() => _canvasGesturesEnabled = false),
          onDragUpdate: (delta) => _moveNode(_rootId, delta),
          onDragEnd: () => setState(() => _canvasGesturesEnabled = true),
          child: const RootNodeWidget(),
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
            onTap: () =>
                showTopicDetailSheet(context, subtopic: subtopic, color: status.color),
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
