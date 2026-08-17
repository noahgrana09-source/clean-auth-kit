import 'package:flutter/widgets.dart' show Widget;

/// Stub for the web-only `renderButton()` — `google_sign_in_web` has to
/// sit behind a conditional import (see `google_web_button.dart`) so
/// Android/iOS builds, which never pull in that package, still compile.
Widget renderButton({GSIButtonConfiguration? configuration}) {
  throw StateError('renderButton() should only be called on web');
}

/// Stub mirroring `google_sign_in_web`'s real `GSIButtonConfiguration` —
/// only needed so `GoogleAuthButton` can reference this type on
/// Android/iOS too; never actually constructed there.
class GSIButtonConfiguration {
  const GSIButtonConfiguration({
    this.type,
    this.theme,
    this.size,
    this.text,
    this.shape,
    this.logoAlignment,
    this.minimumWidth,
    this.locale,
  });

  final GSIButtonType? type;
  final GSIButtonTheme? theme;
  final GSIButtonSize? size;
  final GSIButtonText? text;
  final GSIButtonShape? shape;
  final GSIButtonLogoAlignment? logoAlignment;
  final double? minimumWidth;
  final String? locale;
}

enum GSIButtonType { standard, icon }

enum GSIButtonTheme { outline, filledBlue, filledBlack }

enum GSIButtonSize { large, medium, small }

enum GSIButtonText { signinWith, signupWith, continueWith, signin }

enum GSIButtonShape { rectangular, pill }

enum GSIButtonLogoAlignment { left, center }
