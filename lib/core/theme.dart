import 'package:flutter/material.dart';

const _seedColor = Color(0xFF5B8DEF);

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
