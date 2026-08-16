import 'package:flutter/material.dart';

import 'graph_canvas.dart';

/// Drag `a`, `h`, and `k` and watch `y = a(x - h)² + k` move and reshape
/// live — makes vertex form concrete instead of abstract.
class ParabolaGrapher extends StatefulWidget {
  const ParabolaGrapher({super.key});

  @override
  State<ParabolaGrapher> createState() => _ParabolaGrapherState();
}

class _ParabolaGrapherState extends State<ParabolaGrapher> {
  double _a = 1;
  double _h = 0;
  double _k = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InteractiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'y = ${_a.toStringAsFixed(1)}(x − ${_h.toStringAsFixed(1)})² + ${_k.toStringAsFixed(1)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
          Text(
            'Vertex: (${_h.toStringAsFixed(1)}, ${_k.toStringAsFixed(1)})',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.3,
            child: CustomPaint(
              painter: _ParabolaPainter(a: _a, h: _h, k: _k, scheme: scheme),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 4),
          _SliderRow(
            label: 'a',
            value: _a,
            min: -3,
            max: 3,
            divisions: 24,
            onChanged: (v) => setState(() => _a = v),
          ),
          _SliderRow(
            label: 'h',
            value: _h,
            min: -5,
            max: 5,
            divisions: 20,
            onChanged: (v) => setState(() => _h = v),
          ),
          _SliderRow(
            label: 'k',
            value: _k,
            min: -5,
            max: 5,
            divisions: 20,
            onChanged: (v) => setState(() => _k = v),
          ),
        ],
      ),
    );
  }
}

class _ParabolaPainter extends CustomPainter {
  _ParabolaPainter({required this.a, required this.h, required this.k, required this.scheme});

  final double a;
  final double h;
  final double k;
  final ColorScheme scheme;

  static const _range = GraphRange(xMin: -8, xMax: 8, yMin: -8, yMax: 8);

  @override
  void paint(Canvas canvas, Size size) {
    paintGraphGrid(canvas, size, _range, scheme);
    final transform = GraphTransform(size, _range);

    final path = Path();
    var started = false;
    for (var px = 0.0; px <= size.width; px += 2) {
      final x = _range.xMin + px / size.width * (_range.xMax - _range.xMin);
      final y = a * (x - h) * (x - h) + k;
      if (y < _range.yMin - 4 || y > _range.yMax + 4) {
        started = false;
        continue;
      }
      final point = transform.toPixel(x, y);
      if (!started) {
        path.moveTo(point.dx, point.dy);
        started = true;
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = scheme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    paintMarker(canvas, transform.toPixel(h, k), scheme.primary);
  }

  @override
  bool shouldRepaint(covariant _ParabolaPainter oldDelegate) =>
      oldDelegate.a != a || oldDelegate.h != h || oldDelegate.k != k;
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 16, child: Text(label, style: Theme.of(context).textTheme.labelLarge)),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: value.toStringAsFixed(1),
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            value.toStringAsFixed(1),
            textAlign: TextAlign.end,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
          ),
        ),
      ],
    );
  }
}
