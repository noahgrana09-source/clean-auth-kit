import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import 'auth_illustration.dart';

/// Header reutilizable para las pantallas de autenticación.
///
/// Muestra la ilustración animada de auth, un título principal
/// y un subtítulo descriptivo.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AuthIllustration(),
        const SizedBox(height: 24),
        Text(
          title,
          style: AppTextStyles.headlineLarge.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
