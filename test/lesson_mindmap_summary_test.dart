import 'package:astro_stem_labs/features/lesson/lesson_mindmap_summary.dart';
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
}
