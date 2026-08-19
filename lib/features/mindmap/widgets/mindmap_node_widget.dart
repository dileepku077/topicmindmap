import 'package:flutter/material.dart';

import '../../../models/progress_status.dart';
import '../../../models/subtopic.dart';
import '../../../models/unit.dart';

class RootNodeWidget extends StatelessWidget {
  const RootNodeWidget({super.key, required this.label});

  final String label;

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
        label,
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
/// Every color on this box — fill, border, badge, connecting lines — comes
/// from a single traffic-signal palette (grey/orange/yellow/light-green/
/// green) driven by the aggregated practice-test status of every subtopic
/// underneath it. Deliberately not tinted by the unit's own identity color
/// anymore: one color channel, not two, keeps "how am I doing on this"
/// unambiguous at a glance.
class UnitNodeWidget extends StatelessWidget {
  const UnitNodeWidget({
    super.key,
    required this.unit,
    required this.status,
    required this.subtopicCount,
    required this.collapsed,
    required this.sequenceNumber,
    this.scorePercent,
  });

  final Unit unit;
  final ProgressStatus status;
  final int subtopicCount;
  final bool collapsed;

  /// This unit's 1-based position in the course's recommended learning
  /// order (i.e. `unit.orderIndex + 1`) — shown as a small badge so a
  /// student can tell at a glance which unit to tackle first.
  final int sequenceNumber;

  /// Average best-score percent across this unit's subtopics, or null if
  /// none have been attempted yet (nothing worth showing).
  final double? scorePercent;

  @override
  Widget build(BuildContext context) {
    final borderColor = Color.lerp(status.color, Colors.black, 0.25)!;
    return Container(
      constraints: const BoxConstraints(maxWidth: 185),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: status.color.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SequenceBadge(number: sequenceNumber, color: status.color),
          const SizedBox(width: 6),
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
          if (scorePercent != null) ...[
            const SizedBox(width: 6),
            Text(
              '${scorePercent!.round()}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ],
          const SizedBox(width: 6),
          _CountBadge(count: subtopicCount, color: status.color),
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

/// A small "N of the course/unit" pill, in the same visual language as
/// [_CountBadge] (white pill, colored digits) but always shown first so a
/// student scanning left-to-right sees the recommended order before
/// anything else.
class _SequenceBadge extends StatelessWidget {
  const _SequenceBadge({required this.number, required this.color});

  final int number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$number',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 10,
        ),
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

/// A subtopic node, revealed once its parent unit is expanded. Border and
/// status icon reflect this subtopic's own best practice-test score, on a
/// plain (untinted) background — the traffic-signal color is the only
/// color story here too.
class SubtopicNodeWidget extends StatelessWidget {
  const SubtopicNodeWidget({
    super.key,
    required this.subtopic,
    required this.status,
    required this.sequenceNumber,
    this.scorePercent,
  });

  final Subtopic subtopic;
  final ProgressStatus status;

  /// This subtopic's 1-based position within its unit (i.e.
  /// `subtopic.orderIndex + 1`) — the recommended order to learn the
  /// unit's subtopics in, shown as a plain small number since these
  /// nodes are already tight on space.
  final int sequenceNumber;

  /// This subtopic's best practice-test score percent, or null if it
  /// hasn't been attempted yet (nothing worth showing).
  final double? scorePercent;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 140),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
          Text(
            '$sequenceNumber',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(width: 4),
          Icon(status.icon, color: status.color, size: 13),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              subtopic.title,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ),
          if (scorePercent != null) ...[
            const SizedBox(width: 5),
            Text(
              '${scorePercent!.round()}%',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: status.color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
