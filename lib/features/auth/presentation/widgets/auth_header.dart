import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../providers/auth_providers.dart';
import 'auth_illustration.dart';
import 'rive_auth_illustration.dart';

/// Header reutilizable para las pantallas de autenticación.
///
/// Muestra la ilustración animada de auth, un título principal
/// y un subtítulo descriptivo. Qué ilustración se usa (la propia o la
/// de Rive) lo decide [useAppIllustrationProvider].
class AuthHeader extends ConsumerWidget {
  final String title;
  final String subtitle;

  final bool isPasswordActive;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.isPasswordActive = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useAppIllustration = ref.watch(useAppIllustrationProvider);

    return Column(
      children: [
        useAppIllustration
            ? const AuthIllustration()
            : RiveAuthIllustration(isPasswordActive: isPasswordActive),
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
