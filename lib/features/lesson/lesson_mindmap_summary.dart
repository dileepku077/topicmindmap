import 'dart:math' as math;

import 'package:flutter/material.dart';

/// One `##` section of a lesson: its heading, plus a short plain-text
/// excerpt of the prose under it (the first non-structural line -- skips
/// blank lines, fenced code, raw HTML/SVG diagram blocks, and markdown
/// table rows) to show on tap as a "tell me more" preview.
class LessonSection {
  const LessonSection({required this.heading, this.snippet});

  final String heading;
  final String? snippet;
}

/// Splits a lesson's markdown into its `##` sections, in document order.
/// Every MPM2D lesson (assets/data/mpm2d_topics_mindmap.json) already
/// follows this heading structure (## The Idea, ## Worked Example,
/// ## Common Mistakes, ...), so [LessonMindmapSummary] needs no separate
/// content authored per lesson -- both the branch labels and their
/// preview snippets come straight out of the same markdown the rest of
/// the page already renders.
List<LessonSection> extractLessonSections(String markdown) {
  final sections = <LessonSection>[];
  var inFencedBlock = false;
  String? heading;
  final body = <String>[];

  void flush() {
    if (heading != null) {
      sections.add(LessonSection(heading: heading, snippet: _firstProse(body)));
    }
    body.clear();
  }

  for (final line in markdown.split('\n')) {
    final trimmed = line.trimLeft();
    if (trimmed.startsWith('```')) {
      inFencedBlock = !inFencedBlock;
      continue;
    }
    if (inFencedBlock) continue;
    if (trimmed.startsWith('## ')) {
      flush();
      heading = trimmed.substring(3).trim();
      continue;
    }
    if (heading != null) body.add(line);
  }
  flush();
  return sections;
}

/// Backward-compatible shorthand for just the heading text, in order.
List<String> extractSectionHeadings(String markdown) =>
    extractLessonSections(markdown).map((s) => s.heading).toList();

String? _firstProse(List<String> bodyLines) {
  var inFence = false;
  for (final raw in bodyLines) {
    final line = raw.trim();
    if (line.startsWith('```')) {
      inFence = !inFence;
      continue;
    }
    if (inFence || line.isEmpty) continue;
    if (line.startsWith('<') || line.startsWith('|') || line.startsWith('#')) {
      continue;
    }
    return line.replaceAll('**', '').replaceAll('`', '');
  }
  return null;
}

/// Best-effort icon for a section based on the recurring heading patterns
/// across this app's lessons (every MPM2D lesson ends in some variation of
/// "Common Mistakes" / "Quick Gut-Check", most open with "The Idea", etc.)
/// -- approximate by design, with a sensible fallback for anything novel,
/// rather than a hand-maintained per-lesson icon list.
IconData iconForHeading(String heading) {
  final h = heading.toLowerCase();
  if (h.contains('mistake')) return Icons.warning_amber_rounded;
  if (h.contains('gut-check') ||
      h.contains('gut check') ||
      h.contains('quiz')) {
    return Icons.quiz_outlined;
  }
  if (h.contains('idea')) return Icons.lightbulb_outline;
  if (h.contains('formula')) return Icons.functions_outlined;
  if (h.contains('worked example') || h.contains('example')) {
    return Icons.calculate_outlined;
  }
  if (h.contains('method') || h.contains('toolkit') || h.contains('tool')) {
    return Icons.build_circle_outlined;
  }
  if (h.contains('step')) return Icons.list_alt_outlined;
  if (h.contains('checklist') || h.contains('decision')) {
    return Icons.checklist_outlined;
  }
  if (h.contains('vs.') || h.contains(' vs ') || h.contains('choos')) {
    return Icons.compare_arrows_outlined;
  }
  if (h.contains('why') || h.contains('matter') || h.contains('bother')) {
    return Icons.psychology_alt_outlined;
  }
  if (h.contains('real-world') ||
      h.contains('real world') ||
      h.contains('application')) {
    return Icons.public_outlined;
  }
  if (h.contains('try it')) return Icons.touch_app_outlined;
  if (h.contains('graph') || h.contains('sketch') || h.contains('slope')) {
    return Icons.show_chart_outlined;
  }
  if (h.contains('angle')) return Icons.explore_outlined;
  if (h.contains('triangle') ||
      h.contains('quadrilateral') ||
      h.contains('classif')) {
    return Icons.category_outlined;
  }
  if (h.contains('when to use')) return Icons.help_outline;
  if (h.contains('setting') || h.contains('setup') || h.contains('set up')) {
    return Icons.tune_outlined;
  }
  // From here down: Grade 9/10 Science and Grade 11 Physics headings
  // (assets/data/snc2d_topics_mindmap.json, sph3u_topics_mindmap.json)
  // don't otherwise overlap much with the math-lesson patterns above.
  if (h.startsWith('table:')) return Icons.table_chart_outlined;
  if (h.contains('law') || h.contains('conservation')) {
    return Icons.balance_outlined;
  }
  if (h.contains('circuit') ||
      h.contains('current') ||
      h.contains('voltage') ||
      h.contains('charge') ||
      h.contains('magnet')) {
    return Icons.electrical_services_outlined;
  }
  if (h.contains('wave') || h.contains('sound') || h.contains('pitch')) {
    return Icons.graphic_eq_outlined;
  }
  if (h.contains('light') ||
      h.contains('reflect') ||
      h.contains('lens') ||
      h.contains('mirror') ||
      h.contains('image') ||
      h.contains('eye')) {
    return Icons.visibility_outlined;
  }
  if (h.contains('cell') ||
      h.contains('tissue') ||
      h.contains('organ') ||
      h.contains('blood') ||
      h.contains('digest') ||
      h.contains('circulat') ||
      h.contains('respirat') ||
      h.contains('muscle') ||
      h.contains('nerv')) {
    return Icons.biotech_outlined;
  }
  if (h.contains('acid') ||
      h.contains('bond') ||
      h.contains('react') ||
      h.contains('compound') ||
      h.contains('element') ||
      h.contains('atom') ||
      h.contains('ion')) {
    return Icons.science_outlined;
  }
  if (h.contains('climate') ||
      h.contains('greenhouse') ||
      h.contains('ecosystem') ||
      h.contains('ocean') ||
      h.contains('atmosphere')) {
    return Icons.eco_outlined;
  }
  if (h.contains('velocity') ||
      h.contains('acceleration') ||
      h.contains('motion') ||
      h.contains('speed') ||
      h.contains('displacement') ||
      h.contains('distance')) {
    return Icons.speed_outlined;
  }
  if (h.contains('energy') || h.contains('power') || h.contains('force')) {
    return Icons.bolt_outlined;
  }
  return Icons.label_important_outline;
}

const double _hubWidth = 200;
const double _hubHeight = 78;
const double _subWidth = 220;
const double _subHeight = 132;
const double _subGap = 18;

/// Branch box size shrinks as a lesson has more sections -- otherwise the
/// ring radius needed to keep boxes from overlapping (see
/// [_layoutBranches]) grows without bound for lessons with more sections,
/// and this app's lessons range from 5 to 9.
({double width, double height, double fontSize, int maxLines}) _branchSizeFor(
  int count,
) {
  if (count <= 6) return (width: 152, height: 82, fontSize: 14, maxLines: 2);
  if (count <= 8) return (width: 134, height: 88, fontSize: 13, maxLines: 3);
  return (width: 118, height: 92, fontSize: 12.5, maxLines: 3);
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
  final minSeparation = math.max(branchSize.width, branchSize.height) + gap;
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

/// A distinct, theme-aware color per branch -- evenly spaced hues rotated
/// off the app's own primary color, rather than a hardcoded palette, so
/// dark mode gets an equally readable set for free. What actually makes
/// this read as a mindmap instead of a table of contents: every branch
/// having its own color and icon, not just its own box.
Color _branchColor(BuildContext context, int index, int count) {
  final base = HSLColor.fromColor(Theme.of(context).colorScheme.primary);
  final hue = (base.hue + (360 / math.max(count, 1)) * index) % 360;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return base
      .withHue(hue)
      .withSaturation(math.max(base.saturation, 0.45))
      .withLightness(isDark ? 0.72 : 0.42)
      .toColor();
}

/// A one-glance visual summary shown at the top of a lesson page, before
/// the full markdown body -- the lesson's title as a hub, its sections
/// radiating out as color-coded, iconed branches. Tapping a branch reveals
/// a sub-node with a short preview of what that section actually covers,
/// so a student can peek at the shape of a lesson (and sample it) before
/// reading it line by line. There's no scroll-to-section: the lesson body
/// itself renders inside an HTML iframe (html/html_lesson_view.dart),
/// which makes jumping to a specific section from outside it more
/// machinery than this is worth -- the preview is the payoff instead.
class LessonMindmapSummary extends StatefulWidget {
  const LessonMindmapSummary({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  State<LessonMindmapSummary> createState() => _LessonMindmapSummaryState();
}

class _LessonMindmapSummaryState extends State<LessonMindmapSummary> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final sections = extractLessonSections(widget.content);
    if (sections.isEmpty) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final branchSize = _branchSizeFor(sections.length);
    final offsets = _layoutBranches(sections.length, branchSize);
    final radius = offsets.first.distance;
    final branchReach = math.max(branchSize.width, branchSize.height) / 2;

    final expanded = _expandedIndex;
    final hasExpanded = expanded != null && expanded < sections.length;
    final subDistance =
        radius + branchReach + _subGap + math.max(_subWidth, _subHeight) / 2;

    final maxAbsX = offsets.map((o) => o.dx.abs()).reduce(math.max);
    final maxAbsY = offsets.map((o) => o.dy.abs()).reduce(math.max);
    final diagramWidth = hasExpanded
        ? 2 * (subDistance + math.max(_subWidth, _subHeight) / 2) + 8
        : 2 * maxAbsX + branchSize.width + 8;
    final diagramHeight = hasExpanded
        ? 2 * (subDistance + math.max(_subWidth, _subHeight) / 2) + 8
        : 2 * maxAbsY + branchSize.height + 8;
    final center = Offset(diagramWidth / 2, diagramHeight / 2);
    final branchCenters = [for (final o in offsets) center + o];

    void toggle(int i) {
      setState(() => _expandedIndex = _expandedIndex == i ? null : i);
    }

    Offset? subCenter;
    Color? subColor;
    if (hasExpanded) {
      final angle = -math.pi / 2 + 2 * math.pi * expanded / sections.length;
      subCenter = center + Offset.fromDirection(angle, subDistance);
      subColor = _branchColor(context, expanded, sections.length);
    }

    // Opts out of the app-wide text-scale boost (app.dart): every node's
    // font size and box size here were sized together so text fits its
    // box exactly (see _layoutBranches) -- letting the global scaler also
    // multiply these on top would grow the text without growing the boxes
    // to match, clipping labels instead of making them more readable.
    final diagram = MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: SizedBox(
        width: diagramWidth,
        height: diagramHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              size: Size(diagramWidth, diagramHeight),
              painter: _SpokePainter(
                hubCenter: center,
                branchCenters: branchCenters,
                color: scheme.primary.withValues(alpha: 0.35),
                extraLine: hasExpanded
                    ? (
                        from: branchCenters[expanded],
                        to: subCenter!,
                        color: subColor!,
                      )
                    : null,
              ),
            ),
            for (var i = 0; i < sections.length; i++)
              Positioned(
                left: branchCenters[i].dx - branchSize.width / 2,
                top: branchCenters[i].dy - branchSize.height / 2,
                width: branchSize.width,
                height: branchSize.height,
                child: _BranchNode(
                  heading: sections[i].heading,
                  icon: iconForHeading(sections[i].heading),
                  color: _branchColor(context, i, sections.length),
                  size: branchSize,
                  selected: _expandedIndex == i,
                  onTap: () => toggle(i),
                ),
              ),
            if (hasExpanded)
              Positioned(
                left: subCenter!.dx - _subWidth / 2,
                top: subCenter.dy - _subHeight / 2,
                width: _subWidth,
                height: _subHeight,
                child: _SubNode(
                  section: sections[expanded],
                  icon: iconForHeading(sections[expanded].heading),
                  color: subColor!,
                  onClose: () => toggle(expanded),
                ),
              ),
            Positioned(
              left: center.dx - _hubWidth / 2,
              top: center.dy - _hubHeight / 2,
              width: _hubWidth,
              height: _hubHeight,
              child: _HubNode(title: widget.title),
            ),
          ],
        ),
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
              const Spacer(),
              Text(
                'Tap a branch to learn more',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Scales down to fit instead of scrolling -- this sits directly
          // above the lesson's own HTML iframe (html_lesson_view.dart), and
          // a horizontally-scrollable widget there is a known Flutter-web
          // trap: a drag that starts here and ends over the iframe loses
          // its pointer-up to the iframe's own document, leaving Flutter
          // thinking a pointer is still down and blocking every click
          // afterward. This diagram is decorative/tap-only, so it never
          // needed to be draggable in the first place.
          LayoutBuilder(
            builder: (context, constraints) {
              final scale = diagramWidth <= constraints.maxWidth
                  ? 1.0
                  : constraints.maxWidth / diagramWidth;
              return Center(
                child: SizedBox(
                  width: diagramWidth * scale,
                  height: diagramHeight * scale,
                  child: FittedBox(fit: BoxFit.contain, child: diagram),
                ),
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
    this.extraLine,
  });

  final Offset hubCenter;
  final List<Offset> branchCenters;
  final Color color;
  final ({Offset from, Offset to, Color color})? extraLine;

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
    final extra = extraLine;
    if (extra != null) {
      canvas.drawLine(
        extra.from,
        extra.to,
        Paint()
          ..color = extra.color.withValues(alpha: 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SpokePainter oldDelegate) =>
      oldDelegate.hubCenter != hubCenter ||
      oldDelegate.branchCenters != branchCenters ||
      oldDelegate.color != color ||
      oldDelegate.extraLine != extraLine;
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_outlined, size: 15, color: scheme.onPrimary),
          const SizedBox(height: 3),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: scheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchNode extends StatelessWidget {
  const _BranchNode({
    required this.heading,
    required this.icon,
    required this.color,
    required this.size,
    required this.selected,
    required this.onTap,
  });

  final String heading;
  final IconData icon;
  final Color color;
  final ({double width, double height, double fontSize, int maxLines}) size;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? color : scheme.outlineVariant,
              width: selected ? 2 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 15, color: color),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  heading,
                  textAlign: TextAlign.center,
                  maxLines: size.maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: size.fontSize,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubNode extends StatelessWidget {
  const _SubNode({
    required this.section,
    required this.icon,
    required this.color,
    required this.onClose,
  });

  final LessonSection section;
  final IconData icon;
  final Color color;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClose,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color, width: 1.6),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(icon, size: 17, color: color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      section.heading,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(Icons.close, size: 17, color: scheme.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  section.snippet ?? 'See the full lesson below for details.',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
