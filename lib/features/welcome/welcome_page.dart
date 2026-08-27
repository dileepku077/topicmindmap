import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/brand_badge.dart';
import '../../state/auth_providers.dart';
import '../../state/profile_providers.dart';

/// A one-screen tour of the app's own features, shown automatically the
/// first time a student signs in (see the redirect in login_page.dart,
/// driven by profiles.has_seen_intro) and reachable afterward any time via
/// "How to use this app" in the sidebar (curriculum_sidebar.dart). Static
/// content only — no per-student data — so it's cheap to keep a plain
/// StatelessWidget-ish page rather than something driven by providers.
class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  @override
  void initState() {
    super.initState();
    // "Seen" means shown, not "read to the end and clicked a button" — mark
    // it the moment the page opens, whether that's the automatic first-time
    // redirect or a student revisiting from the sidebar later (harmless
    // no-op the second time onward).
    final userId = ref.read(currentUserProvider)?.id;
    if (userId != null) {
      ref.read(profileRepositoryProvider).markIntroSeen(userId).then((_) {
        ref.invalidate(profileProvider);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrandBadge(size: 28),
            SizedBox(width: 10),
            Text('How to use Astro STEM Labs'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [scheme.surface, scheme.surfaceContainerHighest],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              children: [
                Text(
                  'Welcome! Here\'s what you can do',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'A quick tour of the app — come back to this page any time from '
                  '"How to use this app" in the sidebar.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                const _FeatureCard(
                  icon: Icons.hub_outlined,
                  title: 'Mindmap view',
                  body:
                      'Your course laid out as a map — tap a unit to fan out its '
                      'topics, tap a topic to open it. Drag to pan, scroll or pinch '
                      'to zoom, and use "Reset view" in the top bar to re-centre.',
                ),
                const _FeatureCard(
                  icon: Icons.account_tree_outlined,
                  title: 'Classroom view',
                  body:
                      'The same course as a straightforward list instead of a map. '
                      'Switch between the two any time with the toggle next to the '
                      'app title — pick whichever you find easier to navigate.',
                ),
                const _FeatureCard(
                  icon: Icons.menu_book_outlined,
                  title: 'Lessons',
                  body:
                      'Each topic has a short lesson covering the theory before you '
                      'practice it — open it from that topic\'s page.',
                ),
                const _FeatureCard(
                  icon: Icons.edit_note_outlined,
                  title: 'Practice Test',
                  body:
                      'Drill one topic at a time, picking Easy, Medium, Hard or '
                      'Advanced. You see whether each answer is right immediately, '
                      'and you can retry as often as you like. Getting every '
                      'question right on your first try earns that topic a medal.',
                ),
                const _FeatureCard(
                  icon: Icons.fact_check_outlined,
                  title: 'Take a mock test',
                  body:
                      'From a unit\'s page, take a graded paper covering every topic '
                      'in it at once. Answers are locked in as you go and nothing is '
                      'revealed — not even whether you were right — until you hand '
                      'the whole paper in. It never changes your medals or mindmap '
                      'colours; it\'s just a checkpoint.',
                ),
                const _FeatureCard(
                  icon: Icons.emoji_events_outlined,
                  title: 'Medals and progress',
                  body:
                      'A topic\'s icon and colour on the mindmap and sidebar show '
                      'where you stand: not started, in progress, or mastered. '
                      'Medals (bronze/silver/gold) reward getting a topic right '
                      'the first time, without needing a retry.',
                ),
                const _FeatureCard(
                  icon: Icons.menu_outlined,
                  title: 'The sidebar',
                  body:
                      'Jump straight to any unit or topic from the list on the '
                      'left. Tap the arrow at its top to shrink it to icons only '
                      'when you want more room, or expand it again any time.',
                ),
                const _FeatureCard(
                  icon: Icons.lock_outline,
                  title: 'Free vs. Pro',
                  body:
                      'Every account can practice Easy and Medium questions. '
                      'Hard, Challenge, and Advanced questions unlock on a Pro '
                      'subscription — ask your teacher/parent about upgrading.',
                ),
                const _FeatureCard(
                  icon: Icons.person_outline,
                  title: 'Profile & Preferences',
                  body:
                      'Change your grade, your password, or which view (mindmap '
                      'or classroom) opens by default — from the account menu or '
                      'the sidebar.',
                ),
                const SizedBox(height: 12),
                Center(
                  child: FilledButton.icon(
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Go to my courses'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: scheme.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(body, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
