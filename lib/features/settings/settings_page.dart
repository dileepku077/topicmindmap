import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/brand_badge.dart';
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
  const SettingsPage({super.key, this.embedded = false});

  /// True when embedded in the mindmap/classroom main pane instead of
  /// shown as a full-screen route — same convention as PracticeTestPage/
  /// UnitTestPage. Embedded mode skips this widget's own Scaffold/AppBar;
  /// the caller supplies a breadcrumb or back header instead (see
  /// mindmap_page.dart / classroom_view.dart), keeping the sidebar on
  /// screen the whole time.
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isAdmin = ref.watch(profileProvider).value?.isAdmin ?? false;

    final body = ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (user != null) ...[
          Text(user.email ?? 'Signed in', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          if (!isAdmin) ...[const _PlanBadge(), const SizedBox(height: 24)],
        ],
        const _AppearanceSection(),
        const SizedBox(height: 28),
        if (user == null)
          const _SignInPrompt()
        else if (isAdmin)
          const _ChangePasswordSection()
        else ...[
          _GradeSection(userId: user.id),
          const SizedBox(height: 28),
          _DefaultViewSection(userId: user.id),
          const SizedBox(height: 28),
          const _ChangePasswordSection(verifyCurrentPassword: true),
        ],
      ],
    );

    if (embedded) return body;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrandBadge(size: 28),
            SizedBox(width: 10),
            Text('Profile & Preferences'),
          ],
        ),
      ),
      body: body,
    );
  }
}

/// Self-service password change, via the normal Supabase auth.updateUser
/// call (the current session already proves who they are; no admin RPC
/// needed for changing your *own* password). The
/// admin_reset_student_password() RPC in schema_admin.sql is for a
/// *student's* password and deliberately refuses to touch an admin
/// account — this is that other case.
class _ChangePasswordSection extends ConsumerStatefulWidget {
  const _ChangePasswordSection({this.verifyCurrentPassword = false});

  /// When true, a "current password" field is required and checked (via
  /// a signInWithPassword re-auth) before the new password is accepted.
  /// The admin account skips this — it's a single, throwaway-by-design
  /// dev credential (see schema_admin.sql), not worth the extra field.
  final bool verifyCurrentPassword;

  @override
  ConsumerState<_ChangePasswordSection> createState() => _ChangePasswordSectionState();
}

class _ChangePasswordSectionState extends ConsumerState<_ChangePasswordSection> {
  final _currentPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _saving = false;
  String? _error;
  bool _saved = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final currentPassword = _currentPasswordController.text;
    if (widget.verifyCurrentPassword && currentPassword.isEmpty) {
      setState(() {
        _error = 'Enter your current password.';
        _saved = false;
      });
      return;
    }
    final password = _passwordController.text;
    if (password.length < 6) {
      setState(() {
        _error = 'Minimum 6 characters.';
        _saved = false;
      });
      return;
    }
    if (password != _confirmController.text) {
      setState(() {
        _error = "Passwords don't match.";
        _saved = false;
      });
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
      _saved = false;
    });
    final client = ref.read(supabaseClientProvider);
    try {
      if (widget.verifyCurrentPassword) {
        final email = client.auth.currentUser?.email;
        if (email == null) throw Exception('No signed-in account.');
        // signInWithPassword() itself is the check — it throws
        // AuthException on a wrong password without touching anything.
        await client.auth.signInWithPassword(email: email, password: currentPassword);
      }
      await client.auth.updateUser(UserAttributes(password: password));
      if (!mounted) return;
      _currentPasswordController.clear();
      _passwordController.clear();
      _confirmController.clear();
      setState(() {
        _saving = false;
        _saved = true;
      });
    } on AuthException catch (error) {
      setState(() {
        _saving = false;
        _error = widget.verifyCurrentPassword
            ? 'Current password is incorrect.'
            : "Couldn't update password: ${error.message}";
      });
    } catch (error) {
      setState(() {
        _saving = false;
        _error = "Couldn't update password: $error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          widget.verifyCurrentPassword
              ? 'Change your password. You\'ll need to enter your current one first.'
              : 'Change the password for this admin account.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        if (widget.verifyCurrentPassword) ...[
          TextField(
            controller: _currentPasswordController,
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            decoration: const InputDecoration(labelText: 'Current password'),
          ),
          const SizedBox(height: 12),
        ],
        TextField(
          controller: _passwordController,
          obscureText: true,
          autofillHints: const [AutofillHints.newPassword],
          decoration: const InputDecoration(labelText: 'New password'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _confirmController,
          obscureText: true,
          autofillHints: const [AutofillHints.newPassword],
          decoration: const InputDecoration(labelText: 'Confirm new password'),
          onSubmitted: (_) => _save(),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ],
        if (_saved) ...[
          const SizedBox(height: 10),
          Text(
            'Password updated.',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ],
        const SizedBox(height: 14),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Saving…' : 'Update password'),
        ),
      ],
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

/// Shows whether the signed-in student is on Free or Pro. Read-only here —
/// there's no self-serve upgrade yet, so this only ever reflects what an
/// admin has set on the account (see supabase/schema_subscriptions.sql).
class _PlanBadge extends ConsumerWidget {
  const _PlanBadge();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      loading: () => const SizedBox(height: 32),
      error: (error, _) => const SizedBox.shrink(),
      data: (profile) {
        final isPro = profile?.isPro ?? false;
        final color = isPro ? scheme.secondary : scheme.onSurfaceVariant;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPro ? Icons.workspace_premium : Icons.person_outline,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                isPro ? 'Pro plan' : 'Free plan',
                style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13),
              ),
              if (!isPro) ...[
                const SizedBox(width: 8),
                Text(
                  '· Challenge & Advanced questions need Pro',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Which grade's courses show up in the mindmap/classroom course picker
/// (see visibleCoursesProvider in curriculum_providers.dart) — a Grade 10
/// student has no reason to browse Grade 9/11/12 courses. Unset until the
/// student picks one, at which point every course view falls back to
/// showing everything rather than guessing wrong.
class _GradeSection extends ConsumerWidget {
  const _GradeSection({required this.userId});

  final String userId;

  static const _grades = [9, 10, 11, 12];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load profile: $error')),
      data: (profile) {
        final grade = profile?.grade;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Grade', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Astro STEM Labs only shows courses for your own grade once '
              "you've picked one below.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: grade,
                  isExpanded: true,
                  hint: const Text('Choose your grade'),
                  items: [
                    for (final g in _grades)
                      DropdownMenuItem(value: g, child: Text('Grade $g')),
                  ],
                  onChanged: (value) {
                    if (value != null) _setGrade(context, ref, value);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _setGrade(BuildContext context, WidgetRef ref, int grade) async {
    try {
      await ref.read(profileRepositoryProvider).updateGrade(userId, grade);
      ref.invalidate(profileProvider);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't save your grade: $error")),
      );
    }
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
              "What you see first when you open Astro STEM Labs. Both show the "
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
