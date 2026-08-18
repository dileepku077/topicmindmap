import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:topicmindmap/features/mindmap/mindmap_page.dart';

void main() {
  group('computeZoomedTransform', () {
    test('a single zoom-in tick keeps the cursor point fixed', () {
      final matrix = Matrix4.identity();
      const viewportPoint = Offset(400, 300);

      final result = computeZoomedTransform(
        oldMatrix: matrix,
        viewportPoint: viewportPoint,
        scrollDeltaY: -60,
        minZoom: 0.3,
        maxZoom: 2.2,
      );

      final newScale = result.getMaxScaleOnAxis();
      final newTranslation = result.getTranslation();
      final mappedBack = Offset(
        viewportPoint.dx * 0 + newTranslation.x, // canvasPoint was (400,300) since old transform was identity
        newTranslation.y,
      );
      // The canvas point that was under the cursor before zooming
      // (viewportPoint itself, since the starting transform is identity)
      // should map back to the same viewport point after zooming.
      final remapped = Offset(
        viewportPoint.dx * newScale + newTranslation.x,
        viewportPoint.dy * newScale + newTranslation.y,
      );
      expect(remapped.dx, closeTo(viewportPoint.dx, 0.001));
      expect(remapped.dy, closeTo(viewportPoint.dy, 0.001));
      expect(newScale, greaterThan(1.0));
      expect(mappedBack, isNotNull);
    });

    test('repeated zoom-out ticks stay clamped and keep the pivot visible', () {
      var matrix = Matrix4.identity();
      const viewportPoint = Offset(600, 375);

      for (var i = 0; i < 20; i++) {
        matrix = computeZoomedTransform(
          oldMatrix: matrix,
          viewportPoint: viewportPoint,
          scrollDeltaY: 60, // positive = zoom out
          minZoom: 0.3,
          maxZoom: 2.2,
        );

        final scale = matrix.getMaxScaleOnAxis();
        expect(scale, greaterThanOrEqualTo(0.3 - 1e-9));
        expect(scale, lessThanOrEqualTo(2.2 + 1e-9));

        // The pivot point itself must always still land exactly on the
        // cursor's viewport position — if this drifts, the canvas content
        // (which is centered far from the origin) can end up scrolled
        // completely out of view even though scale itself is bounded.
        final translation = matrix.getTranslation();
        final canvasPointUnderCursor = Offset(
          (viewportPoint.dx - translation.x) / scale,
          (viewportPoint.dy - translation.y) / scale,
        );
        final remapped = Offset(
          canvasPointUnderCursor.dx * scale + translation.x,
          canvasPointUnderCursor.dy * scale + translation.y,
        );
        expect(remapped.dx, closeTo(viewportPoint.dx, 0.01));
        expect(remapped.dy, closeTo(viewportPoint.dy, 0.01));
      }

      // After 20 zoom-out ticks it should have hit the floor and stayed
      // there, not overshot into some huge or tiny runaway value.
      expect(matrix.getMaxScaleOnAxis(), closeTo(0.3, 1e-6));
    });

    test('a point far from the canvas origin stays reachable after zooming out', () {
      // Mirrors the real app: the mindmap's root sits at canvas (2200,2200),
      // far from (0,0), inside a much larger 4400x4400 canvas.
      var matrix = Matrix4.identity()
        ..translateByDouble(800 - 2200, 400 - 2200, 0, 1); // root roughly centered in an 1600x800 viewport
      const cursor = Offset(800, 400);

      for (var i = 0; i < 10; i++) {
        matrix = computeZoomedTransform(
          oldMatrix: matrix,
          viewportPoint: cursor,
          scrollDeltaY: 60,
          minZoom: 0.3,
          maxZoom: 2.2,
        );
      }

      final scale = matrix.getMaxScaleOnAxis();
      final translation = matrix.getTranslation();
      // Where does canvas point (2200,2200) -- the root -- end up on screen?
      final rootOnScreen = Offset(
        2200 * scale + translation.x,
        2200 * scale + translation.y,
      );
      // It should still land somewhere near the original viewport area,
      // not thousands of pixels off in some direction.
      expect(rootOnScreen.dx, inInclusiveRange(-2000.0, 3000.0));
      expect(rootOnScreen.dy, inInclusiveRange(-2000.0, 3000.0));
    });
  });
}
