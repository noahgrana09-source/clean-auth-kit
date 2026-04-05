import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Header reutilizable para las pantallas de autenticación.
///
/// Muestra un ícono de la app con el color de marca, un título principal
/// y un subtítulo descriptivo. Pensado para colocarse en la parte
/// superior de [LoginScreen] y [RegisterScreen].
class AuthHeader extends StatelessWidget {
  /// Título principal (ej. "Bienvenido").
  final String title;

  /// Subtítulo descriptivo (ej. "Inicia sesión para continuar").
  final String subtitle;

  /// Crea un [AuthHeader] con título y subtítulo.
  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ícono de la app
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.brandLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.search_rounded,
            size: 36,
            color: AppColors.brand,
          ),
        ),
        const SizedBox(height: 24),
        // Título
        Text(
          title,
          style: AppTextStyles.headlineLarge.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Subtítulo
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
