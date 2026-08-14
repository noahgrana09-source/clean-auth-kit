import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/platform_utils.dart';

/// Adaptive primary button that renders [CupertinoButton] on iOS
/// and [ElevatedButton] on Android/Web.
///
/// Includes loading-state support with each platform's native
/// progress indicator. Uses the purple brand color [AppColors.brand].
class AdaptiveButton extends StatelessWidget {
  /// Text shown on the button.
  final String text;

  /// Callback on button press. If `null`, the button is disabled.
  final VoidCallback? onPressed;

  /// If `true`, shows a loading indicator and disables interaction.
  final bool isLoading;

  /// Creates an [AdaptiveButton] with the brand color.
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

  /// Builds the Cupertino-style button (iOS/macOS).
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

  /// Builds the Material-style button (Android/Web).
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
