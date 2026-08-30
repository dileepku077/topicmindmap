import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/brand_badge.dart';
import '../../state/auth_providers.dart';
import '../../state/profile_providers.dart';

/// A short form shown in place of the mindmap for any signed-in, non-admin
/// student missing grade and/or age -- both are things a "Continue with
/// Google" sign-in has no signup-form step to collect during the OAuth
/// redirect (see login_page.dart), unlike the email/password form, which
/// asks for both up front. Whichever of the two is missing is asked here,
/// together, behind a single submit -- mindmap_page.dart recomputes
/// [needsGrade]/[needsAge] from the profile on every rebuild, so this page
/// simply stops appearing once both are set.
class CompleteProfilePage extends ConsumerStatefulWidget {
  const CompleteProfilePage({
    super.key,
    required this.needsGrade,
    required this.needsAge,
  });

  final bool needsGrade;
  final bool needsAge;

  @override
  ConsumerState<CompleteProfilePage> createState() =>
      _CompleteProfilePageState();
}

class _CompleteProfilePageState extends ConsumerState<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedGrade;
  int? _selectedAge;
  bool _saving = false;

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final userId = ref.read(currentUserProvider)?.id;
    if (userId == null) return;

    setState(() => _saving = true);
    final repo = ref.read(profileRepositoryProvider);
    final grade = _selectedGrade;
    final age = _selectedAge;
    if (widget.needsGrade && grade != null) {
      await repo.updateGrade(userId, grade);
    }
    if (widget.needsAge && age != null) {
      await repo.updateAge(userId, age);
    }
    ref.invalidate(profileProvider);
    // No further navigation needed -- mindmap_page.dart re-evaluates
    // needsGrade/needsAge once profileProvider resolves and stops showing
    // this page on its own. Not resetting _saving on success: this widget
    // is about to be replaced, not left showing a re-enabled button.
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final askingBoth = widget.needsGrade && widget.needsAge;
    return Scaffold(
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
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: BrandBadge()),
                    const SizedBox(height: 18),
                    Text(
                      askingBoth ? 'Just two quick things' : 'One quick thing',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "This is the only thing your Google sign-in couldn't "
                      'tell us -- grade decides which courses show up for '
                      'you, and age is just to keep the app '
                      'age-appropriate.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    if (widget.needsGrade) ...[
                      DropdownButtonFormField<int>(
                        initialValue: _selectedGrade,
                        decoration: _fieldDecoration(context, 'Grade'),
                        items: const [9, 10, 11, 12]
                            .map(
                              (g) =>
                                  DropdownMenuItem(value: g, child: Text('$g')),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedGrade = value),
                        validator: (value) =>
                            value == null ? 'Select your grade' : null,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (widget.needsAge) ...[
                      DropdownButtonFormField<int>(
                        initialValue: _selectedAge,
                        decoration: _fieldDecoration(context, 'Age'),
                        items: [
                          for (var a = 14; a <= 20; a++)
                            DropdownMenuItem(value: a, child: Text('$a')),
                        ],
                        onChanged: (value) =>
                            setState(() => _selectedAge = value),
                        validator: (value) =>
                            value == null ? 'Select your age' : null,
                      ),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: _saving ? null : _submit,
                      child: _saving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Continue'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Matches login_page.dart's field styling -- duplicated rather than
  /// shared since it's a two-line decoration builder, not worth a new
  /// shared utility file for.
  InputDecoration _fieldDecoration(BuildContext context, String label) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(12);
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: scheme.surfaceContainerHigh,
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
    );
  }
}
