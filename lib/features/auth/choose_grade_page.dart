import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/brand_badge.dart';
import '../../state/auth_providers.dart';
import '../../state/profile_providers.dart';

/// A one-question interstitial shown in place of the mindmap for any
/// signed-in, non-admin student whose profile has no grade yet -- normally
/// only a Google sign-in, since the email/password form collects grade as
/// part of the signup fields itself (see login_page.dart) and has nowhere
/// to ask for it mid-OAuth-redirect. Picking a grade here is what lets
/// visibleCoursesProvider (curriculum_providers.dart) start filtering
/// courses correctly.
class ChooseGradePage extends ConsumerStatefulWidget {
  const ChooseGradePage({super.key});

  @override
  ConsumerState<ChooseGradePage> createState() => _ChooseGradePageState();
}

class _ChooseGradePageState extends ConsumerState<ChooseGradePage> {
  int? _saving;

  Future<void> _pick(int grade) async {
    final userId = ref.read(currentUserProvider)?.id;
    if (userId == null) return;
    setState(() => _saving = grade);
    await ref.read(profileRepositoryProvider).updateGrade(userId, grade);
    ref.invalidate(profileProvider);
    // No further navigation needed -- invalidating profileProvider makes
    // whichever page is asking (mindmap_page.dart) re-render past this
    // check on its own.
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
                    'Which grade are you in?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "This is the only thing your Google sign-in couldn't "
                    "tell us -- it decides which courses show up for you.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 28),
                  for (final grade in const [9, 10, 11, 12]) ...[
                    OutlinedButton(
                      onPressed: _saving != null ? null : () => _pick(grade),
                      child: _saving == grade
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('Grade $grade'),
                    ),
                    const SizedBox(height: 10),
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
