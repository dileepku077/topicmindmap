import 'package:flutter/material.dart';

/// Pulls a lesson's top-level `##` markdown headings out, in document
/// order, skipping anything inside a fenced ``` code block. Every MPM2D
/// lesson (assets/data/mpm2d_topics_mindmap.json) already follows this
/// heading structure (## The Idea, ## Worked Example, ## Common Mistakes,
/// ...), so [LessonMindmapSummary] needs no separate content authored per
/// lesson -- the section titles it renders as "branches" come straight out
/// of the same markdown the rest of the page already renders.
List<String> extractSectionHeadings(String markdown) {
  final headings = <String>[];
  var inFencedBlock = false;
  for (final line in markdown.split('\n')) {
    final trimmed = line.trimLeft();
    if (trimmed.startsWith('```')) {
      inFencedBlock = !inFencedBlock;
      continue;
    }
    if (inFencedBlock) continue;
    if (trimmed.startsWith('## ')) {
      headings.add(trimmed.substring(3).trim());
    }
  }
  return headings;
}

/// A one-glance visual summary shown at the top of a lesson page, before
/// the full markdown body -- the lesson's title as a hub, its sections as
/// branches, so a student can see the shape of what's coming before
/// reading it line by line. Purely decorative (no navigation/scroll-to):
/// the lesson body itself renders inside an HTML iframe
/// (html/html_lesson_view.dart), which makes jumping to a specific
/// section from outside it more machinery than a static overview is worth.
class LessonMindmapSummary extends StatelessWidget {
  const LessonMindmapSummary({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final sections = extractSectionHeadings(content);
    if (sections.isEmpty) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.hub_outlined,
                size: 16,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'LESSON OVERVIEW',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(child: _HubNode(title: title)),
          Center(
            child: Container(
              width: 1.5,
              height: 22,
              color: scheme.outlineVariant,
            ),
          ),
          const SizedBox(height: 2),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 12,
            children: [
              for (final section in sections) _SpokeChip(label: section),
            ],
          ),
        ],
      ),
    );
  }
}

class _HubNode extends StatelessWidget {
  const _HubNode({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        decoration: BoxDecoration(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: scheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _SpokeChip extends StatelessWidget {
  const _SpokeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 150),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: scheme.outlineVariant, width: 1.2),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}
