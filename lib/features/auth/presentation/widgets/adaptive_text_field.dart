import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/platform_utils.dart';
import 'app_cupertino_text_field.dart';

/// Adaptive text field that renders [CupertinoTextField] on iOS
/// and [TextField] (Material) on Android/Web.
///
/// Accepts the most common text input parameters and translates
/// them to each platform's native component, keeping a look
/// consistent with the [AppColors] palette.
class AdaptiveTextField extends StatelessWidget {
  /// Hint text shown when the field is empty.
  final String? hint;

  /// Text field controller.
  final TextEditingController? controller;

  /// If `true`, obscures the text (for passwords).
  final bool obscureText;

  /// Keyboard type to show.
  final TextInputType? keyboardType;

  /// Field validation function.
  final String? Function(String?)? validator;

  /// Icon shown at the start of the field.
  final IconData? prefixIcon;

  /// Widget shown at the end of the field.
  final Widget? suffixIcon;

  /// Keyboard action (done, next, etc.).
  final TextInputAction? textInputAction;

  /// Callback when the text changes.
  final ValueChanged<String>? onChanged;

  /// Whether the field should request focus automatically.
  final bool autofocus;

  /// Optional focus node, to observe when the field is active.
  final FocusNode? focusNode;

  /// Autofill hints (e.g. [AutofillHints.email]), so the operating
  /// system can offer to save and autofill the field's value.
  final Iterable<String>? autofillHints;

  /// Creates an adaptive [AdaptiveTextField].
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
    this.focusNode,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isCupertino) {
      return _buildCupertinoField(context);
    }
    return _buildMaterialField(context);
  }

  /// Builds the Cupertino-style text field (iOS/macOS).
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
      focusNode: focusNode,
      autofillHints: autofillHints,
    );
  }

  /// Builds the Material-style text field (Android/Web).
  Widget _buildMaterialField(BuildContext context) {
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
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
