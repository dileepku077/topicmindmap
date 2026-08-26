import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/admin/admin_page.dart';
import '../features/auth/login_page.dart';
import '../features/lesson/lesson_page.dart';
import '../features/mindmap/mindmap_page.dart';
import '../features/practice_test/practice_test_page.dart';
import '../features/settings/settings_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MindmapPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminPage(),
      ),
      GoRoute(
        path: '/lesson/:lessonId',
        builder: (context, state) =>
            LessonPage(lessonId: state.pathParameters['lessonId']!),
      ),
      // courseCode/unitCode/subtopicCode, not the subtopic's uuid — that's
      // the natural key the practice-test database functions take; see
      // supabase/schema_practice.sql. subtopicTitle rides along as a query
      // param purely for display (the AppBar title), never looked up by it.
      GoRoute(
        path: '/practice/:courseCode/:unitCode/:subtopicCode',
        builder: (context, state) => PracticeTestPage(
          courseCode: state.pathParameters['courseCode']!,
          unitCode: state.pathParameters['unitCode']!,
          subtopicCode: state.pathParameters['subtopicCode']!,
          subtopicTitle:
              state.uri.queryParameters['title'] ?? 'Practice Test',
        ),
      ),
    ],
  );
});
