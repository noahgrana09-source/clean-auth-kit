import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/platform_utils.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_state.dart';
import '../widgets/adaptive_button.dart';
import '../widgets/adaptive_text_field.dart';
import '../widgets/auth_error_widget.dart';
import '../widgets/auth_header.dart';
import '../widgets/google_sign_in_button.dart';

/// Pantalla de registro adaptativa y responsiva.
///
/// Usa [ConsumerStatefulWidget] de Riverpod para manejar el estado
/// de autenticación. Renderiza widgets nativos de Cupertino en iOS
/// y Material en Android. El formulario se limita a 400px de ancho
/// en tablets/landscape.
class RegisterScreen extends ConsumerStatefulWidget {
  /// Crea un [RegisterScreen].
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Valida que el nombre no esté vacío.
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es obligatorio';
    }
    return null;
  }

  /// Valida un email con una expresión regular básica.
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es obligatorio';
    }
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido';
    }
    return null;
  }

  /// Valida que la contraseña cumpla los requisitos de seguridad:
  /// mínimo 8 caracteres, una mayúscula, un número y un carácter especial.
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 8) {
      return 'Mínimo 8 caracteres';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Debe contener al menos una mayúscula';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Debe contener al menos un número';
    }
    if (!RegExp(r"[!@#$%^&*()\-_=+\[\]{};:,.<>?/\\|~]").hasMatch(value)) {
      return 'Debe contener al menos un carácter especial';
    }
    return null;
  }

  /// Valida que la confirmación de contraseña coincida.
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  /// Ejecuta el registro con email y contraseña.
  Future<void> _signUpWithEmail() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authProvider.notifier)
        .signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
        );
  }

  /// Ejecuta el registro/inicio de sesión con Google.
  Future<void> _signInWithGoogle() async {
    await ref.read(authProvider.notifier).signInWithGoogle();
  }

  /// Regresa a la pantalla de inicio de sesión.
  void _navigateToLogin() {
    ref.read(authProvider.notifier).clearError();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthAuthenticated) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;
    final errorMessage = authState is AuthError ? authState.message : null;

    if (PlatformUtils.isCupertino) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Crear cuenta'),
          leading: CupertinoNavigationBarBackButton(
            onPressed: _navigateToLogin,
          ),
        ),
        child: SafeArea(child: _buildBody(isLoading, errorMessage)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(child: _buildBody(isLoading, errorMessage)),
    );
  }

  /// Construye el cuerpo de la pantalla con layout responsivo.
  Widget _buildBody(bool isLoading, String? errorMessage) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _buildForm(isLoading, errorMessage),
            );
          },
        ),
      ),
    );
  }

  /// Construye el formulario de registro.
  Widget _buildForm(bool isLoading, String? errorMessage) {
    return Form(
      key: _formKey,
      autovalidateMode: _submitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const AuthHeader(
            title: 'Crear cuenta',
            subtitle: 'Regístrate para comenzar',
          ),
          const SizedBox(height: 32),

          // Error
          AuthErrorWidget(message: errorMessage),
          if (errorMessage != null) const SizedBox(height: 16),

          // Campo nombre
          AdaptiveTextField(
            controller: _nameController,
            hint: 'Nombre completo',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            prefixIcon: PlatformUtils.isCupertino
                ? CupertinoIcons.person
                : Icons.person_outlined,
            validator: _validateName,
          ),
          const SizedBox(height: 16),

          // Campo email
          AdaptiveTextField(
            controller: _emailController,
            hint: 'Correo electrónico',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: PlatformUtils.isCupertino
                ? CupertinoIcons.mail
                : Icons.email_outlined,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),

          // Campo contraseña
          AdaptiveTextField(
            controller: _passwordController,
            hint: 'Contraseña',
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            prefixIcon: PlatformUtils.isCupertino
                ? CupertinoIcons.lock
                : Icons.lock_outlined,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword
                    ? (PlatformUtils.isCupertino
                          ? CupertinoIcons.eye_slash
                          : Icons.visibility_off_outlined)
                    : (PlatformUtils.isCupertino
                          ? CupertinoIcons.eye
                          : Icons.visibility_outlined),
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            validator: _validatePassword,
          ),
          const SizedBox(height: 16),

          // Campo confirmar contraseña
          AdaptiveTextField(
            controller: _confirmPasswordController,
            hint: 'Confirmar contraseña',
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            prefixIcon: PlatformUtils.isCupertino
                ? CupertinoIcons.lock_shield
                : Icons.lock_outline,
            suffixIcon: GestureDetector(
              onTap: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
              child: Icon(
                _obscureConfirmPassword
                    ? (PlatformUtils.isCupertino
                          ? CupertinoIcons.eye_slash
                          : Icons.visibility_off_outlined)
                    : (PlatformUtils.isCupertino
                          ? CupertinoIcons.eye
                          : Icons.visibility_outlined),
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            validator: _validateConfirmPassword,
          ),
          const SizedBox(height: 24),

          // Botón crear cuenta
          AdaptiveButton(
            text: 'Crear cuenta',
            isLoading: isLoading,
            onPressed: isLoading ? null : _signUpWithEmail,
          ),
          const SizedBox(height: 16),

          // Separador
          _buildDivider(),
          const SizedBox(height: 16),

          // Botón Google
          GoogleSignInButton(
            isLoading: isLoading,
            onPressed: isLoading ? null : _signInWithGoogle,
            text: "Registrarse con Google",
          ),
          const SizedBox(height: 24),

          // Link a login
          _buildLoginLink(),
        ],
      ),
    );
  }

  /// Separador con texto "o".
  Widget _buildDivider() {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      children: [
        Expanded(child: Divider(color: color.withAlpha(77))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'o',
            style: AppTextStyles.bodySmall.copyWith(color: color),
          ),
        ),
        Expanded(child: Divider(color: color.withAlpha(77))),
      ],
    );
  }

  /// Link de navegación a la pantalla de inicio de sesión.
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Ya tienes cuenta? ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: _navigateToLogin,
          child: Text(
            'Iniciar sesión',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.brand),
          ),
        ),
      ],
    );
  }
}
