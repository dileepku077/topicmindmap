import 'package:flutter/material.dart';

import '../../../models/progress_status.dart';
import '../../../models/subtopic.dart';
import '../../../models/unit.dart';

class RootNodeWidget extends StatelessWidget {
  const RootNodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.45),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        'Grade 10 Math',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: scheme.onPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
      ),
    );
  }
}

/// A unit ("branch") node — one of the high-level groups shown up front.
/// Its fill color is the aggregated practice-test status of every subtopic
/// underneath it: green once the whole unit is mastered, yellow/red while
/// still developing or needing practice, grey until attempted. [unit.color]
/// — the same hue used for this branch's connection lines — survives as a
/// border so the box still reads as "part of this branch" at a glance.
class UnitNodeWidget extends StatelessWidget {
  const UnitNodeWidget({
    super.key,
    required this.unit,
    required this.status,
    required this.subtopicCount,
    required this.collapsed,
  });

  final Unit unit;
  final ProgressStatus status;
  final int subtopicCount;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 160),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: unit.color, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: unit.color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              unit.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 6),
          _CountBadge(count: subtopicCount, color: unit.color),
          const SizedBox(width: 3),
          Icon(
            collapsed ? Icons.chevron_right : Icons.expand_more,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.color});

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 10,
        ),
      ),
    );
  }
}

/// A subtopic node, revealed once its parent unit is expanded. The border
/// and status icon reflect this subtopic's own best practice-test score;
/// [branchColor] (the parent unit's color) tints the background faintly so
/// it still visually belongs to its branch even though the connecting line
/// itself carries that color.
class SubtopicNodeWidget extends StatelessWidget {
  const SubtopicNodeWidget({
    super.key,
    required this.subtopic,
    required this.status,
    required this.branchColor,
  });

  final Subtopic subtopic;
  final ProgressStatus status;
  final Color branchColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 140),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          branchColor.withValues(alpha: 0.06),
          Theme.of(context).colorScheme.surface,
        ),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: status.color, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, color: status.color, size: 13),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              subtopic.title,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
