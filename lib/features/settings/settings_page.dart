import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/profile.dart';
import '../../state/auth_providers.dart';
import '../../state/profile_providers.dart';
import '../../state/theme_providers.dart';

/// Profile and preferences: appearance (light/dark/system, available to
/// everyone including guests — it's a display setting, not tied to an
/// account) and, once signed in, which screen a student sees first, the
/// spatial mindmap or the classroom view (left-hand unit navigation + a
/// resume-where-you-left-off dashboard, classroom_view.dart). Both views
/// show the same curriculum and progress; that preference only decides
/// what loads first.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Preferences')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (user != null) ...[
            Text(user.email ?? 'Signed in', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
          ],
          const _AppearanceSection(),
          const SizedBox(height: 28),
          if (user == null)
            const _SignInPrompt()
          else
            _DefaultViewSection(userId: user.id),
        ],
      ),
    );
  }
}

class _AppearanceSection extends ConsumerWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          'Choose light, dark, or match your device.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        _OptionTile(
          icon: Icons.brightness_auto_outlined,
          title: 'System',
          subtitle: "Follows your device's setting.",
          selected: themeMode == ThemeMode.system,
          onTap: () => ref.read(themeModeProvider.notifier).set(ThemeMode.system),
        ),
        const SizedBox(height: 10),
        _OptionTile(
          icon: Icons.light_mode_outlined,
          title: 'Light',
          subtitle: 'A bright, clean theme.',
          selected: themeMode == ThemeMode.light,
          onTap: () => ref.read(themeModeProvider.notifier).set(ThemeMode.light),
        ),
        const SizedBox(height: 10),
        _OptionTile(
          icon: Icons.dark_mode_outlined,
          title: 'Dark',
          subtitle: 'Dim and easy on the eyes.',
          selected: themeMode == ThemeMode.dark,
          onTap: () => ref.read(themeModeProvider.notifier).set(ThemeMode.dark),
        ),
      ],
    );
  }
}

class _DefaultViewSection extends ConsumerWidget {
  const _DefaultViewSection({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load profile: $error')),
      data: (profile) {
        final defaultView = profile?.defaultView ?? DefaultView.mindmap;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Default view', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              "What you see first when you open Astro Math. Both show the "
              'same topics and progress — pick whichever you read faster.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            _OptionTile(
              icon: Icons.hub_outlined,
              title: 'Mindmap',
              subtitle: 'A branching map you pan and zoom around.',
              selected: defaultView == DefaultView.mindmap,
              onTap: () => _setDefaultView(context, ref, DefaultView.mindmap),
            ),
            const SizedBox(height: 10),
            _OptionTile(
              icon: Icons.account_tree_outlined,
              title: 'Classroom',
              subtitle: 'A unit list on the left and a dashboard that '
                  'picks up where you left off.',
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

/// One radio-style preference row — icon, title, subtitle, and a trailing
/// selected/unselected marker — shared by the appearance and default-view
/// sections above since both are "pick one of a few options" lists.
class _OptionTile extends StatelessWidget {
  const _OptionTile({
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sign in to set your default view.'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.push('/login'),
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }
}
