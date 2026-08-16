import 'package:markdown/markdown.dart' as md;

/// Builds a complete, self-contained HTML document for one lesson (or one
/// half of a lesson split around an interactive widget). Rendering lesson
/// text as real HTML — instead of Flutter's canvas-painted Markdown widget
/// — is what makes it selectable and copyable like a normal web page, and
/// gives it real CSS instead of Flutter's more limited style sheet API.
///
/// [frameId] is embedded in the page's auto-height script so the Flutter
/// side can match a `postMessage` height report back to the right iframe.
///
/// [videoTitle]/[videoUrl]/[videoSource] are optional and, when given,
/// render a "go deeper" card with an embedded player at the very end —
/// pass them only on the last HTML section of a lesson (see lesson_page).
String buildLessonHtml(
  String markdownContent, {
  required String frameId,
  String? videoTitle,
  String? videoUrl,
  String? videoSource,
}) {
  final bodyHtml = md.markdownToHtml(
    markdownContent,
    extensionSet: md.ExtensionSet.gitHubWeb,
  );
  final videoHtml = _buildVideoCard(
    title: videoTitle,
    url: videoUrl,
    source: videoSource,
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
$videoHtml
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

  // The video starts as a plain thumbnail (not a live iframe) so wheel
  // input over it still bubbles to the listener below — a real YouTube
  // iframe is its own cross-origin browsing context, so wheel events over
  // *that* can never reach us to forward on. Only swap in the real
  // (scroll-swallowing) iframe once the student explicitly asks to play it.
  var videoEmbed = document.querySelector('.video-embed[data-video-id]');
  if (videoEmbed) {
    videoEmbed.addEventListener('click', function () {
      var id = videoEmbed.getAttribute('data-video-id');
      var title = videoEmbed.getAttribute('data-video-title') || 'Video';
      var iframe = document.createElement('iframe');
      iframe.src = 'https://www.youtube-nocookie.com/embed/' + id + '?autoplay=1';
      iframe.title = title;
      iframe.allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture';
      iframe.allowFullscreen = true;
      iframe.style.cssText = 'position:absolute;inset:0;width:100%;height:100%;border:0;';
      videoEmbed.textContent = '';
      videoEmbed.appendChild(iframe);
      videoEmbed.classList.add('playing');
    }, { once: true });
    videoEmbed.addEventListener('keydown', function (e) {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        videoEmbed.click();
      }
    });
  }

  // Same reasoning as the video: an active Desmos graph is its own
  // cross-origin iframe that captures scroll to zoom the graph, which
  // would otherwise make the page un-scrollable the moment the cursor
  // passes over it. Show a plain "open" button first (ordinary page
  // content, scrolls fine) and only mount the live, scroll-capturing
  // Desmos iframe once the student clicks in to explore it.
  var desmosEmbed = document.querySelector('.desmos-embed[data-desmos-url]');
  if (desmosEmbed) {
    var openDesmos = function () {
      var iframe = document.createElement('iframe');
      iframe.src = desmosEmbed.getAttribute('data-desmos-url');
      iframe.title = 'Interactive Desmos graph';
      iframe.style.cssText = 'position:absolute;inset:0;width:100%;height:100%;border:0;';
      desmosEmbed.textContent = '';
      desmosEmbed.appendChild(iframe);
    };
    desmosEmbed.querySelector('.desmos-open').addEventListener('click', openDesmos, { once: true });
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

/// Escapes text pulled from lesson JSON (video titles/sources) before it's
/// dropped into an HTML attribute or text node.
String _htmlEscape(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

/// Pulls the 11-character video id out of a youtube.com/watch?v=... or
/// youtu.be/... URL so it can be embedded via youtube-nocookie.com.
String? _youtubeId(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return null;
  if (uri.host.contains('youtu.be')) {
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
  }
  return uri.queryParameters['v'];
}

/// Renders the end-of-lesson "go deeper" card: a click-to-play YouTube
/// thumbnail (see the click handler in buildLessonHtml's script — it swaps
/// in the real player only once clicked, so an idle video never swallows
/// scroll input) plus a fallback link. Returns an empty string (nothing
/// rendered) when [url] is null or isn't a recognizable YouTube link.
String _buildVideoCard({required String? title, required String? url, required String? source}) {
  if (title == null || url == null) return '';
  final id = _youtubeId(url);
  if (id == null) return '';

  final safeTitle = _htmlEscape(title);
  final safeSource = source != null ? _htmlEscape(source) : null;
  final thumbUrl = 'https://img.youtube.com/vi/$id/hqdefault.jpg';

  return '''
<div class="video-card">
  <div class="video-label">Go deeper</div>
  <div class="video-embed" data-video-id="$id" data-video-title="$safeTitle" style="background-image:url('$thumbUrl')" role="button" tabindex="0" aria-label="Play video: $safeTitle">
    <button class="video-play" type="button" tabindex="-1" aria-hidden="true">
      <svg viewBox="0 0 68 48" width="100%" height="100%">
        <path d="M66.5,7.7c-0.8-2.9-2.4-5.4-4.7-6.9C58.5-0.9,34,0,34,0S9.5-0.9,6.2,0.8C3.9,2.3,2.3,4.8,1.5,7.7C0,13.2,0,24,0,24s0,10.8,1.5,16.3c0.8,2.9,2.4,5.4,4.7,6.9C9.5,48.9,34,48,34,48s24.5,0.9,27.8-0.8c2.3-1.5,3.9-4,4.7-6.9C68,34.8,68,24,68,24S68,13.2,66.5,7.7z" fill="#1b1b1b" fill-opacity="0.82"/>
        <path d="M 45,24 27,14 27,34" fill="#fff"/>
      </svg>
    </button>
  </div>
  <div class="video-title">$safeTitle</div>
  <a class="video-link" href="$url" target="_blank" rel="noopener noreferrer">
    Watch on YouTube${safeSource != null ? ' · $safeSource' : ''} ↗
  </a>
</div>
''';
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

  .diagram {
    max-width: 520px;
    margin: 1.2em auto;
    padding: 10px;
    border: 1px solid var(--border);
    border-radius: 10px;
    background: var(--surface);
  }
  .diagram svg { display: block; width: 100%; height: auto; }
  .diagram-caption {
    margin-top: 6px;
    font-size: 0.78rem;
    color: var(--text-2);
    text-align: center;
  }

  .video-card {
    max-width: 520px;
    margin: 2em auto 0.5em;
    padding: 12px;
    border: 1px solid var(--border);
    border-radius: 12px;
    background: rgba(var(--accent-rgb), 0.05);
  }
  .video-label {
    font-size: 0.7rem;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    color: var(--accent);
    font-weight: 700;
    margin-bottom: 8px;
  }
  .video-embed {
    position: relative;
    width: 100%;
    padding-bottom: 56.25%;
    border-radius: 8px;
    overflow: hidden;
    background: #000 center / cover no-repeat;
    cursor: pointer;
  }
  .video-embed[data-video-id]:focus-visible {
    outline: 2px solid var(--accent);
    outline-offset: 2px;
  }
  .video-embed iframe {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    border: 0;
  }
  .video-play {
    position: absolute;
    inset: 0;
    margin: auto;
    width: 25%;
    min-width: 40px;
    max-width: 68px;
    aspect-ratio: 68 / 48;
    background: none;
    border: none;
    padding: 0;
    cursor: pointer;
    transition: transform 0.15s ease;
  }
  .video-embed:hover .video-play { transform: scale(1.08); }
  .video-title {
    margin-top: 10px;
    font-size: 0.92rem;
    font-weight: 600;
    color: var(--text);
  }
  .video-link {
    display: inline-block;
    margin-top: 4px;
    font-size: 0.82rem;
    color: var(--accent);
    text-decoration: none;
  }
  .video-link:hover { text-decoration: underline; }

  .desmos-card {
    max-width: 600px;
    margin: 1.6em auto;
    padding: 12px;
    border: 1px solid var(--border);
    border-radius: 12px;
    background: rgba(var(--code-accent-rgb), 0.05);
  }
  .desmos-label {
    font-size: 0.7rem;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    color: var(--code-accent);
    font-weight: 700;
    margin-bottom: 8px;
  }
  .desmos-embed {
    position: relative;
    width: 100%;
    height: 420px;
    border-radius: 8px;
    overflow: hidden;
    background: var(--surface);
    border: 1px solid var(--border);
  }
  .desmos-embed iframe {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    border: 0;
  }
  .desmos-open {
    position: absolute;
    inset: 0;
    margin: auto;
    width: max-content;
    height: max-content;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    background: none;
    border: none;
    cursor: pointer;
    color: var(--code-accent);
    font-family: inherit;
    font-size: 0.95rem;
    font-weight: 700;
    padding: 16px 24px;
    transition: transform 0.15s ease;
  }
  .desmos-open:hover { transform: scale(1.04); }
''';
