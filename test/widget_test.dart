import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:astro_math/features/mindmap/widgets/mindmap_node_widget.dart';
import 'package:astro_math/models/progress_status.dart';
import 'package:astro_math/models/subtopic.dart';

void main() {
  testWidgets('RootNodeWidget shows the given label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: RootNodeWidget(label: 'Grade 10 Math'))),
    );

    expect(find.text('Grade 10 Math'), findsOneWidget);
  });

  testWidgets('SubtopicNodeWidget shows the subtopic title', (tester) async {
    const subtopic = Subtopic(
      id: 's1',
      unitId: 'u1',
      code: 'solving-by-substitution',
      title: 'Solving by Substitution',
      orderIndex: 0,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SubtopicNodeWidget(
            subtopic: subtopic,
            status: ProgressStatus.notStarted,
            sequenceNumber: 1,
          ),
        ),
      ),
    );

    expect(find.text('Solving by Substitution'), findsOneWidget);
  });
}
