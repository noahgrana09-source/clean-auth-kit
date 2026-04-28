import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/platform_utils.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_state.dart';
import '../widgets/adaptive_button.dart';
import '../widgets/adaptive_text_field.dart';
import '../widgets/auth_error_widget.dart';
import '../widgets/auth_header.dart';
import '../widgets/google_sign_in_button.dart';
import 'register_screen.dart';

/// Pantalla de inicio de sesión adaptativa y responsiva.
///
/// Usa [ConsumerStatefulWidget] de Riverpod para manejar el estado
/// de autenticación. Renderiza widgets nativos de Cupertino en iOS
/// y Material en Android. El formulario se limita a 400px de ancho
/// en tablets/landscape para una mejor experiencia.
class LoginScreen extends ConsumerStatefulWidget {
  /// Crea un [LoginScreen].
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  /// Valida que la contraseña tenga al menos 6 caracteres.
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  /// Ejecuta el inicio de sesión con email y contraseña.
  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authNotifierProvider.notifier)
        .signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  /// Ejecuta el inicio de sesión con Google.
  Future<void> _signInWithGoogle() async {
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }

  /// Navega a la pantalla de registro.
  void _navigateToRegister() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;
    final errorMessage = authState is AuthError ? authState.message : null;

    if (PlatformUtils.isCupertino) {
      return CupertinoPageScaffold(
        child: SafeArea(child: _buildBody(isLoading, errorMessage)),
      );
    }

    return Scaffold(body: SafeArea(child: _buildBody(isLoading, errorMessage)));
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

  /// Construye el formulario de inicio de sesión.
  Widget _buildForm(bool isLoading, String? errorMessage) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const AuthHeader(
            title: 'Bienvenido',
            subtitle: 'Inicia sesión para continuar',
          ),
          const SizedBox(height: 32),

          // Error
          AuthErrorWidget(message: errorMessage),
          if (errorMessage != null) const SizedBox(height: 16),

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
            textInputAction: TextInputAction.done,
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
          const SizedBox(height: 24),

          // Botón iniciar sesión
          AdaptiveButton(
            text: 'Iniciar sesión',
            isLoading: isLoading,
            onPressed: isLoading ? null : _signInWithEmail,
          ),
          const SizedBox(height: 16),

          // Separador
          _buildDivider(),
          const SizedBox(height: 16),

          // Botón Google
          GoogleSignInButton(
            isLoading: isLoading,
            onPressed: isLoading ? null : _signInWithGoogle,
            text: "Iniciar sesión con Google",
          ),
          const SizedBox(height: 24),

          // Link a registro
          _buildRegisterLink(),
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

  /// Link de navegación a la pantalla de registro.
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta? ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: _navigateToRegister,
          child: Text(
            'Regístrate',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.brand),
          ),
        ),
      ],
    );
  }
}
