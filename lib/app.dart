import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'router/app_router.dart';
import 'state/theme_providers.dart';

/// A flat, modest boost on top of whatever text scale the student's own
/// browser/OS already requests -- multiplied in, not replacing it, so
/// someone who's already turned up their system font size for
/// accessibility reasons gets that preference honored AND this app's own
/// baseline readability bump, instead of one clobbering the other.
const _textScaleBoost = 1.12;

class TopicMindmapApp extends ConsumerWidget {
  const TopicMindmapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Astro STEM Labs',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeMode,
      routerConfig: router,
      // Every page reads its text size through Theme.of(context).textTheme
      // or a literal TextStyle -- MediaQuery's textScaler is the one lever
      // that reaches both, applied here once for the whole app instead of
      // hand-editing font sizes across every page.
      builder: (context, child) {
        final boosted =
            MediaQuery.textScalerOf(context).scale(1.0) * _textScaleBoost;
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(boosted)),
          child: child!,
        );
      },
    );
  }
}
