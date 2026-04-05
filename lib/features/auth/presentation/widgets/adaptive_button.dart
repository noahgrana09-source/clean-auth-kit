import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/platform_utils.dart';

/// Botón primario adaptativo que renderiza [CupertinoButton] en iOS
/// y [ElevatedButton] en Android/Web.
///
/// Incluye soporte para estado de carga con un indicador de progreso
/// nativo de cada plataforma. Usa el color de marca morado [AppColors.brand].
class AdaptiveButton extends StatelessWidget {
  /// Texto mostrado en el botón.
  final String text;

  /// Callback al presionar el botón. Si es `null`, el botón se deshabilita.
  final VoidCallback? onPressed;

  /// Si `true`, muestra un indicador de carga y deshabilita la interacción.
  final bool isLoading;

  /// Crea un [AdaptiveButton] adaptativo con color de marca.
  const AdaptiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isCupertino) {
      return _buildCupertinoButton();
    }
    return _buildMaterialButton();
  }

  /// Construye el botón estilo Cupertino (iOS/macOS).
  Widget _buildCupertinoButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: CupertinoButton(
        color: AppColors.brand,
        borderRadius: BorderRadius.circular(12),
        onPressed: isLoading ? null : onPressed,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : Text(
                text,
                style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
              ),
      ),
    );
  }

  /// Construye el botón estilo Material (Android/Web).
  Widget _buildMaterialButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(text),
      ),
    );
  }
}
