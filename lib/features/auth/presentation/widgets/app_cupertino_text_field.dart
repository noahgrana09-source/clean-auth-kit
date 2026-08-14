import 'package:flutter/material.dart';

/// Text field designed to mimic native iOS aesthetics,
/// built on top of a Material [TextFormField].
///
/// **Why does this widget exist?**
/// The Flutter SDK has certain limitations with Cupertino components:
/// 1. [CupertinoTextField] doesn't implement [FormField], so it doesn't support native validation (`validator`).
/// 2. [CupertinoTextFormFieldRow] does support validation, but doesn't expose a `suffix` property (e.g. a show-password button).
///
/// To work around this, this widget uses a Material field styled
/// to look identical to a modern iOS field.
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
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;

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
    this.focusNode,
    this.autofillHints,
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
      focusNode: focusNode,
      autofillHints: autofillHints,
      style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withAlpha(100),
          fontSize: 16,
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
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
            ? Icon(prefixIcon, color: colorScheme.onSurfaceVariant, size: 20)
            : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
