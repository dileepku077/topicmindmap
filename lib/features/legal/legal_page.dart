import 'package:flutter/material.dart';

import '../../core/brand_badge.dart';

const _contactEmail = 'stemlabs.ca@gmail.com';
const _lastUpdated = 'August 29, 2026';

/// Reachable without signing in (see app_router.dart) so a prospective
/// student or parent can read it before creating an account -- and linked
/// from the sign-up form itself (login_page.dart's _TermsNotice) and
/// Settings (settings_page.dart) for anyone to revisit afterward.
///
/// Plain-language, not a substitute for legal advice: this describes what
/// the app actually does (see the footer note rendered on the page itself),
/// not a certified compliance document.
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LegalScaffold(
      title: 'Privacy Policy',
      sections: [
        _Section(
          'Who this is for',
          'Astro STEM Labs is built for high-school students, roughly ages '
              '14 to 20. We ask for your age when you create an account and '
              "don't allow accounts outside that range.",
        ),
        _Section(
          'Information we collect',
          'Account information you give us directly: your email address, '
              'password, display name, grade, and age. Your password is '
              'handled entirely by our authentication provider, Supabase '
              "Auth -- we never see it in plain text.\n\n"
              'If you sign in with Google instead, we receive the name and '
              'email address Google shares with us.\n\n'
              'Usage information: which practice questions and lessons you '
              'attempt, whether your answers were correct, and when. This '
              'is what powers your own progress reports, mastery badges, '
              "and the mindmap's color-coding -- it's visible to you, and "
              'to an administrator helping run this app, and to no one '
              'else.\n\n'
              "We don't collect payment information through the app "
              'itself. Any paid-plan arrangement is made directly between '
              'you (or a parent/guardian) and the app operator, outside '
              'the app.',
        ),
        _Section(
          "What we don't do",
          "We don't use third-party analytics, advertising, or tracking "
              "services of any kind, and there are no ads in this app. We "
              "don't sell or rent your information to anyone, for any "
              "reason, and we don't use your data to train any external AI "
              'model.',
        ),
        _Section(
          'How your information is stored',
          'Your data lives in a managed database (Supabase, built on '
              'PostgreSQL). Your session is kept on your own device, in '
              "your browser's local storage, so you stay signed in between "
              'visits.',
        ),
        _Section(
          'How long we keep it',
          'We keep your account and progress information for as long as '
              "your account is active. If you'd like your account and data "
              'deleted, contact us below and we will remove it.',
        ),
        _Section(
          'Parents and guardians',
          'This app is meant for high-school-aged students. If you are a '
              "parent or guardian and have questions about your child's "
              'account, or would like to review or delete their '
              'information, contact us at $_contactEmail and we will '
              'respond directly.',
        ),
        _Section(
          'Your choices',
          'You can update your grade, display name, and appearance '
              'preferences any time from Profile & Preferences inside the '
              'app, and change your password there too. To close your '
              "account entirely, contact us and we'll take care of it.",
        ),
        _Section(
          'Changes to this policy',
          "If this policy changes, we'll update the date above and note "
              'any meaningful change here.',
        ),
        _Section('Contact us', 'Questions or requests: $_contactEmail'),
      ],
    );
  }
}

/// See [PrivacyPolicyPage]'s doc comment -- same reasoning applies here.
class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LegalScaffold(
      title: 'Terms of Service',
      sections: [
        _Section(
          'Acceptance',
          'By creating an account or using Astro STEM Labs, you agree to '
              'these terms.',
        ),
        _Section(
          'Eligibility',
          'This app is intended for high-school students, roughly between '
              'the ages of 14 and 20. You must fall within that range to '
              'create an account.',
        ),
        _Section(
          'Your account',
          "You're responsible for keeping your password secure and for "
              'anything that happens under your account. Let us know right '
              'away at $_contactEmail if you think someone else has access '
              'to it.',
        ),
        _Section(
          "What this app is (and isn't)",
          'Astro STEM Labs is a study and practice tool. Lessons and '
              "practice questions are here to help you learn -- they're "
              "not a substitute for your teacher, your school's "
              "curriculum, or professional academic advice, and we don't "
              'guarantee they cover everything on any specific test or '
              'exam.',
        ),
        _Section(
          'Acceptable use',
          "Use the app for your own learning. Don't try to access another "
              "student's account, disrupt the app for others, or attempt "
              'to extract, scrape, or resell the question bank or lesson '
              'content.',
        ),
        _Section(
          'Subscriptions and payment',
          'Some harder practice tiers require a paid plan. Any payment '
              "arrangement is made directly with the app operator outside "
              "the app -- we don't process payments inside the app today.",
        ),
        _Section(
          'Content ownership',
          'The lessons, questions, and mindmap content in this app belong '
              'to Astro STEM Labs (and, where credited, our content '
              'partners), and are provided for your personal, '
              'non-commercial use.',
        ),
        _Section(
          'No warranty',
          'We do our best to keep lesson content and practice questions '
              'accurate, but the app is provided "as is," without any '
              "guarantee that it's error-free or uninterrupted.",
        ),
        _Section(
          'Limitation of liability',
          "To the extent the law allows, Astro STEM Labs isn't liable for "
              'indirect damages arising from your use of the app; our '
              'overall liability for anything related to it is limited to '
              "what (if anything) you've paid for your current "
              'subscription period.',
        ),
        _Section(
          'Ending your account',
          'You can ask us to close your account at any time. We may '
              'suspend or close an account that violates these terms.',
        ),
        _Section(
          'Governing law',
          'These terms are governed by the laws of the Province of '
              'Ontario, Canada.',
        ),
        _Section(
          'Changes to these terms',
          'We may update these terms from time to time. Continuing to use '
              'the app after a change means you accept the update.',
        ),
        _Section('Contact us', 'Questions: $_contactEmail'),
      ],
    );
  }
}

class _Section {
  const _Section(this.heading, this.body);

  final String heading;
  final String body;
}

class _LegalScaffold extends StatelessWidget {
  const _LegalScaffold({required this.title, required this.sections});

  final String title;
  final List<_Section> sections;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandBadge(size: 28),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last updated: $_lastUpdated',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                for (final section in sections) ...[
                  Text(
                    section.heading,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    section.body,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 24),
                ],
                Divider(color: scheme.outlineVariant),
                const SizedBox(height: 12),
                Text(
                  'This page describes our current practices in plain '
                  'language and is not a substitute for independent legal '
                  'advice.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
