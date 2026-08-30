import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsKey = 'theme_mode';

/// Light/dark/system preference for the whole app. Kept in local storage
/// rather than the student's Supabase profile (unlike [DefaultView]): a
/// screen's colors apply the moment they're picked and work the same for
/// a signed-out guest as a signed-in student, so there's no reason to
/// round-trip it through an account that may not exist yet. Light is the
/// default until a student picks something else in Profile & Preferences;
/// nothing stored yet reads the same as `null` from SharedPreferences, so
/// this only ever overrides "never touched this setting" -- an explicit
/// past choice of System is stored as the literal string 'system' and
/// still matches on the line below.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _load();
    return ThemeMode.light;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    state = ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.light,
    );
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
