import 'dart:math' as math;

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

const double _hubWidth = 180;
const double _hubHeight = 64;

/// Branch box size shrinks as a lesson has more sections -- otherwise the
/// ring radius needed to keep boxes from overlapping (see
/// [_layoutBranches]) grows without bound for lessons with more sections,
/// and this app's lessons range from 5 to 9.
({double width, double height, double fontSize, int maxLines}) _branchSizeFor(
  int count,
) {
  if (count <= 6) return (width: 138, height: 56, fontSize: 12, maxLines: 2);
  if (count <= 8) return (width: 116, height: 58, fontSize: 11.5, maxLines: 3);
  return (width: 100, height: 60, fontSize: 11, maxLines: 3);
}

/// Places [count] branch nodes evenly around a circle centered on the hub,
/// starting from the top and going clockwise, then grows the radius until
/// no two branch boxes (of [branchSize]) would overlap and the ring
/// clears the hub. A small local search rather than a closed-form radius:
/// the hub is wider than it is tall while branch boxes are roughly square,
/// so the binding constraint (hub clearance vs. neighboring-branch
/// clearance) flips depending on branch count, and re-deriving that
/// algebraically for every count is more fragile than just checking.
List<Offset> _layoutBranches(
  int count,
  ({double width, double height, double fontSize, int maxLines}) branchSize,
) {
  if (count <= 0) return const [];
  const margin = 14.0;
  const gap = 10.0;
  final minSeparation = branchSize.width + gap;
  var radius = _hubWidth / 2 + branchSize.width / 2 + margin; // clears the hub
  if (count == 1) return [Offset(0, -radius)];

  while (true) {
    final points = [
      for (var i = 0; i < count; i++)
        Offset.fromDirection(-math.pi / 2 + 2 * math.pi * i / count, radius),
    ];
    var overlaps = false;
    for (var i = 0; i < count && !overlaps; i++) {
      for (var j = i + 1; j < count; j++) {
        if ((points[i] - points[j]).distance < minSeparation) {
          overlaps = true;
          break;
        }
      }
    }
    if (!overlaps) return points;
    radius *= 1.06;
  }
}

/// A one-glance visual summary shown at the top of a lesson page, before
/// the full markdown body -- the lesson's title as a hub, its sections
/// radiating out as branches, so a student can see the shape of what's
/// coming before reading it line by line. Purely decorative (no
/// navigation/scroll-to): the lesson body itself renders inside an HTML
/// iframe (html/html_lesson_view.dart), which makes jumping to a specific
/// section from outside it more machinery than a static overview is
/// worth. Wider than a typical phone screen once a lesson has more than a
/// few sections, so the diagram scrolls horizontally rather than
/// squeezing branch boxes until their labels are unreadable -- panning
/// around a mindmap is already how the rest of this app works.
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
    final branchSize = _branchSizeFor(sections.length);
    final offsets = _layoutBranches(sections.length, branchSize);
    final maxAbsX = offsets.map((o) => o.dx.abs()).reduce(math.max);
    final maxAbsY = offsets.map((o) => o.dy.abs()).reduce(math.max);
    final diagramWidth = 2 * maxAbsX + branchSize.width + 8;
    final diagramHeight = 2 * maxAbsY + branchSize.height + 8;
    final center = Offset(diagramWidth / 2, diagramHeight / 2);
    final branchCenters = [for (final o in offsets) center + o];

    final diagram = SizedBox(
      width: diagramWidth,
      height: diagramHeight,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(diagramWidth, diagramHeight),
            painter: _SpokePainter(
              hubCenter: center,
              branchCenters: branchCenters,
              color: scheme.primary.withValues(alpha: 0.4),
            ),
          ),
          for (var i = 0; i < sections.length; i++)
            Positioned(
              left: branchCenters[i].dx - branchSize.width / 2,
              top: branchCenters[i].dy - branchSize.height / 2,
              width: branchSize.width,
              height: branchSize.height,
              child: _BranchNode(label: sections[i], size: branchSize),
            ),
          Positioned(
            left: center.dx - _hubWidth / 2,
            top: center.dy - _hubHeight / 2,
            width: _hubWidth,
            height: _hubHeight,
            child: _HubNode(title: title),
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
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
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              if (diagramWidth <= constraints.maxWidth) {
                return Center(child: diagram);
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: diagram,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SpokePainter extends CustomPainter {
  _SpokePainter({
    required this.hubCenter,
    required this.branchCenters,
    required this.color,
  });

  final Offset hubCenter;
  final List<Offset> branchCenters;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (final branch in branchCenters) {
      canvas.drawLine(hubCenter, branch, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpokePainter oldDelegate) =>
      oldDelegate.hubCenter != hubCenter ||
      oldDelegate.branchCenters != branchCenters ||
      oldDelegate.color != color;
}

class _HubNode extends StatelessWidget {
  const _HubNode({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(18),
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
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: scheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          height: 1.15,
        ),
      ),
    );
  }
}

class _BranchNode extends StatelessWidget {
  const _BranchNode({required this.label, required this.size});

  final String label;
  final ({double width, double height, double fontSize, int maxLines}) size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outlineVariant, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: size.maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: scheme.onSurface,
          fontSize: size.fontSize,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
      ),
    );
  }
}
