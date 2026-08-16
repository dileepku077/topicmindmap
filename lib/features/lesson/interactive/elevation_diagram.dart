import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'graph_canvas.dart';

/// Drag the angle of elevation and the observer's distance from the tower
/// and watch the height — `height = distance × tan(angle)` — update live.
class ElevationDiagram extends StatefulWidget {
  const ElevationDiagram({super.key});

  @override
  State<ElevationDiagram> createState() => _ElevationDiagramState();
}

class _ElevationDiagramState extends State<ElevationDiagram> {
  double _angleDeg = 35;
  double _distance = 50;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final height = _distance * math.tan(_angleDeg * math.pi / 180);

    return InteractiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'tan(${_angleDeg.toStringAsFixed(0)}°) = height / ${_distance.toStringAsFixed(0)} m'
            '  →  height ≈ ${height.toStringAsFixed(1)} m',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.5,
            child: CustomPaint(
              painter: _ElevationPainter(
                angleDeg: _angleDeg,
                distance: _distance,
                height: height,
                scheme: scheme,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const SizedBox(width: 56, child: Text('angle')),
              Expanded(
                child: Slider(
                  value: _angleDeg,
                  min: 10,
                  max: 75,
                  divisions: 65,
                  label: '${_angleDeg.toStringAsFixed(0)}°',
                  onChanged: (v) => setState(() => _angleDeg = v),
                ),
              ),
              SizedBox(width: 40, child: Text('${_angleDeg.toStringAsFixed(0)}°', textAlign: TextAlign.end)),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 56, child: Text('distance')),
              Expanded(
                child: Slider(
                  value: _distance,
                  min: 20,
                  max: 80,
                  divisions: 60,
                  label: '${_distance.toStringAsFixed(0)} m',
                  onChanged: (v) => setState(() => _distance = v),
                ),
              ),
              SizedBox(width: 40, child: Text('${_distance.toStringAsFixed(0)}m', textAlign: TextAlign.end)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ElevationPainter extends CustomPainter {
  _ElevationPainter({
    required this.angleDeg,
    required this.distance,
    required this.height,
    required this.scheme,
  });

  final double angleDeg;
  final double distance;
  final double height;
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    const marginLeft = 24.0;
    const marginRight = 24.0;
    const marginTop = 20.0;
    const marginBottom = 32.0;

    final plotWidth = size.width - marginLeft - marginRight;
    final plotHeight = size.height - marginTop - marginBottom;
    final groundY = size.height - marginBottom;
    final observer = Offset(marginLeft, groundY);
    final towerX = marginLeft + plotWidth * 0.82;

    // Auto-scale so the tower always fills most of the plot height, and the
    // horizontal distance always fills most of the plot width.
    final scaleY = (plotHeight * 0.85) / (height <= 0 ? 1 : height);
    final towerTop = Offset(towerX, groundY - height * scaleY);

    final groundPaint = Paint()
      ..color = scheme.onSurface.withValues(alpha: 0.6)
      ..strokeWidth = 2;
    final horizonPaint = Paint()
      ..color = scheme.onSurface.withValues(alpha: 0.35)
      ..strokeWidth = 1.5;
    final sightPaint = Paint()
      ..color = scheme.primary
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final towerPaint = Paint()
      ..color = scheme.secondary
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Ground.
    canvas.drawLine(Offset(marginLeft, groundY), Offset(size.width - marginRight, groundY), groundPaint);
    // Horizontal line of reference from the observer (dashed) — the line
    // both the angle of elevation and the line of sight are measured from.
    _drawDashedLine(canvas, observer, Offset(size.width - marginRight, observer.dy), horizonPaint);
    // Tower.
    canvas.drawLine(Offset(towerX, groundY), towerTop, towerPaint);
    // Line of sight.
    canvas.drawLine(observer, towerTop, sightPaint);

    // Angle arc at the observer.
    final sightAngle = math.atan2(observer.dy - towerTop.dy, towerTop.dx - observer.dx);
    canvas.drawArc(
      Rect.fromCircle(center: observer, radius: 28),
      -sightAngle,
      sightAngle,
      false,
      Paint()
        ..color = scheme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    paintMarker(canvas, observer, scheme.primary);
    paintMarker(canvas, towerTop, scheme.secondary);

    _label(canvas, '${angleDeg.toStringAsFixed(0)}°', observer + const Offset(34, -8), scheme.primary);
    _label(canvas, 'observer', observer + const Offset(-4, 8), scheme.onSurfaceVariant, small: true);
    _label(
      canvas,
      '${height.toStringAsFixed(1)} m',
      Offset(towerX + 6, (towerTop.dy + groundY) / 2),
      scheme.secondary,
    );
    _label(canvas, '${distance.toStringAsFixed(0)} m', Offset((observer.dx + towerX) / 2 - 16, groundY + 14), scheme.onSurfaceVariant);
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashLength = 5.0;
    final total = (end - start).distance;
    if (total == 0) return;
    final direction = (end - start) / total;
    var covered = 0.0;
    while (covered < total) {
      final segStart = start + direction * covered;
      final segEnd = start + direction * math.min(covered + dashLength, total);
      canvas.drawLine(segStart, segEnd, paint);
      covered += dashLength * 2;
    }
  }

  void _label(Canvas canvas, String text, Offset at, Color color, {bool small = false}) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: small ? 10 : 12, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, at);
  }

  @override
  bool shouldRepaint(covariant _ElevationPainter oldDelegate) =>
      oldDelegate.angleDeg != angleDeg || oldDelegate.distance != distance;
}
