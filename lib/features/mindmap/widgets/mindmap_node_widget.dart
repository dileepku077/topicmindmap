import 'package:flutter/material.dart';

import '../../../models/progress_status.dart';
import '../../../models/subtopic.dart';
import '../../../models/subtopic_mastery.dart';
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
/// The shell (fill, border, shadow) is the same neutral surface on every
/// node regardless of status — status reads through exactly one accent,
/// the leading icon, the same split the classroom sidebar's own
/// `_UnitNavRow` already uses (a small colored icon on an otherwise
/// neutral row). A fully-populated mindmap layers medal trophies and
/// difficulty colors on the same canvas already; a solid traffic-signal
/// fill on every node on top of that read as noise rather than signal, so
/// this is the one deliberately loud color removed rather than added to.
///
/// This used to also carry a sequence-number badge ("this is unit 3") and
/// a subtopic-count badge — six visual elements crammed into ~11-14px
/// text. Both were the weakest-value items on the node (a student rarely
/// needs "3rd of 4" at a glance) and neither is gone, just relocated: both
/// now live in the hover tooltip text built alongside this widget in
/// mindmap_page.dart's `_buildNodes`, freeing the width this spends on a
/// title and score percent a size up from before instead.
class UnitNodeWidget extends StatelessWidget {
  const UnitNodeWidget({
    super.key,
    required this.unit,
    required this.status,
    required this.collapsed,
    this.scorePercent,
    this.medal,
  });

  final Unit unit;
  final ProgressStatus status;
  final bool collapsed;

  /// Average best-score percent across this unit's subtopics, or null if
  /// none have been attempted yet (nothing worth showing).
  final double? scorePercent;

  /// The worst medal among this unit's attempted subtopics — see
  /// `aggregateUnitMedal` in progress_providers.dart — or null if nothing
  /// in the unit has been attempted yet.
  final String? medal;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      // Wide enough that even this course set's single longest unit-title
      // word ("Trigonometric", ~91px at this font) always fits within the
      // title's share of the row, alongside the score%, without ever
      // needing a mid-word break — see the width math worked out against
      // real canvas text measurements while fixing the "Systems"
      // word-split bug this replaced.
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, color: status.color, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              unit.title,
              style: TextStyle(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 14.5,
              ),
            ),
          ),
          if (scorePercent != null) ...[
            const SizedBox(width: 8),
            Text(
              '${scorePercent!.round()}%',
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
          if (medal != null && medal != 'None') ...[
            const SizedBox(width: 6),
            MedalBadge(medal: medal, size: 16),
          ],
          const SizedBox(width: 6),
          Icon(
            collapsed ? Icons.chevron_right : Icons.expand_more,
            color: scheme.onSurfaceVariant,
            size: 18,
          ),
        ],
      ),
    );
  }
}

/// A subtopic node, revealed once its parent unit is expanded. Same neutral
/// shell as [UnitNodeWidget] and the same one-accent rule: the leading icon
/// is the only place status color shows up, border and score text are
/// neutral like everything else.
///
/// Used to lead with a plain sequence number ("this is the 2nd topic in
/// its unit") — the same decluttering as [UnitNodeWidget]: that number
/// wasn't worth the space it took from the title, so it moved to the
/// hover tooltip built in mindmap_page.dart's `_buildNodes` instead.
class SubtopicNodeWidget extends StatelessWidget {
  const SubtopicNodeWidget({
    super.key,
    required this.subtopic,
    required this.status,
    this.scorePercent,
    this.medal,
  });

  final Subtopic subtopic;
  final ProgressStatus status;

  /// This subtopic's best practice-test score percent, or null if it
  /// hasn't been attempted yet (nothing worth showing).
  final double? scorePercent;

  /// This subtopic's best-earned medal ('None' · 'Bronze' · 'Silver' ·
  /// 'Gold'), or null if it hasn't been attempted yet.
  final String? medal;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      // Wide enough that even the single longest subtopic-title word
      // across every course ("Electromagnetism", ~97px at this font)
      // always fits within the title's share of the row without a
      // mid-word break — see mindmap_node_widget's UnitNodeWidget for
      // the same reasoning.
      constraints: const BoxConstraints(maxWidth: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: scheme.outlineVariant, width: 1.5),
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
          Icon(status.icon, color: status.color, size: 14),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              subtopic.title,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
          ),
          if (scorePercent != null) ...[
            const SizedBox(width: 6),
            Text(
              '${scorePercent!.round()}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          if (medal != null && medal != 'None') ...[
            const SizedBox(width: 5),
            MedalBadge(medal: medal, size: 13),
          ],
        ],
      ),
    );
  }
}
