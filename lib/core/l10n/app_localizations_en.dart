// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get emailRequired => 'Email is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get orDivider => 'or';

  @override
  String get signIn => 'Sign in';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get loginWelcomeTitle => 'Welcome';

  @override
  String get loginWelcomeSubtitle => 'Sign in to continue';

  @override
  String get invalidCredentials => 'Incorrect email or password';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get noAccountPrompt => 'Don\'t have an account? ';

  @override
  String get registerLink => 'Sign up';

  @override
  String get createAccountTitle => 'Create account';

  @override
  String get registerSubtitle => 'Sign up to get started';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get invalidEmail => 'Enter a valid email address';

  @override
  String get passwordTooShort => 'Minimum 8 characters';

  @override
  String get passwordNeedsUppercase =>
      'Must contain at least one uppercase letter';

  @override
  String get passwordNeedsNumber => 'Must contain at least one digit';

  @override
  String get passwordNeedsSpecialChar =>
      'Must contain at least one special character';

  @override
  String get confirmPasswordRequired => 'Confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get nameHint => 'Full name';

  @override
  String get confirmPasswordHint => 'Confirm password';

  @override
  String get signUpWithGoogle => 'Sign up with Google';

  @override
  String get haveAccountPrompt => 'Already have an account? ';

  @override
  String get homeTitle => 'Home';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name';
  }

  @override
  String get defaultUserName => 'user';

  @override
  String get signOut => 'Sign out';

  @override
  String get animationLoadError => 'Couldn\'t load the animation';
}
