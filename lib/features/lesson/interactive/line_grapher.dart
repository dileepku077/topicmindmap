import 'package:flutter/material.dart';

import 'graph_canvas.dart';

/// Drag the slope and y-intercept and watch `y = mx + b` — and its rise/run
/// triangle — update live.
class LineGrapher extends StatefulWidget {
  const LineGrapher({super.key});

  @override
  State<LineGrapher> createState() => _LineGrapherState();
}

class _LineGrapherState extends State<LineGrapher> {
  double _m = 1;
  double _b = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InteractiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'y = ${_m.toStringAsFixed(1)}x ${_b >= 0 ? '+' : '−'} ${_b.abs().toStringAsFixed(1)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'slope = ${_m.toStringAsFixed(1)}, y-intercept = (0, ${_b.toStringAsFixed(1)})',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.3,
            child: CustomPaint(
              painter: _LinePainter(m: _m, b: _b, scheme: scheme),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 4),
          _SliderRow(
            label: 'm',
            value: _m,
            min: -5,
            max: 5,
            divisions: 40,
            onChanged: (v) => setState(() => _m = v),
          ),
          _SliderRow(
            label: 'b',
            value: _b,
            min: -8,
            max: 8,
            divisions: 32,
            onChanged: (v) => setState(() => _b = v),
          ),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({required this.m, required this.b, required this.scheme});

  final double m;
  final double b;
  final ColorScheme scheme;

  static const _range = GraphRange(xMin: -8, xMax: 8, yMin: -8, yMax: 8);

  @override
  void paint(Canvas canvas, Size size) {
    paintGraphGrid(canvas, size, _range, scheme);
    final transform = GraphTransform(size, _range);

    final start = transform.toPixel(_range.xMin, m * _range.xMin + b);
    final end = transform.toPixel(_range.xMax, m * _range.xMax + b);
    canvas.drawLine(
      start,
      end,
      Paint()
        ..color = scheme.primary
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // Rise/run triangle anchored at the y-intercept, one unit of run wide
    // (scaled up if the line is steep, so it stays visible).
    final run = m.abs() > 3 ? 2.0 : 3.0;
    final p0 = transform.toPixel(0, b);
    final p1 = transform.toPixel(run, b);
    final p2 = transform.toPixel(run, b + m * run);
    if (m != 0) {
      final trianglePaint = Paint()
        ..color = scheme.secondary.withValues(alpha: 0.6)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(p0, p1, trianglePaint);
      canvas.drawLine(p1, p2, trianglePaint);
      final rise = m * run;
      _drawLabel(canvas, 'run ${run.toStringAsFixed(0)}', Offset((p0.dx + p1.dx) / 2, p1.dy + 4), scheme);
      _drawLabel(
        canvas,
        'rise ${rise.toStringAsFixed(1)}',
        Offset(p1.dx + 4, (p1.dy + p2.dy) / 2),
        scheme,
      );
    }

    paintMarker(canvas, transform.toPixel(0, b), scheme.primary);
  }

  void _drawLabel(Canvas canvas, String text, Offset at, ColorScheme scheme) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: scheme.secondary, fontSize: 11, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, at);
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) =>
      oldDelegate.m != m || oldDelegate.b != b;
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
          child: Text(value.toStringAsFixed(1), textAlign: TextAlign.end),
        ),
      ],
    );
  }
}
