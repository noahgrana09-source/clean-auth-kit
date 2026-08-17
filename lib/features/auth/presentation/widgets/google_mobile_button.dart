import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

// Official Google "G" logo SVG, embedded as a string to avoid external assets.
const String _googleLogoSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
  <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
  <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
  <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
  <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
</svg>
''';

/// "Continue with Google" button with the official Google logo, used on
/// Android/iOS ([GoogleSignIn.supportsAuthenticate] platforms). Web uses
/// Google's own rendered button instead — see [GoogleAuthButton].
///
/// Follows the Google Sign-In branding guidelines: white background
/// on light theme, dark background on dark theme, G logo on the
/// left, centered text.
class GoogleMobileButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  /// Button label. Defaults to [AppLocalizations.continueWithGoogle]
  /// when omitted.
  final String? text;

  const GoogleMobileButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final label = text ?? AppLocalizations.of(context)!.continueWithGoogle;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark
              ? SocialColors.googleBgDark
              : SocialColors.googleBgLight,
          side: BorderSide(
            color: isDark
                ? SocialColors.googleOutlineDark
                : SocialColors.googleOutlineLight,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colorScheme.onSurface,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.string(_googleLogoSvg, width: 20, height: 20),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.25,
                      color: isDark
                          ? SocialColors.googleTextDark
                          : SocialColors.googleTextLight,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
