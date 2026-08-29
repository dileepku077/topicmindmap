import 'package:astro_stem_labs/features/lesson/lesson_mindmap_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('extractSectionHeadings', () {
    test('pulls ## headings in document order', () {
      const markdown = '''
# Title

## The Idea

Some body text.

## Worked Example

More text.

## Common Mistakes
''';
      expect(extractSectionHeadings(markdown), [
        'The Idea',
        'Worked Example',
        'Common Mistakes',
      ]);
    });

    test('ignores headings inside fenced code blocks', () {
      const markdown = '''
## Real Heading

```
## Not a heading
```

## Another Real Heading
''';
      expect(extractSectionHeadings(markdown), [
        'Real Heading',
        'Another Real Heading',
      ]);
    });

    test('does not match deeper headings like ### or #', () {
      const markdown = '''
# Top Level

### Sub-sub Heading

## Actual Section
''';
      expect(extractSectionHeadings(markdown), ['Actual Section']);
    });

    test('returns an empty list when there are no ## headings', () {
      expect(extractSectionHeadings('Just a paragraph, no headings.'), isEmpty);
    });
  });

  group('extractLessonSections', () {
    test('pairs each heading with the first prose line under it', () {
      const markdown = '''
## The Idea

A parabola is the curve you get from a quadratic relation.

More detail here.

## Worked Example

Solve for x.
''';
      final sections = extractLessonSections(markdown);
      expect(sections, hasLength(2));
      expect(sections[0].heading, 'The Idea');
      expect(
        sections[0].snippet,
        'A parabola is the curve you get from a quadratic relation.',
      );
      expect(sections[1].snippet, 'Solve for x.');
    });

    test(
      'skips blank lines, tables, and raw HTML before the first prose line',
      () {
        const markdown = '''
## Key Features

| x | y |
|---|---|
| 0 | 1 |

<div class="diagram">
<svg></svg>
</div>

Real explanation starts here.
''';
        final sections = extractLessonSections(markdown);
        expect(sections.single.snippet, 'Real explanation starts here.');
      },
    );

    test('strips bold/code markdown syntax from the snippet', () {
      const markdown = '''
## The Idea

A **parabola** has a `vertex` at its turning point.
''';
      expect(
        extractLessonSections(markdown).single.snippet,
        'A parabola has a vertex at its turning point.',
      );
    });

    test('snippet is null when a section has no prose at all', () {
      const markdown = '''
## Just a Table

| x | y |
|---|---|
| 0 | 1 |
''';
      expect(extractLessonSections(markdown).single.snippet, isNull);
    });
  });

  group('iconForHeading', () {
    test('maps common recurring headings to distinct icons', () {
      expect(iconForHeading('Common Mistakes'), Icons.warning_amber_rounded);
      expect(iconForHeading('Quick Gut-Check'), Icons.quiz_outlined);
      expect(iconForHeading('The Idea'), Icons.lightbulb_outline);
      expect(iconForHeading('Worked Example'), Icons.calculate_outlined);
    });

    test('falls back to a sensible default for an unrecognized heading', () {
      expect(
        iconForHeading('Something Totally Novel'),
        Icons.label_important_outline,
      );
    });
  });
}
