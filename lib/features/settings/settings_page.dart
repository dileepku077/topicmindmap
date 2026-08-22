import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/profile.dart';
import '../../state/auth_providers.dart';
import '../../state/profile_providers.dart';

/// Profile and preferences — currently just the one preference: which
/// screen a student sees first, the spatial mindmap or the flat
/// classroom-style list (topic_tree_view.dart). Both show the same
/// curriculum and progress; this only decides what loads first.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Preferences')),
      body: user == null
          ? const _SignInPrompt()
          : _PreferencesBody(userId: user.id, email: user.email),
    );
  }
}

class _PreferencesBody extends ConsumerWidget {
  const _PreferencesBody({required this.userId, required this.email});

  final String userId;
  final String? email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load profile: $error')),
      data: (profile) {
        final defaultView = profile?.defaultView ?? DefaultView.mindmap;
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(email ?? 'Signed in', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            Text('Default view', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              "What you see first when you open Astro Math. Both show the "
              'same topics and progress — pick whichever you read faster.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            _ViewOptionTile(
              icon: Icons.hub_outlined,
              title: 'Mindmap',
              subtitle: 'A branching map you pan and zoom around.',
              selected: defaultView == DefaultView.mindmap,
              onTap: () => _setDefaultView(context, ref, DefaultView.mindmap),
            ),
            const SizedBox(height: 10),
            _ViewOptionTile(
              icon: Icons.account_tree_outlined,
              title: 'Classroom list',
              subtitle: 'A plain top-to-bottom outline of units and topics.',
              selected: defaultView == DefaultView.classroom,
              onTap: () => _setDefaultView(context, ref, DefaultView.classroom),
            ),
          ],
        );
      },
    );
  }

  Future<void> _setDefaultView(
    BuildContext context,
    WidgetRef ref,
    DefaultView view,
  ) async {
    try {
      await ref.read(profileRepositoryProvider).updateDefaultView(userId, view);
      ref.invalidate(profileProvider);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't save your preference: $error")),
      );
    }
  }
}

class _ViewOptionTile extends StatelessWidget {
  const _ViewOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.primary : scheme.outlineVariant;
    return Material(
      color: selected ? scheme.primary.withValues(alpha: 0.08) : null,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: selected ? 1.5 : 1),
          ),
          child: Row(
            children: [
              Icon(icon, color: selected ? scheme.primary : scheme.onSurfaceVariant),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: selected ? scheme.primary : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: selected ? scheme.primary : scheme.outlineVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignInPrompt extends StatelessWidget {
  const _SignInPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Sign in to set your preferences.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.push('/login'),
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
