import 'package:flutter/material.dart';

/// The math-coordinate window a graph shows, e.g. x from -10 to 10.
class GraphRange {
  const GraphRange({
    required this.xMin,
    required this.xMax,
    required this.yMin,
    required this.yMax,
  });

  final double xMin;
  final double xMax;
  final double yMin;
  final double yMax;
}

/// Maps math coordinates to pixel coordinates within a [size]d canvas,
/// y-flipped so "up" in math is up on screen.
class GraphTransform {
  GraphTransform(this.size, this.range);

  final Size size;
  final GraphRange range;

  Offset toPixel(double x, double y) {
    final px = (x - range.xMin) / (range.xMax - range.xMin) * size.width;
    final py = size.height - (y - range.yMin) / (range.yMax - range.yMin) * size.height;
    return Offset(px, py);
  }
}

/// Draws integer-spaced gridlines, bold axes through the origin, and small
/// numeric labels — the common backdrop every graph in this package sits on.
void paintGraphGrid(
  Canvas canvas,
  Size size,
  GraphRange range,
  ColorScheme scheme,
) {
  final transform = GraphTransform(size, range);
  final gridPaint = Paint()
    ..color = scheme.onSurface.withValues(alpha: 0.1)
    ..strokeWidth = 1;
  final axisPaint = Paint()
    ..color = scheme.onSurface.withValues(alpha: 0.55)
    ..strokeWidth = 1.6;

  for (var x = range.xMin.ceil(); x <= range.xMax.floor(); x++) {
    final isAxis = x == 0;
    canvas.drawLine(
      transform.toPixel(x.toDouble(), range.yMin),
      transform.toPixel(x.toDouble(), range.yMax),
      isAxis ? axisPaint : gridPaint,
    );
  }
  for (var y = range.yMin.ceil(); y <= range.yMax.floor(); y++) {
    final isAxis = y == 0;
    canvas.drawLine(
      transform.toPixel(range.xMin, y.toDouble()),
      transform.toPixel(range.xMax, y.toDouble()),
      isAxis ? axisPaint : gridPaint,
    );
  }
}

/// A small filled dot with a white outline, used to mark a point of
/// interest (a vertex, an intersection) on top of a graph.
void paintMarker(Canvas canvas, Offset center, Color color) {
  canvas.drawCircle(center, 5.5, Paint()..color = Colors.white);
  canvas.drawCircle(center, 5.5, Paint()..color = color);
  canvas.drawCircle(
    center,
    5.5,
    Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5,
  );
}

/// Shared chrome for every interactive widget: a bordered card with an
/// "Interactive" eyebrow label, so it reads as something to play with
/// rather than another static figure in the lesson.
class InteractiveCard extends StatelessWidget {
  const InteractiveCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.touch_app_outlined, size: 16, color: scheme.primary),
              const SizedBox(width: 6),
              Text(
                'INTERACTIVE — DRAG TO EXPLORE',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
