import 'package:flutter/material.dart';

import 'graph_canvas.dart';

/// Line 1 is fixed. Drag line 2's slope and intercept and watch which of
/// the three "number of solutions" cases you land in.
class LinearSystemVisualizer extends StatefulWidget {
  const LinearSystemVisualizer({super.key});

  @override
  State<LinearSystemVisualizer> createState() => _LinearSystemVisualizerState();
}

class _LinearSystemVisualizerState extends State<LinearSystemVisualizer> {
  static const _m1 = 1.0;
  static const _b1 = 1.0;

  double _m2 = -1;
  double _b2 = 4;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sameSlope = (_m2 - _m1).abs() < 0.001;
    final sameLine = sameSlope && (_b2 - _b1).abs() < 0.001;

    final String statusText;
    final Color statusColor;
    if (sameLine) {
      statusText = 'Infinitely many solutions — same line';
      statusColor = const Color(0xFFD9A404);
    } else if (sameSlope) {
      statusText = 'No solution — parallel lines';
      statusColor = const Color(0xFFE8590C);
    } else {
      final x = (_b1 - _b2) / (_m2 - _m1);
      final y = _m1 * x + _b1;
      statusText = 'One solution at (${x.toStringAsFixed(1)}, ${y.toStringAsFixed(1)})';
      statusColor = const Color(0xFF2E7D32);
    }

    return InteractiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Line 1 (fixed): y = x + 1',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: scheme.primary, fontWeight: FontWeight.w600),
          ),
          Text(
            'Line 2: y = ${_m2.toStringAsFixed(1)}x ${_b2 >= 0 ? '+' : '−'} ${_b2.abs().toStringAsFixed(1)}',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: scheme.secondary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.3,
            child: CustomPaint(
              painter: _SystemPainter(m1: _m1, b1: _b1, m2: _m2, b2: _b2, scheme: scheme),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              SizedBox(width: 16, child: Text('m', style: Theme.of(context).textTheme.labelLarge)),
              Expanded(
                child: Slider(
                  value: _m2,
                  min: -5,
                  max: 5,
                  divisions: 40,
                  label: _m2.toStringAsFixed(1),
                  onChanged: (v) => setState(() => _m2 = v),
                ),
              ),
              SizedBox(width: 36, child: Text(_m2.toStringAsFixed(1), textAlign: TextAlign.end)),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 16, child: Text('b', style: Theme.of(context).textTheme.labelLarge)),
              Expanded(
                child: Slider(
                  value: _b2,
                  min: -8,
                  max: 8,
                  divisions: 32,
                  label: _b2.toStringAsFixed(1),
                  onChanged: (v) => setState(() => _b2 = v),
                ),
              ),
              SizedBox(width: 36, child: Text(_b2.toStringAsFixed(1), textAlign: TextAlign.end)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withValues(alpha: 0.4)),
            ),
            child: Text(
              statusText,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemPainter extends CustomPainter {
  _SystemPainter({
    required this.m1,
    required this.b1,
    required this.m2,
    required this.b2,
    required this.scheme,
  });

  final double m1;
  final double b1;
  final double m2;
  final double b2;
  final ColorScheme scheme;

  static const _range = GraphRange(xMin: -8, xMax: 8, yMin: -8, yMax: 8);

  @override
  void paint(Canvas canvas, Size size) {
    paintGraphGrid(canvas, size, _range, scheme);
    final transform = GraphTransform(size, _range);

    void drawLine(double m, double b, Color color) {
      canvas.drawLine(
        transform.toPixel(_range.xMin, m * _range.xMin + b),
        transform.toPixel(_range.xMax, m * _range.xMax + b),
        Paint()
          ..color = color
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    }

    drawLine(m1, b1, scheme.primary);
    drawLine(m2, b2, scheme.secondary);

    if ((m2 - m1).abs() >= 0.001) {
      final x = (b1 - b2) / (m2 - m1);
      final y = m1 * x + b1;
      if (x >= _range.xMin && x <= _range.xMax && y >= _range.yMin && y <= _range.yMax) {
        paintMarker(canvas, transform.toPixel(x, y), const Color(0xFF2E7D32));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SystemPainter oldDelegate) =>
      oldDelegate.m2 != m2 || oldDelegate.b2 != b2;
}
