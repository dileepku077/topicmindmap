import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/brand_badge.dart';
import '../../models/admin_student.dart';
import '../../models/profile.dart';
import '../../state/admin_providers.dart';
import '../../state/auth_providers.dart';
import '../../state/profile_providers.dart';
import 'admin_question_editor.dart';

enum _AdminSection { students, questions }

/// Student account management, and the question-bank editor, for admins —
/// the UI half of supabase/schema_admin.sql and
/// supabase/schema_admin_questions.sql. Every action either section takes
/// calls a `security definer` RPC that re-checks admin access itself; this
/// page's own gate (below) is a convenience for everyone else, not the
/// real security boundary.
class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> {
  _AdminSection _section = _AdminSection.students;

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [BrandBadge(size: 28), SizedBox(width: 10), Text('Admin')],
        ),
        // The admin's Home *is* this page (see mindmap_page.dart's own
        // build, which redirects here for any is_admin account before it
        // ever builds the course AppBar an admin would otherwise use for
        // this) — so sign-out and preferences have to live here instead.
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'settings') {
                context.push('/settings');
              } else if (value == 'sign_out') {
                ref.read(supabaseClientProvider).auth.signOut();
              }
            },
            itemBuilder: (context) {
              final email = ref.read(currentUserProvider)?.email;
              return [
                PopupMenuItem(
                  enabled: false,
                  child: Text(email ?? 'Signed in'),
                ),
                const PopupMenuItem(
                  value: 'settings',
                  child: Text('Profile & Preferences'),
                ),
                const PopupMenuItem(value: 'sign_out', child: Text('Sign out')),
              ];
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Failed to load profile: $error')),
        data: (profile) {
          // The real check lives server-side in every RPC this page calls;
          // this just keeps a non-admin from looking at an empty screen
          // full of buttons that would all fail.
          if (profile?.isAdmin != true) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('This page is only available to admin accounts.'),
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SegmentedButton<_AdminSection>(
                    segments: const [
                      ButtonSegment(
                        value: _AdminSection.students,
                        icon: Icon(Icons.people_outline, size: 18),
                        label: Text('Students'),
                      ),
                      ButtonSegment(
                        value: _AdminSection.questions,
                        icon: Icon(Icons.quiz_outlined, size: 18),
                        label: Text('Questions'),
                      ),
                    ],
                    selected: {_section},
                    onSelectionChanged: (selection) =>
                        setState(() => _section = selection.first),
                  ),
                ),
              ),
              Expanded(
                child: _section == _AdminSection.students
                    ? const _StudentList()
                    : const AdminQuestionEditor(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StudentList extends ConsumerStatefulWidget {
  const _StudentList();

  @override
  ConsumerState<_StudentList> createState() => _StudentListState();
}

class _StudentListState extends ConsumerState<_StudentList> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(adminStudentsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: TextField(
            controller: _searchController,
            onChanged: (value) =>
                setState(() => _query = value.trim().toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Search by email',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Clear search',
                      onPressed: () => setState(() {
                        _searchController.clear();
                        _query = '';
                      }),
                    ),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: studentsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) =>
                Center(child: Text('Failed to load students: $error')),
            data: (students) {
              if (students.isEmpty) {
                return const Center(child: Text('No student accounts yet.'));
              }
              final filtered = _query.isEmpty
                  ? students
                  : students
                        .where((s) => s.email.toLowerCase().contains(_query))
                        .toList();
              if (filtered.isEmpty) {
                return Center(child: Text('No student matches "$_query".'));
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) =>
                    _StudentRow(student: filtered[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StudentRow extends ConsumerWidget {
  const _StudentRow({required this.student});

  final AdminStudent student;

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(adminStudentsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final isPro = student.subscriptionTier == SubscriptionTier.pro;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.displayName?.isNotEmpty == true
                      ? student.displayName!
                      : student.email,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  student.email,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _Chip(
                      label: student.grade == null
                          ? 'No grade'
                          : 'Grade ${student.grade}',
                      color: scheme.onSurfaceVariant,
                    ),
                    _Chip(
                      label: isPro ? 'Pro' : 'Free',
                      // Gold reads as "premium tier" more directly than
                      // teal ever did -- see theme.dart's tertiary role.
                      color: isPro ? scheme.tertiary : scheme.onSurfaceVariant,
                      filled: isPro,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final saved = await showDialog<bool>(
                context: context,
                builder: (_) => _EditStudentDialog(student: student),
              );
              if (saved == true) await _refresh(ref);
            },
          ),
          IconButton(
            tooltip: 'Reset password',
            icon: const Icon(Icons.key_outlined),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => _ResetPasswordDialog(student: student),
            ),
          ),
          IconButton(
            tooltip: 'Delete account',
            icon: Icon(Icons.delete_outline, color: scheme.error),
            onPressed: () async {
              final deleted = await showDialog<bool>(
                context: context,
                builder: (_) => _DeleteStudentDialog(student: student),
              );
              if (deleted == true) await _refresh(ref);
            },
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color, this.filled = false});

  final String label;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: filled ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

/// Grade, subscription tier, and display name in one form — the three
/// fields admin_update_student() accepts. Unlike a student's own settings
/// page, Free/Pro is editable here: that's the entire point of this
/// screen existing (see the SubscriptionTier doc comment in profile.dart).
class _EditStudentDialog extends ConsumerStatefulWidget {
  const _EditStudentDialog({required this.student});

  final AdminStudent student;

  @override
  ConsumerState<_EditStudentDialog> createState() => _EditStudentDialogState();
}

class _EditStudentDialogState extends ConsumerState<_EditStudentDialog> {
  late final _nameController = TextEditingController(
    text: widget.student.displayName,
  );
  late int? _grade = widget.student.grade;
  late SubscriptionTier _tier = widget.student.subscriptionTier;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(adminRepositoryProvider)
          .updateStudent(
            studentId: widget.student.id,
            grade: _grade,
            subscriptionTier: _tier,
            displayName: _nameController.text.trim(),
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      setState(() {
        _saving = false;
        _error = 'Could not save: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.student.email}'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Display name'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _grade,
              decoration: const InputDecoration(labelText: 'Grade'),
              items: [
                for (final g in [9, 10, 11, 12])
                  DropdownMenuItem(value: g, child: Text('Grade $g')),
              ],
              onChanged: (value) => setState(() => _grade = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<SubscriptionTier>(
              initialValue: _tier,
              decoration: const InputDecoration(labelText: 'Subscription'),
              items: const [
                DropdownMenuItem(
                  value: SubscriptionTier.free,
                  child: Text('Free'),
                ),
                DropdownMenuItem(
                  value: SubscriptionTier.pro,
                  child: Text('Pro'),
                ),
              ],
              onChanged: (value) => setState(() => _tier = value ?? _tier),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Saving…' : 'Save'),
        ),
      ],
    );
  }
}

class _ResetPasswordDialog extends ConsumerStatefulWidget {
  const _ResetPasswordDialog({required this.student});

  final AdminStudent student;

  @override
  ConsumerState<_ResetPasswordDialog> createState() =>
      _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends ConsumerState<_ResetPasswordDialog> {
  final _passwordController = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final password = _passwordController.text;
    if (password.length < 6) {
      setState(() => _error = 'Minimum 6 characters.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(adminRepositoryProvider)
          .resetPassword(studentId: widget.student.id, newPassword: password);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password updated for ${widget.student.email}."),
        ),
      );
    } catch (error) {
      setState(() {
        _saving = false;
        _error = 'Could not update password: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reset password for ${widget.student.email}'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'New password'),
              onSubmitted: (_) => _save(),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Saving…' : 'Reset password'),
        ),
      ],
    );
  }
}

class _DeleteStudentDialog extends ConsumerStatefulWidget {
  const _DeleteStudentDialog({required this.student});

  final AdminStudent student;

  @override
  ConsumerState<_DeleteStudentDialog> createState() =>
      _DeleteStudentDialogState();
}

class _DeleteStudentDialogState extends ConsumerState<_DeleteStudentDialog> {
  bool _deleting = false;
  String? _error;

  Future<void> _delete() async {
    setState(() {
      _deleting = true;
      _error = null;
    });
    try {
      await ref.read(adminRepositoryProvider).deleteStudent(widget.student.id);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      setState(() {
        _deleting = false;
        _error = 'Could not delete: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.warning_amber_rounded,
        color: Theme.of(context).colorScheme.error,
      ),
      title: const Text('Delete this account?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This permanently deletes ${widget.student.email} and every practice '
            "attempt, medal, and setting on their account. This can't be undone.",
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _deleting ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: _deleting ? null : _delete,
          child: Text(_deleting ? 'Deleting…' : 'Delete account'),
        ),
      ],
    );
  }
}
