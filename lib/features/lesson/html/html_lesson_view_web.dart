// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
//
// dart:html is soft-deprecated in favor of package:web + dart:js_interop,
// but still fully functional on this SDK and far less boilerplate for a
// small, isolated, conditionally-imported file like this one.
import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

import 'lesson_html_builder.dart';

int _viewCounter = 0;

/// Renders [markdown] as real HTML inside an iframe, so the text is
/// natively selectable/copyable (and searchable with Ctrl/Cmd+F) — things
/// Flutter's canvas-painted text can't do. Auto-sizes to its content via a
/// `postMessage` height report from the iframe (see lesson_html_builder).
class HtmlLessonView extends StatefulWidget {
  const HtmlLessonView({super.key, required this.frameId, required this.markdown});

  final String frameId;
  final String markdown;

  @override
  State<HtmlLessonView> createState() => _HtmlLessonViewState();
}

class _HtmlLessonViewState extends State<HtmlLessonView> {
  double _height = 1;
  StreamSubscription<html.MessageEvent>? _subscription;
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'html-lesson-view-${widget.frameId}-${_viewCounter++}';

    final iframe = html.IFrameElement()
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.display = 'block'
      ..srcdoc = buildLessonHtml(widget.markdown, frameId: widget.frameId);

    try {
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) => iframe);
    } catch (_) {
      // Already registered — can happen across a hot reload; the existing
      // factory still points at a live element, so this is safe to ignore.
    }

    _subscription = html.window.onMessage.listen((event) {
      // The iframe posts a JSON string (not a raw JS object) so it arrives
      // as a plain Dart String across the dart:html boundary — a JS object
      // would arrive unreadable as a JSObject, not a Dart Map.
      final raw = event.data;
      if (raw is! String) return;
      final data = jsonDecode(raw);
      if (data is! Map) return;
      if (data['frameId'] != widget.frameId) return;
      if (!mounted) return;

      switch (data['type']) {
        case 'lesson-html-height':
          final newHeight = (data['height'] as num).toDouble();
          if ((newHeight - _height).abs() > 0.5) {
            setState(() => _height = newHeight);
          }
        case 'lesson-html-scroll':
          // The iframe's own document never scrolls internally, so wheel
          // input over it would otherwise be swallowed instead of moving
          // the lesson page — drive the enclosing Scrollable by hand.
          final position = Scrollable.maybeOf(context)?.position;
          if (position == null) return;
          final deltaY = (data['deltaY'] as num).toDouble();
          final target = (position.pixels + deltaY).clamp(
            position.minScrollExtent,
            position.maxScrollExtent,
          );
          position.jumpTo(target);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: double.infinity,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
