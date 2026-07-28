import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/platform_utils.dart';
import 'app_cupertino_text_field.dart';

/// Campo de texto adaptativo que renderiza [CupertinoTextField] en iOS
/// y [TextField] (Material) en Android/Web.
///
/// Acepta los parámetros más comunes de entrada de texto y los traduce
/// al componente nativo de cada plataforma, manteniendo una apariencia
/// coherente con la paleta de [AppColors].
class AdaptiveTextField extends StatelessWidget {
  /// Texto de sugerencia cuando el campo está vacío.
  final String? hint;

  /// Controlador del campo de texto.
  final TextEditingController? controller;

  /// Si `true`, oculta el texto (para contraseñas).
  final bool obscureText;

  /// Tipo de teclado a mostrar.
  final TextInputType? keyboardType;

  /// Función de validación del campo.
  final String? Function(String?)? validator;

  /// Ícono mostrado al inicio del campo.
  final IconData? prefixIcon;

  /// Widget mostrado al final del campo.
  final Widget? suffixIcon;

  /// Acción del teclado (done, next, etc.).
  final TextInputAction? textInputAction;

  /// Callback cuando el texto cambia.
  final ValueChanged<String>? onChanged;

  /// Indica si el campo debe solicitar foco automáticamente.
  final bool autofocus;

  /// Crea un [AdaptiveTextField] adaptativo.
  const AdaptiveTextField({
    super.key,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isCupertino) {
      return _buildCupertinoField(context);
    }
    return _buildMaterialField(context);
  }

  /// Construye el campo de texto estilo Cupertino (iOS/macOS).
  Widget _buildCupertinoField(BuildContext context) {
    return AppCupertinoTextField(
      controller: controller,
      hint: hint,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      autofocus: autofocus,
      validator: validator,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  /// Construye el campo de texto estilo Material (Android/Web).
  Widget _buildMaterialField(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      autofocus: autofocus,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
