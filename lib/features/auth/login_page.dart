import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/brand_badge.dart';
import '../../state/auth_providers.dart';
import '../../state/profile_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isSignUp = false;
  bool _isSubmitting = false;
  bool _isResending = false;
  String? _errorMessage;

  /// Set once a sign-in attempt fails specifically because the account's
  /// email hasn't been confirmed yet — shown as a "resend the link"
  /// action alongside the normal error text, rather than just a dead end.
  String? _unconfirmedEmail;

  /// Set right after a successful signUp() call that returned no session
  /// — i.e. "Confirm email" is on in the Supabase dashboard and this
  /// student needs to click the link in their inbox before they can sign
  /// in at all. Non-null replaces the whole form with a "check your
  /// email" screen; there's nothing left to submit until that happens.
  String? _pendingConfirmationEmail;

  /// Sign-up only — which grade's courses this student should see. Sent as
  /// signUp() user metadata so handle_new_user() (schema_practice.sql) can
  /// set profiles.grade in the same insert that creates the profile row;
  /// see curriculum_providers.dart for where that grade then filters which
  /// courses show up.
  int? _selectedGrade;

  /// Sign-up only — this app is built for Ontario high-school students, so
  /// the form won't submit outside a 14-20 range (see
  /// supabase/schema_age_check.sql, which enforces the same floor/ceiling
  /// server-side). A dropdown rather than a free-text field, same reasoning
  /// as grade: it can't produce an out-of-range value in the first place.
  int? _selectedAge;

  final _termsTapRecognizer = TapGestureRecognizer();
  final _privacyTapRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    _termsTapRecognizer.onTap = () => context.push('/terms');
    _privacyTapRecognizer.onTap = () => context.push('/privacy');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _termsTapRecognizer.dispose();
    _privacyTapRecognizer.dispose();
    super.dispose();
  }

  /// The origin (scheme + host + port) this page is currently served
  /// from — used as the email confirmation link's redirect target so it
  /// lands back on whichever deployment sent it (production, or a local
  /// dev server) instead of a hard-coded URL.
  String get _redirectOrigin => Uri.base.origin;

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
      _unconfirmedEmail = null;
    });

    final client = ref.read(supabaseClientProvider);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      if (_isSignUp) {
        final response = await client.auth.signUp(
          email: email,
          password: password,
          data: {
            'display_name': _nameController.text.trim(),
            'grade': _selectedGrade,
            'age': _selectedAge,
          },
          emailRedirectTo: _redirectOrigin,
        );

        // No session back means "Confirm email" is on in the Supabase
        // dashboard and this account can't sign in yet — there's nothing
        // to route into the app with, so show a "check your email" screen
        // instead of the usual post-sign-up redirect.
        if (response.session == null) {
          if (!mounted) return;
          setState(() {
            _pendingConfirmationEmail = email;
            _isSubmitting = false;
          });
          return;
        }

        // Confirmation is off (or this account was pre-confirmed some
        // other way) -- signed in immediately, same as before confirmation
        // existed. Belt-and-suspenders: handle_new_user()
        // (schema_practice.sql) also reads grade out of the metadata
        // above, but that only takes effect once that SQL has been
        // (re-)run against the database. Setting it directly here too —
        // the same profiles table update Settings' own grade dropdown
        // already uses — means a new student's grade (and therefore which
        // courses visibleCoursesProvider shows them, see
        // curriculum_providers.dart) is correct from their very first
        // sign-in regardless of whether that SQL step happened.
        final newUserId = response.user?.id;
        final grade = _selectedGrade;
        final age = _selectedAge;
        if (newUserId != null && grade != null) {
          await ref
              .read(profileRepositoryProvider)
              .updateGrade(newUserId, grade);
        }
        if (newUserId != null && age != null) {
          await ref.read(profileRepositoryProvider).updateAge(newUserId, age);
        }
      } else {
        await client.auth.signInWithPassword(email: email, password: password);
      }
      if (!mounted) return;
      // A brand-new sign-up's profile row is always fresh (has_seen_intro
      // defaults false), and an existing account that predates this
      // feature reads false the same way — either way, first sign-in
      // after this shipped goes to the tour once. Admins skip it: they're
      // routed straight to the admin screen anyway (see mindmap_page.dart)
      // and have no student-facing features to be walked through.
      final userId = client.auth.currentUser?.id;
      final profile = userId == null
          ? null
          : await ref.read(profileRepositoryProvider).fetchProfile(userId);
      if (!mounted) return;
      final showIntro =
          profile != null && !profile.isAdmin && !profile.hasSeenIntro;
      context.go(showIntro ? '/welcome' : '/');
    } on AuthException catch (e) {
      final unconfirmed = !_isSignUp && _looksLikeUnconfirmedEmail(e);
      setState(() {
        _errorMessage = unconfirmed
            ? "This account's email hasn't been confirmed yet."
            : e.message;
        _unconfirmedEmail = unconfirmed ? email : null;
      });
    } catch (e) {
      setState(() => _errorMessage = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  /// Lets a student use their existing Google account instead of choosing
  /// yet another password. Supabase treats first-time and returning
  /// Google sign-ins identically -- there's no separate "sign up" step to
  /// wire up here, this same button handles both.
  Future<void> _continueWithGoogle() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await ref
          .read(supabaseClientProvider)
          .auth
          .signInWithOAuth(OAuthProvider.google, redirectTo: _redirectOrigin);
      // On web this navigates the whole page to Google's consent screen --
      // nothing meaningful happens after this line runs. The eventual
      // redirect back is handled by Supabase's own session-from-URL
      // recovery on startup, the same mechanism that already handles the
      // email confirmation link.
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  bool _looksLikeUnconfirmedEmail(AuthException e) {
    final message = e.message.toLowerCase();
    return message.contains('not confirmed') ||
        message.contains('email_not_confirmed');
  }

  Future<void> _resendConfirmation(String email) async {
    setState(() => _isResending = true);
    try {
      await ref
          .read(supabaseClientProvider)
          .auth
          .resend(
            type: OtpType.signup,
            email: email,
            emailRedirectTo: _redirectOrigin,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Confirmation email resent to $email.')),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't resend the email: ${e.message}")),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
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
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: BrandBadge()),
                  const SizedBox(height: 18),
                  Text(
                    'Astro STEM Labs',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Makes STEM learning fun and exciting',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: brandCoral,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (_pendingConfirmationEmail case final email?)
                    _ConfirmationPendingView(
                      email: email,
                      isResending: _isResending,
                      onResend: () => _resendConfirmation(email),
                      onBackToSignIn: () => setState(() {
                        _pendingConfirmationEmail = null;
                        _isSignUp = false;
                      }),
                    )
                  else
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _isSignUp
                                ? 'Create an account to see your practice test progress.'
                                : 'Sign in to see your practice test progress.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          OutlinedButton(
                            onPressed: _isSubmitting
                                ? null
                                : _continueWithGoogle,
                            child: const Text('Continue with Google'),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: scheme.outlineVariant),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  'or',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              Expanded(
                                child: Divider(color: scheme.outlineVariant),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (_isSignUp) ...[
                            TextFormField(
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              autofillHints: const [AutofillHints.name],
                              decoration: _fieldDecoration(
                                context,
                                'Full name',
                              ),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty)
                                  ? 'Enter your name'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<int>(
                              initialValue: _selectedGrade,
                              decoration: _fieldDecoration(context, 'Grade'),
                              items: const [9, 10, 11, 12]
                                  .map(
                                    (g) => DropdownMenuItem(
                                      value: g,
                                      child: Text('Grade $g'),
                                    ),
                                  )
                                  .toList(),
                              // Only your grade's courses show up afterward (see
                              // Profile & Preferences, which is also where this
                              // can be changed later).
                              onChanged: (value) =>
                                  setState(() => _selectedGrade = value),
                              validator: (value) =>
                                  value == null ? 'Select your grade' : null,
                            ),
                            const SizedBox(height: 12),
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
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            decoration: _fieldDecoration(context, 'Email'),
                            validator: (value) =>
                                (value == null || !value.contains('@'))
                                ? 'Enter a valid email'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            autofillHints: const [AutofillHints.password],
                            decoration: _fieldDecoration(context, 'Password'),
                            validator: (value) =>
                                (value == null || value.length < 6)
                                ? 'Minimum 6 characters'
                                : null,
                            onFieldSubmitted: (_) => _submit(),
                          ),
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                          if (_unconfirmedEmail case final email?) ...[
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: _isResending
                                    ? null
                                    : () => _resendConfirmation(email),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  _isResending
                                      ? 'Sending…'
                                      : 'Resend confirmation email',
                                ),
                              ),
                            ),
                          ],
                          if (_isSignUp) ...[
                            const SizedBox(height: 14),
                            _TermsNotice(
                              termsRecognizer: _termsTapRecognizer,
                              privacyRecognizer: _privacyTapRecognizer,
                            ),
                          ],
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: _isSubmitting ? null : _submit,
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _isSignUp ? 'Create account' : 'Sign in',
                                  ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => setState(() {
                                    _isSignUp = !_isSignUp;
                                    _errorMessage = null;
                                  }),
                            child: Text(
                              _isSignUp
                                  ? 'Already have an account? Sign in'
                                  : "Don't have an account? Create one",
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Rounded, bordered fields matching the tile language used everywhere
  /// else in the app (settings' `_OptionTile`, practice test's option
  /// rows) instead of Material's plain underline default.
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

/// "By creating an account, you agree to..." shown only at sign-up, with
/// Terms of Service / Privacy Policy as inline tap targets rather than a
/// separate checkbox -- both routes (see app_router.dart) are reachable
/// without signing in, so a prospective student or parent can read them
/// before ever submitting the form.
class _TermsNotice extends StatelessWidget {
  const _TermsNotice({
    required this.termsRecognizer,
    required this.privacyRecognizer,
  });

  final TapGestureRecognizer termsRecognizer;
  final TapGestureRecognizer privacyRecognizer;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final baseStyle = Theme.of(context).textTheme.bodySmall
        ?.copyWith(color: scheme.onSurfaceVariant);
    final linkStyle = baseStyle?.copyWith(
      color: scheme.primary,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    );
    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          const TextSpan(text: 'By creating an account, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: linkStyle,
            recognizer: termsRecognizer,
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: linkStyle,
            recognizer: privacyRecognizer,
          ),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Replaces the sign-up form entirely once signUp() comes back with no
/// session — meaning Supabase's "Confirm email" setting is on and this
/// account can't do anything in the app until the student opens the link
/// mailed to them. There's nothing left to submit at this point, so this
/// is a dead end with two ways out: wait for the email (with a resend in
/// case it didn't arrive), or back out to try signing in with a different
/// account.
class _ConfirmationPendingView extends StatelessWidget {
  const _ConfirmationPendingView({
    required this.email,
    required this.isResending,
    required this.onResend,
    required this.onBackToSignIn,
  });

  final String email;
  final bool isResending;
  final VoidCallback onResend;
  final VoidCallback onBackToSignIn;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.mark_email_unread_outlined, size: 56, color: scheme.primary),
        const SizedBox(height: 16),
        Text(
          'Check your email',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'We sent a confirmation link to $email. Open it on your phone or '
          'computer, then come back here and sign in.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: isResending ? null : onResend,
          child: Text(
            isResending ? 'Sending…' : "Didn't get it? Resend the email",
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onBackToSignIn,
          child: const Text('Back to sign in'),
        ),
      ],
    );
  }
}
