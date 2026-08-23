import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:astro_math/features/mindmap/widgets/mindmap_node_widget.dart';
import 'package:astro_math/models/progress_status.dart';
import 'package:astro_math/models/subtopic.dart';
import 'package:astro_math/models/unit.dart';

void main() {
  testWidgets('SubtopicNodeWidget shows its 1-based sequence number', (
    tester,
  ) async {
    const subtopic = Subtopic(
      id: 's1',
      unitId: 'u1',
      code: 'solving-by-substitution',
      title: 'Solving by Substitution',
      orderIndex: 4, // 0-based -> should display as 5
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SubtopicNodeWidget(
            subtopic: subtopic,
            status: ProgressStatus.notStarted,
            sequenceNumber: 5,
          ),
        ),
      ),
    );

    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('UnitNodeWidget shows its 1-based sequence number', (
    tester,
  ) async {
    final unit = Unit(
      id: 'u1',
      courseId: 'c1',
      code: 'chemical-reactions',
      title: 'Chemistry: Chemical Reactions',
      color: const Color(0xFF8E5BC9),
      orderIndex: 1, // 0-based -> should display as 2
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UnitNodeWidget(
            unit: unit,
            status: ProgressStatus.notStarted,
            subtopicCount: 9,
            collapsed: true,
            sequenceNumber: 2,
          ),
        ),
      ),
    );

    expect(find.text('2'), findsOneWidget);
  });
}
