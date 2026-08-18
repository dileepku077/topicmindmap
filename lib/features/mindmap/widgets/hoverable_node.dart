import 'package:flutter/material.dart';

/// Wraps a topic/subtopic box with mouse-hover feedback: a subtle glow (and,
/// for spatial nodes, a slight pop) plus a small tooltip explaining where
/// the student stands on it.
///
/// The glow/pop is driven by a plain `MouseRegion` — no `GestureDetector`
/// involved — so it never competes with a sibling or ancestor's own raw
/// pointer/drag handling (see `_DraggableNode` in mindmap_page.dart, which
/// relies on exactly that). The message itself rides on Flutter's own
/// `Tooltip`, which already solves overlay positioning (including staying
/// on-screen when the node sits near an edge) far more robustly than a
/// hand-rolled one would.
class HoverableNode extends StatefulWidget {
  const HoverableNode({
    super.key,
    required this.child,
    required this.message,
    required this.highlightColor,
    this.pop = true,
  });

  final Widget child;
  final String message;
  final Color highlightColor;

  /// Whether hovering also scales the node up slightly. Suits nodes free-
  /// floating on the mindmap canvas; a plain list row reads better without it.
  final bool pop;

  @override
  State<HoverableNode> createState() => _HoverableNodeState();
}

class _HoverableNodeState extends State<HoverableNode> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Tooltip(
        message: widget.message,
        waitDuration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2430),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: widget.highlightColor, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12.5,
          height: 1.3,
        ),
        child: AnimatedScale(
          scale: _hovering && widget.pop ? 1.06 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: _hovering
                  ? [
                      BoxShadow(
                        color: widget.highlightColor.withValues(alpha: 0.55),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ]
                  : const [],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
