import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/platform_utils.dart';

/// Widget adaptativo para mostrar errores de autenticación.
///
/// Se muestra con una animación suave de aparición/desaparición.
/// Usa colores de error del [ColorScheme] del tema actual y se adapta
/// a la plataforma (Cupertino en iOS, Material en Android).
class AuthErrorWidget extends StatelessWidget {
  /// Mensaje de error a mostrar. Si es `null` o vacío, el widget
  /// se oculta con una animación.
  final String? message;

  /// Crea un [AuthErrorWidget] con un [message] opcional.
  const AuthErrorWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final hasError = message != null && message!.isNotEmpty;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: child,
          ),
        );
      },
      child: hasError
          ? _buildErrorContent(context)
          : const SizedBox.shrink(key: ValueKey('empty')),
    );
  }

  /// Construye el contenido del error.
  Widget _buildErrorContent(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return Container(
      key: ValueKey(message),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: errorColor.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: errorColor.withAlpha(77)),
      ),
      child: Row(
        children: [
          Icon(
            PlatformUtils.isCupertino
                ? CupertinoIcons.exclamationmark_circle
                : Icons.error_outline_rounded,
            color: errorColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message!,
              style: AppTextStyles.bodySmall.copyWith(color: errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
