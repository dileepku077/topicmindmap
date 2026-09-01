import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Named without a leading dot deliberately: some static hosts (e.g.
  // Netlify) refuse to serve files whose name starts with a period,
  // 404ing on the bundled asset and crashing the app before it can render.
  await dotenv.load(fileName: 'app.env');

  // A Sentry DSN identifies where crash reports go, not a credential --
  // it's meant to ship in client-side code (this is exactly how every
  // Sentry browser/mobile SDK works), unlike SUPABASE_ANON_KEY's own
  // security model which relies on RLS rather than secrecy either way.
  // Still read from app.env rather than hardcoded so a local dev build
  // with no DSN configured yet just runs without Sentry (see below)
  // instead of every contributor's laptop reporting into one project.
  final sentryDsn = dotenv.env['SENTRY_DSN'] ?? '';

  Future<void> initSupabaseAndRun() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      publishableKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );
    runApp(const ProviderScope(child: TopicMindmapApp()));
  }

  if (sentryDsn.isEmpty) {
    await initSupabaseAndRun();
    return;
  }

  await SentryFlutter.init((options) {
    options.dsn = sentryDsn;
    // 'development' when run via `flutter run`/tests, so a Sentry
    // dashboard filter can separate real student sessions from local
    // testing hitting the same DSN.
    options.environment = kReleaseMode ? 'production' : 'development';
  }, appRunner: initSupabaseAndRun);
}
