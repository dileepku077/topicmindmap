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
  String? _errorMessage;
  /// Sign-up only — which grade's courses this student should see. Sent as
  /// signUp() user metadata so handle_new_user() (schema_practice.sql) can
  /// set profiles.grade in the same insert that creates the profile row;
  /// see curriculum_providers.dart for where that grade then filters which
  /// courses show up.
  int? _selectedGrade;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final client = ref.read(supabaseClientProvider);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      if (_isSignUp) {
        await client.auth.signUp(
          email: email,
          password: password,
          data: {
            'display_name': _nameController.text.trim(),
            'grade': _selectedGrade,
          },
        );
      } else {
        await client.auth
            .signInWithPassword(email: email, password: password);
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
      final showIntro = profile != null && !profile.isAdmin && !profile.hasSeenIntro;
      context.go(showIntro ? '/welcome' : '/');
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
              child: Form(
                key: _formKey,
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
                    Text(
                      _isSignUp
                          ? 'Create an account to see your practice test progress.'
                          : 'Sign in to see your practice test progress.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (_isSignUp) ...[
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        autofillHints: const [AutofillHints.name],
                        decoration: _fieldDecoration(context, 'Full name'),
                        validator: (value) => (value == null || value.trim().isEmpty)
                            ? 'Enter your name'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedGrade,
                        decoration: _fieldDecoration(context, 'Grade'),
                        items: const [9, 10, 11, 12]
                            .map((g) => DropdownMenuItem(value: g, child: Text('Grade $g')))
                            .toList(),
                        // Only your grade's courses show up afterward (see
                        // Profile & Preferences, which is also where this
                        // can be changed later).
                        onChanged: (value) => setState(() => _selectedGrade = value),
                        validator: (value) => value == null ? 'Select your grade' : null,
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: _fieldDecoration(context, 'Email'),
                      validator: (value) => (value == null || !value.contains('@'))
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      decoration: _fieldDecoration(context, 'Password'),
                      validator: (value) => (value == null || value.length < 6)
                          ? 'Minimum 6 characters'
                          : null,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isSignUp ? 'Create account' : 'Sign in'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => setState(() {
                                _isSignUp = !_isSignUp;
                                _errorMessage = null;
                              }),
                      child: Text(_isSignUp
                          ? 'Already have an account? Sign in'
                          : "Don't have an account? Create one"),
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
      border: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide.none),
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
