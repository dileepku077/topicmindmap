import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/brand_badge.dart';
import '../../state/auth_providers.dart';
import '../../state/profile_providers.dart';

/// A short interstitial shown in place of the mindmap for any signed-in,
/// non-admin student missing grade and/or age -- both are things a "Continue
/// with Google" sign-in has no signup-form step to collect during the OAuth
/// redirect (see login_page.dart), unlike the email/password form, which
/// asks for both up front. Each question saves and disappears independently
/// as soon as it's answered (see [_pickGrade]/[_pickAge]) rather than
/// waiting on a single "submit" for both -- mindmap_page.dart recomputes
/// [needsGrade]/[needsAge] from the profile on every rebuild, so answering
/// one just narrows this down to whatever's still missing.
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
  int? _savingGrade;
  int? _savingAge;

  Future<void> _pickGrade(int grade) async {
    final userId = ref.read(currentUserProvider)?.id;
    if (userId == null) return;
    setState(() => _savingGrade = grade);
    await ref.read(profileRepositoryProvider).updateGrade(userId, grade);
    ref.invalidate(profileProvider);
  }

  Future<void> _pickAge(int age) async {
    final userId = ref.read(currentUserProvider)?.id;
    if (userId == null) return;
    setState(() => _savingAge = age);
    await ref.read(profileRepositoryProvider).updateAge(userId, age);
    ref.invalidate(profileProvider);
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: BrandBadge()),
                  const SizedBox(height: 18),
                  Text(
                    askingBoth
                        ? "Just two quick things"
                        : widget.needsGrade
                        ? 'Which grade are you in?'
                        : 'How old are you?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "This is the only thing your Google sign-in couldn't "
                    'tell us -- grade decides which courses show up for '
                    'you, and age is just to keep the app age-appropriate.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (widget.needsGrade) ...[
                    const SizedBox(height: 28),
                    Text(
                      'Grade',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 10),
                    for (final grade in const [9, 10, 11, 12]) ...[
                      OutlinedButton(
                        onPressed: _savingGrade != null
                            ? null
                            : () => _pickGrade(grade),
                        child: _savingGrade == grade
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text('Grade $grade'),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                  if (widget.needsAge) ...[
                    const SizedBox(height: 18),
                    Text('Age', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 10),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (var age = 14; age <= 20; age++)
                          OutlinedButton(
                            onPressed: _savingAge != null
                                ? null
                                : () => _pickAge(age),
                            child: _savingAge == age
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text('$age'),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
