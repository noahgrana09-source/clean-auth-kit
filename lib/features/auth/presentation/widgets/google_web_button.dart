/// Conditionally exports the real web `renderButton()`
/// ([google_web_button_web.dart]) when compiling for web, or a stub
/// that's never actually called ([google_web_button_stub.dart])
/// otherwise. Mirrors the pattern from the `google_sign_in` package's
/// own example, which needs the same conditional import for the same
/// reason: `google_sign_in_web` isn't available on Android/iOS.
library;

export 'google_web_button_stub.dart'
    if (dart.library.js_util) 'google_web_button_web.dart';
