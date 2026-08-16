import 'package:flutter/widgets.dart';

import 'elevation_diagram.dart';
import 'line_grapher.dart';
import 'linear_system_visualizer.dart';
import 'parabola_grapher.dart';

/// Looks up the hands-on widget for a lesson's `interactiveWidgetId`, or
/// null if it doesn't have one (most lessons don't).
Widget? buildInteractiveWidget(String? id) {
  return switch (id) {
    'parabola_grapher' => const ParabolaGrapher(),
    'line_grapher' => const LineGrapher(),
    'linear_system_visualizer' => const LinearSystemVisualizer(),
    'elevation_diagram' => const ElevationDiagram(),
    _ => null,
  };
}
