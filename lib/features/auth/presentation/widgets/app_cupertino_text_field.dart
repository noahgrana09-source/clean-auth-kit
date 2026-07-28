import 'package:flutter/material.dart';

/// Campo de texto diseñado para simular la estética nativa de iOS,
/// construido sobre un [TextFormField] de Material.
///
/// **¿Por qué existe este widget?**
/// El SDK de Flutter tiene ciertas limitaciones con los componentes de Cupertino:
/// 1. [CupertinoTextField] no implementa [FormField], por lo que no soporta validación nativa (`validator`).
/// 2. [CupertinoTextFormFieldRow] sí soporta validación, pero no expone la propiedad `suffix` (ej. botón de ver contraseña).
/// 
/// Para solucionar esto, este widget utiliza un campo de Material configurado 
/// visualmente para lucir idéntico a un campo moderno de iOS.
class AppCupertinoTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  const AppCupertinoTextField({
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
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      autofocus: autofocus,
      validator: validator,
      style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withAlpha(100),
          fontSize: 16,
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              )
            : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
