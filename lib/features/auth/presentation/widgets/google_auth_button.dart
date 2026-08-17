import 'package:flutter/material.dart' show Theme, Brightness;
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'google_mobile_button.dart';
import 'google_web_button.dart' as google_web;

/// Chooses the right Google sign-in button for the current platform.
///
/// On Android/iOS, [GoogleSignIn.supportsAuthenticate] is `true` and
/// this renders [GoogleMobileButton], our own styled button wired to an
/// explicit `authenticate()` call. On web it's `false` — Google's own
/// JS drives the whole flow through a button it renders itself
/// ([google_web.renderButton]), which we can't restyle or attach an
/// `onPressed` to. Its result surfaces separately, through
/// `AuthNotifier`'s subscription to `GoogleSignIn.authenticationEvents`.
class GoogleAuthButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  /// Button label for the native button. Has no effect on web, where
  /// Google renders its own fixed label.
  final String? text;

  const GoogleAuthButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    if (GoogleSignIn.instance.supportsAuthenticate()) {
      return GoogleMobileButton(
        onPressed: onPressed,
        isLoading: isLoading,
        text: text,
      );
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      child: google_web.renderButton(
        configuration: google_web.GSIButtonConfiguration(
          type: google_web.GSIButtonType.standard,
          size: google_web.GSIButtonSize.large,
          // Google has no "dark background, light border" preset —
          // outline (light background, dark border) is the closest
          // match for light mode, filledBlack (solid dark, no border
          // of its own) for dark mode.
          theme: isDark
              ? google_web.GSIButtonTheme.filledBlack
              : google_web.GSIButtonTheme.outline,
          shape: google_web.GSIButtonShape.pill,
          minimumWidth: 400,
        ),
      ),
    );
  }
}
