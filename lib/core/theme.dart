import 'package:flutter/material.dart';

/// A serif face for headline-tier text only (app name, course/unit page
/// titles, subtopic titles, medal callouts) — see every `headlineSmall`
/// usage across the app. System-available, so no webfont to load and no
/// flash-of-unstyled-text risk on web; `fontFamilyFallback` covers
/// platforms where the first choice isn't installed. Body/title/label
/// text stays on the platform's own default sans, unchanged — this is a
/// display accent, not a full typeface swap, so the identity moments read
/// as considered without making dense UI chrome (buttons, list rows, form
/// fields) harder to scan.
const _headlineFontFamily = 'Georgia';
const _headlineFontFamilyFallback = ['Times New Roman', 'serif'];

TextTheme _withHeadlineSerif(TextTheme base) {
  TextStyle? serif(TextStyle? style) => style?.copyWith(
    fontFamily: _headlineFontFamily,
    fontFamilyFallback: _headlineFontFamilyFallback,
  );
  return base.copyWith(
    displayLarge: serif(base.displayLarge),
    displayMedium: serif(base.displayMedium),
    displaySmall: serif(base.displaySmall),
    headlineLarge: serif(base.headlineLarge),
    headlineMedium: serif(base.headlineMedium),
    headlineSmall: serif(base.headlineSmall),
  );
}

/// Explicit (not seed-generated) light palette: the "trustworthy academic"
/// combination — navy blue, teal, and off-white — used by mainstream
/// education/productivity products (Google Classroom, Coursera, Edmodo,
/// LinkedIn) because a blue-led palette reads as stable and credible
/// rather than playful. Navy anchors primary actions and headings, teal
/// marks selected/active state as a distinct but related accent, and the
/// background is a cool off-white rather than Material's own auto-
/// generated light tones (or this app's earlier warm cream). Only the
/// roles that are actually visible elsewhere in the app are overridden;
/// everything else comes from [ColorScheme.fromSeed] on the same navy so
/// unset roles (containers, inverse surfaces, etc.) still form one
/// coherent Material 3 palette instead of defaulting to something
/// unrelated.
const _lightPrimary = Color(0xFF1D3557);
const _lightSecondary = Color(0xFF0F8B8D);
const _lightBackground = Color(0xFFF5F7F8);
const _lightSurfaceContainerHighest = Color(0xFFE7ECEE);
const _lightOnSurface = Color(0xFF1B2430);
const _lightOnSurfaceVariant = Color(0xFF5C6670);
const _lightOutline = Color(0xFFD4D9DD);
const _lightOutlineVariant = Color(0xFFE6E9EB);

ThemeData buildLightTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: _lightPrimary).copyWith(
    primary: _lightPrimary,
    onPrimary: Colors.white,
    secondary: _lightSecondary,
    onSecondary: Colors.white,
    surface: _lightBackground,
    onSurface: _lightOnSurface,
    onSurfaceVariant: _lightOnSurfaceVariant,
    surfaceContainerHighest: _lightSurfaceContainerHighest,
    outline: _lightOutline,
    outlineVariant: _lightOutlineVariant,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: _lightBackground,
  );
  final textTheme = _withHeadlineSerif(base.textTheme);
  return base.copyWith(
    textTheme: textTheme,
    // The AppBar's own title (the "Astro STEM Labs" wordmark shown on
    // every page, not just login) defaults to titleLarge, which stays
    // sans on purpose -- explicitly point it at the now-serif
    // headlineSmall instead so the app's most-seen brand moment gets the
    // same treatment as the login page's.
    appBarTheme: AppBarTheme(
      titleTextStyle: textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
    ),
  );
}

/// The same navy/teal identity as the light theme, tuned for a dark
/// surface instead of built from scratch — seeded from the same navy hue
/// ([_lightPrimary]) so [ColorScheme.fromSeed]'s own dark-mode tonal math
/// (not hand-picked guesses) produces a primary/tertiary/container set that
/// actually reads as "the same app, dark version" rather than the generic
/// Material blue this used to fall back to. Only the roles a student
/// actually sees get hand-tuned on top, same philosophy as the light
/// theme: a cool near-black background (not pure grey) and a brightened
/// teal secondary, since teal auto-derived from a navy seed reads as a
/// muted blue-grey rather than the light theme's actual teal accent.
const _darkBackground = Color(0xFF10141A);
const _darkSurfaceContainerHighest = Color(0xFF1E2530);
const _darkOnSurface = Color(0xFFE7ECF2);
const _darkOnSurfaceVariant = Color(0xFF9AA6B4);
const _darkOutline = Color(0xFF3A4451);
const _darkOutlineVariant = Color(0xFF2A323D);
const _darkSecondary = Color(0xFF4DBDBE);
const _darkOnSecondary = Color(0xFF08302F);

ThemeData buildDarkTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: _lightPrimary,
    brightness: Brightness.dark,
  ).copyWith(
    secondary: _darkSecondary,
    onSecondary: _darkOnSecondary,
    surface: _darkBackground,
    onSurface: _darkOnSurface,
    onSurfaceVariant: _darkOnSurfaceVariant,
    surfaceContainerHighest: _darkSurfaceContainerHighest,
    outline: _darkOutline,
    outlineVariant: _darkOutlineVariant,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: _darkBackground,
  );
  final textTheme = _withHeadlineSerif(base.textTheme);
  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      titleTextStyle: textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
    ),
  );
}
