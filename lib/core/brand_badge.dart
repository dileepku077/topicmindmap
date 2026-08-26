import 'package:flutter/material.dart';

/// The gold-to-coral gradient and near-black badge are lifted straight from
/// the astrostemlabs.com wordmark (a black square, a gold/orange rocket,
/// "Makes STEM learning fun and exciting" underneath) — the parent
/// company's own mark, used as-is rather than redrawn in the app's navy/
/// teal system, so students see one consistent "Astro" identity across
/// astrostemlabs.com and this app.
const brandBadgeColor = Color(0xFF12192B);
const brandGradient = LinearGradient(
  colors: [Color(0xFFF4A93B), Color(0xFFE8604C)],
);
const brandCoral = Color(0xFFE8604C);

/// The rocket badge — originally the login page's hero mark, now reused at
/// a smaller size next to the "Astro STEM Labs" wordmark on every page's
/// AppBar so the brand shows up consistently everywhere, not just at
/// sign-in. [size] drives everything proportionally (icon, corner radius,
/// shadow) so one widget covers both the login hero (76) and an AppBar
/// leading mark (in the low 20s-30s) without looking like two different
/// assets at different scales.
class BrandBadge extends StatelessWidget {
  const BrandBadge({super.key, this.size = 76});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: brandBadgeColor,
        borderRadius: BorderRadius.circular(size * 0.26),
        boxShadow: [
          BoxShadow(
            color: brandCoral.withValues(alpha: 0.35),
            blurRadius: size * 0.29,
            offset: Offset(0, size * 0.11),
          ),
        ],
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => brandGradient.createShader(bounds),
          child: Icon(Icons.rocket_launch, size: size * 0.5, color: Colors.white),
        ),
      ),
    );
  }
}
