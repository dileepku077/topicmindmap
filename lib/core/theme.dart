import 'package:flutter/material.dart';

const _seedColor = Color(0xFF5B8DEF);

/// Explicit (not seed-generated) light palette, matched by eye to the
/// co-developer's math-tutor app (math-tutortesting.netlify.app): a warm
/// cream canvas rather than Material's own cooler auto-generated light
/// tones, deep indigo for headings/primary actions, and forest green for
/// selected/active state. Only the roles that are actually visible
/// elsewhere in the app are overridden; everything else comes from
/// [ColorScheme.fromSeed] on the same indigo so unset roles (containers,
/// inverse surfaces, etc.) still form one coherent Material 3 palette
/// instead of defaulting to something unrelated.
const _lightPrimary = Color(0xFF32409A);
const _lightSecondary = Color(0xFF1E4B3A);
const _lightBackground = Color(0xFFF5F1E9);
const _lightSurfaceContainerHighest = Color(0xFFEBE6D9);
const _lightOnSurface = Color(0xFF2A2823);
const _lightOnSurfaceVariant = Color(0xFF79766C);
const _lightOutline = Color(0xFFDBD5C6);
const _lightOutlineVariant = Color(0xFFEAE5D8);

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
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: _lightBackground,
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
  );
}
