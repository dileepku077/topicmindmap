import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/admin/admin_page.dart';
import '../features/auth/login_page.dart';
import '../features/legal/legal_page.dart';
import '../features/lesson/lesson_page.dart';
import '../features/mindmap/mindmap_page.dart';
import '../features/practice_test/practice_test_page.dart';
import '../features/progress_report/progress_report_page.dart';
import '../features/settings/settings_page.dart';
import '../features/unit_test/unit_test_page.dart';
import '../features/welcome/welcome_page.dart';
import '../state/auth_providers.dart';

/// Course content (the mindmap/classroom home, lessons, practice tests,
/// settings, admin) is for signed-in accounts only — every route except
/// `/login`, `/privacy`, and `/terms` redirects there if nobody's signed
/// in, and `/login` itself redirects away once somebody is (no reason to
/// show the sign-in form to an already-signed-in session; the legal pages
/// stay reachable either way, since a signed-in student can revisit them
/// from Settings). This is the single place that rule lives; individual
/// pages no longer need their own "sign in to see this" fallback for it
/// to actually be enforced navigation-wise.
final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshStream = _GoRouterRefreshStream(
    ref.watch(supabaseClientProvider).auth.onAuthStateChange,
  );
  ref.onDispose(refreshStream.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshStream,
    redirect: (context, state) {
      final loggedIn =
          ref.read(supabaseClientProvider).auth.currentUser != null;
      final onLoginPage = state.matchedLocation == '/login';
      const publicPaths = {'/login', '/privacy', '/terms'};
      if (!loggedIn && !publicPaths.contains(state.matchedLocation)) {
        return '/login';
      }
      if (loggedIn && onLoginPage) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MindmapPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const TermsOfServicePage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressReportPage(),
      ),
      GoRoute(path: '/admin', builder: (context, state) => const AdminPage()),
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
          subtopicTitle: state.uri.queryParameters['title'] ?? 'Practice Test',
        ),
      ),
      // courseCode/unitCode, not the unit's uuid — same natural-key
      // reasoning as the practice route above. unitTitle rides along as a
      // query param purely for display.
      GoRoute(
        path: '/unit-test/:courseCode/:unitCode',
        builder: (context, state) => UnitTestPage(
          courseCode: state.pathParameters['courseCode']!,
          unitCode: state.pathParameters['unitCode']!,
          unitTitle: state.uri.queryParameters['title'] ?? 'Unit Test',
        ),
      ),
    ],
  );
});

/// Turns the Supabase auth stream into the `Listenable` GoRouter's
/// `refreshListenable` wants, so a sign-in or sign-out re-runs the
/// `redirect` callback above immediately instead of only on the next
/// manual navigation.
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
