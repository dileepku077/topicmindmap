import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../state/auth_providers.dart';

/// The gold-to-coral gradient and near-black badge below are lifted
/// straight from the astrostemlabs.com wordmark (a black square, a
/// gold/orange rocket, "Trust Science" underneath) — this is the one
/// screen in the app that's explicitly the company's front door rather
/// than the math app's own navy/teal system, so it gets the parent
/// brand's marks instead of blending into the rest of the app.
const _brandBadgeColor = Color(0xFF12192B);
const _brandGradient = LinearGradient(
  colors: [Color(0xFFF4A93B), Color(0xFFE8604C)],
);
const _brandCoral = Color(0xFFE8604C);

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSignUp = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
        await client.auth.signUp(email: email, password: password);
      } else {
        await client.auth
            .signInWithPassword(email: email, password: password);
      }
      if (mounted) context.go('/');
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
                    const Center(child: _BrandBadge()),
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
                      'TRUST SCIENCE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _brandCoral,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 2.2,
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
                    TextButton(
                      onPressed: _isSubmitting ? null : () => context.go('/'),
                      child: const Text('Continue as guest'),
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

class _BrandBadge extends StatelessWidget {
  const _BrandBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: _brandBadgeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _brandCoral.withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => _brandGradient.createShader(bounds),
          child: const Icon(Icons.rocket_launch, size: 38, color: Colors.white),
        ),
      ),
    );
  }
}
