import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Validation error when the email field is empty
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Validation error when the password field is empty
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Placeholder for the email text field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// Placeholder for the password text field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// Divider label between the email form and the Google sign-in button
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orDivider;

  /// Sign-in submit button, and the login link on the register screen
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Default label for the Google sign-in button
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// Login screen header title
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get loginWelcomeTitle;

  /// Login screen header subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginWelcomeSubtitle;

  /// Shown on the email/password fields when sign-in fails with a recognized bad-credentials code
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get invalidCredentials;

  /// Google button label on the login screen
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// Prompt before the register link on the login screen
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccountPrompt;

  /// Link to the register screen
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get registerLink;

  /// Register screen title (nav bar, header, and submit button)
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountTitle;

  /// Register screen header subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get registerSubtitle;

  /// Validation error when the name field is empty
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// Validation error when the email field doesn't match a basic email pattern
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmail;

  /// Validation error when the password is under 8 characters
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get passwordTooShort;

  /// Validation error when the password has no uppercase letter
  ///
  /// In en, this message translates to:
  /// **'Must contain at least one uppercase letter'**
  String get passwordNeedsUppercase;

  /// Validation error when the password has no digit
  ///
  /// In en, this message translates to:
  /// **'Must contain at least one digit'**
  String get passwordNeedsNumber;

  /// Validation error when the password has no special character
  ///
  /// In en, this message translates to:
  /// **'Must contain at least one special character'**
  String get passwordNeedsSpecialChar;

  /// Validation error when the confirm-password field is empty
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordRequired;

  /// Validation error when password and confirm-password differ
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Placeholder for the name text field
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get nameHint;

  /// Placeholder for the confirm-password text field
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordHint;

  /// Google button label on the register screen
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get signUpWithGoogle;

  /// Prompt before the login link on the register screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get haveAccountPrompt;

  /// Title of the placeholder authenticated screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// Greeting on the placeholder authenticated screen
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeUser(String name);

  /// Fallback name used in the welcome greeting when the user has no display name
  ///
  /// In en, this message translates to:
  /// **'user'**
  String get defaultUserName;

  /// Sign-out button on the placeholder authenticated screen
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// Shown in place of the Rive illustration if the .riv file fails to load
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the animation'**
  String get animationLoadError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
