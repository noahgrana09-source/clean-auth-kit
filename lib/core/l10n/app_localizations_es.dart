// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get emailRequired => 'El correo electrónico es obligatorio';

  @override
  String get passwordRequired => 'La contraseña es obligatoria';

  @override
  String get emailHint => 'Correo electrónico';

  @override
  String get passwordHint => 'Contraseña';

  @override
  String get orDivider => 'o';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get loginWelcomeTitle => 'Bienvenido';

  @override
  String get loginWelcomeSubtitle => 'Inicia sesión para continuar';

  @override
  String get invalidCredentials => 'Usuario o contraseña incorrectos';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get noAccountPrompt => '¿No tienes cuenta? ';

  @override
  String get registerLink => 'Regístrate';

  @override
  String get createAccountTitle => 'Crear cuenta';

  @override
  String get registerSubtitle => 'Regístrate para comenzar';

  @override
  String get nameRequired => 'El nombre es obligatorio';

  @override
  String get invalidEmail => 'Ingresa un correo electrónico válido';

  @override
  String get passwordTooShort => 'Mínimo 8 caracteres';

  @override
  String get passwordNeedsUppercase => 'Debe contener al menos una mayúscula';

  @override
  String get passwordNeedsNumber => 'Debe contener al menos un número';

  @override
  String get passwordNeedsSpecialChar =>
      'Debe contener al menos un carácter especial';

  @override
  String get confirmPasswordRequired => 'Confirma tu contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get nameHint => 'Nombre completo';

  @override
  String get confirmPasswordHint => 'Confirmar contraseña';

  @override
  String get signUpWithGoogle => 'Registrarse con Google';

  @override
  String get haveAccountPrompt => '¿Ya tienes cuenta? ';

  @override
  String get homeTitle => 'Inicio';

  @override
  String welcomeUser(String name) {
    return 'Bienvenido, $name';
  }

  @override
  String get defaultUserName => 'usuario';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get animationLoadError => 'No se pudo cargar la animación';
}
