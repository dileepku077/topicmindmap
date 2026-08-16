import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Named without a leading dot deliberately: some static hosts (e.g.
  // Netlify) refuse to serve files whose name starts with a period,
  // 404ing on the bundled asset and crashing the app before it can render.
  await dotenv.load(fileName: 'app.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    publishableKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const ProviderScope(child: TopicMindmapApp()));
}
