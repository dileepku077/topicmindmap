import 'package:markdown/markdown.dart' as md;

/// Builds a complete, self-contained HTML document for one lesson (or one
/// half of a lesson split around an interactive widget). Rendering lesson
/// text as real HTML — instead of Flutter's canvas-painted Markdown widget
/// — is what makes it selectable and copyable like a normal web page, and
/// gives it real CSS instead of Flutter's more limited style sheet API.
///
/// [frameId] is embedded in the page's auto-height script so the Flutter
/// side can match a `postMessage` height report back to the right iframe.
String buildLessonHtml(String markdownContent, {required String frameId}) {
  final bodyHtml = md.markdownToHtml(
    markdownContent,
    extensionSet: md.ExtensionSet.gitHubWeb,
  );

  return '''
<!doctype html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
$_lessonCss
</style>
</head>
<body>
<div id="lesson-root">
$bodyHtml
</div>
<script>
(function () {
  var root = document.getElementById('lesson-root');
  function reportHeight() {
    window.parent.postMessage(
      JSON.stringify({ type: 'lesson-html-height', frameId: ${_jsString(frameId)}, height: root.scrollHeight }),
      '*'
    );
  }
  reportHeight();
  window.addEventListener('load', reportHeight);
  if (window.ResizeObserver) {
    new ResizeObserver(reportHeight).observe(root);
  }

  // This iframe's own document never scrolls internally (its height
  // always matches its content), so wheel/trackpad input over it would
  // otherwise just vanish instead of scrolling the lesson page. Forward
  // it to the parent Flutter page so it can move the outer scroll view.
  window.addEventListener('wheel', function (e) {
    window.parent.postMessage(
      JSON.stringify({
        type: 'lesson-html-scroll',
        frameId: ${_jsString(frameId)},
        deltaY: e.deltaY,
        deltaX: e.deltaX,
      }),
      '*'
    );
  }, { passive: true });
})();
</script>
</body>
</html>
''';
}

/// Minimal safe embedding of a Dart string as a JS string literal. Only
/// ever called with ids we generate ourselves (lesson id + a fixed suffix),
/// never with lesson content, but escaped properly regardless.
String _jsString(String value) {
  final escaped = value.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
  return "'$escaped'";
}

const _lessonCss = '''
  :root {
    --bg: #f3f5f9;
    --surface: #ffffff;
    --text: #1b2333;
    --text-2: #5b6478;
    --accent: #2554c7;
    --accent-rgb: 37, 84, 199;
    --accent-2: #c62f4c;
    --accent-2-rgb: 198, 47, 76;
    --code-accent: #0e8f7a;
    --code-accent-rgb: 14, 143, 122;
    --border: #dde2ec;
    --border-rgb: 221, 226, 236;
  }
  @media (prefers-color-scheme: dark) {
    :root {
      --bg: #10131c;
      --surface: #171b27;
      --text: #e7eaf2;
      --text-2: #9aa2b6;
      --accent: #85a4ff;
      --accent-rgb: 133, 164, 255;
      --accent-2: #ff8fa3;
      --accent-2-rgb: 255, 143, 163;
      --code-accent: #4fd6bc;
      --code-accent-rgb: 79, 214, 188;
      --border: #2a2f3d;
      --border-rgb: 42, 47, 61;
    }
  }
  * { box-sizing: border-box; }
  html, body { margin: 0; padding: 0; background: transparent; }
  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    font-size: 16px;
    line-height: 1.7;
    color: var(--text);
    padding: 2px 2px 4px;
  }
  h1, h2, h3 {
    color: var(--accent);
    font-weight: 700;
    line-height: 1.25;
    margin: 1.5em 0 0.55em;
  }
  h1:first-child, h2:first-child, h3:first-child { margin-top: 0; }
  h1 { font-size: 1.55rem; }
  h2 {
    font-size: 1.2rem;
    border-top: 1px solid var(--border);
    padding-top: 1em;
  }
  h2:first-child { border-top: none; padding-top: 0; }
  h3 { font-size: 1.05rem; }
  p { margin: 0.7em 0; }
  strong { color: var(--accent-2); font-weight: 700; }
  em { color: var(--text-2); font-style: italic; }
  a { color: var(--accent); }
  ul, ol { padding-left: 1.4em; margin: 0.7em 0; }
  li { margin: 0.35em 0; }
  li::marker { color: var(--accent); font-weight: 700; }
  code {
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 0.88em;
    background: rgba(var(--code-accent-rgb), 0.14);
    color: var(--code-accent);
    padding: 0.15em 0.4em;
    border-radius: 5px;
  }
  pre {
    background: var(--surface);
    border: 1px solid var(--border);
    border-left: 3px solid var(--code-accent);
    border-radius: 8px;
    padding: 12px 14px;
    overflow-x: auto;
    margin: 1em 0;
  }
  pre code {
    background: none;
    color: var(--text);
    padding: 0;
    font-size: 0.88em;
    line-height: 1.6;
    white-space: pre;
  }
  table {
    border-collapse: collapse;
    width: 100%;
    margin: 1em 0;
    font-size: 0.92em;
    display: block;
    overflow-x: auto;
  }
  th, td {
    border: 1px solid var(--border);
    padding: 8px 10px;
    text-align: left;
  }
  th {
    background: rgba(var(--accent-rgb), 0.1);
    color: var(--accent);
    font-weight: 700;
  }
  tr:nth-child(even) td { background: rgba(var(--border-rgb), 0.35); }
  blockquote {
    margin: 1em 0;
    padding: 0.6em 1em;
    border-left: 3px solid var(--accent);
    background: rgba(var(--accent-rgb), 0.08);
    color: var(--text-2);
  }
  blockquote p { margin: 0.3em 0; }
  hr { border: none; border-top: 1px solid var(--border); margin: 1.6em 0; }
  ::selection { background: rgba(var(--accent-rgb), 0.3); }
''';
