import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:astro_math/features/mindmap/widgets/hoverable_node.dart';

void main() {
  testWidgets('shows a tooltip bubble with the given message on hover', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: HoverableNode(
              message: 'Nearly there on this topic — a bit more practice.',
              highlightColor: Colors.green,
              child: Container(width: 120, height: 40, color: Colors.blue),
            ),
          ),
        ),
      ),
    );

    // Not hovering yet: no tooltip text in the tree.
    expect(
      find.text('Nearly there on this topic — a bit more practice.'),
      findsNothing,
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();

    // Move the mouse onto the node and wait out the tooltip's hover delay.
    await gesture.moveTo(tester.getCenter(find.byType(HoverableNode)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.text('Nearly there on this topic — a bit more practice.'),
      findsOneWidget,
    );

    // Move the mouse away: the tooltip should disappear again.
    await gesture.moveTo(const Offset(5, 5));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.text('Nearly there on this topic — a bit more practice.'),
      findsNothing,
    );
  });
}
