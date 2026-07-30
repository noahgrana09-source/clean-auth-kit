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
import '../widgets/loading_overlay.dart';
import 'register_screen.dart';

/// Firebase Auth error codes that mean "wrong email/password" for the
/// sign-in-with-email flow. Any other code (network issues, rate
/// limiting, etc.) is a technical error and should be shown as-is
/// instead of being relabeled as a credentials mistake.
const _invalidCredentialCodes = {
  'invalid-credential',
  'wrong-password',
  'user-not-found',
  'invalid-email',
};

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;
  bool _attemptedEmailSignIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final emailErr = email.isEmpty
        ? 'El correo electrónico es obligatorio'
        : null;
    final passErr = password.isEmpty ? 'La contraseña es obligatoria' : null;

    setState(() {
      _emailError = emailErr;
      _passwordError = passErr;
    });
    _formKey.currentState?.validate();

    if (emailErr != null || passErr != null) return;

    _attemptedEmailSignIn = true;
    await ref
        .read(authProvider.notifier)
        .signInWithEmail(email: email, password: password);
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });
    _formKey.currentState?.validate();
    await ref.read(authProvider.notifier).signInWithGoogle();
  }

  void _navigateToRegister() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });
    _formKey.currentState?.validate();
    ref.read(authProvider.notifier).clearError();
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (_, next) {
      if (_attemptedEmailSignIn && next is AuthError) {
        _attemptedEmailSignIn = false;
        // Only relabel recognized "wrong credentials" codes. Anything
        // else (network, too-many-requests, etc.) is a real technical
        // error and must surface as-is via the banner below, not be
        // masked as an incorrect user/password.
        if (_invalidCredentialCodes.contains(next.code)) {
          setState(() {
            _emailError = 'Usuario o contraseña incorrectos';
            _passwordError = 'Usuario o contraseña incorrectos';
          });
          _formKey.currentState?.validate();
        }
      }
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;
    final bannerError =
        authState is AuthError && _emailError == null && _passwordError == null
        ? authState.message
        : null;

    if (PlatformUtils.isCupertino) {
      return CupertinoPageScaffold(
        child: SafeArea(
          child: LoadingOverlay(
            isLoading: isLoading,
            child: _buildBody(isLoading, bannerError),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: isLoading,
          child: _buildBody(isLoading, bannerError),
        ),
      ),
    );
  }

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

  Widget _buildForm(bool isLoading, String? errorMessage) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthHeader(
            title: 'Bienvenido',
            subtitle: 'Inicia sesión para continuar',
          ),
          const SizedBox(height: 32),

          AuthErrorWidget(message: errorMessage),
          if (errorMessage != null) const SizedBox(height: 16),

          AdaptiveTextField(
            controller: _emailController,
            hint: 'Correo electrónico',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: PlatformUtils.isCupertino
                ? CupertinoIcons.mail
                : Icons.email_outlined,
            validator: (_) => _emailError,
          ),
          const SizedBox(height: 16),

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
            validator: (_) => _passwordError,
          ),
          const SizedBox(height: 24),

          AdaptiveButton(
            text: 'Iniciar sesión',
            isLoading: isLoading,
            onPressed: isLoading ? null : _signInWithEmail,
          ),
          const SizedBox(height: 16),

          _buildDivider(),
          const SizedBox(height: 16),

          GoogleSignInButton(
            isLoading: isLoading,
            onPressed: isLoading ? null : _signInWithGoogle,
            text: 'Iniciar sesión con Google',
          ),
          const SizedBox(height: 24),

          _buildRegisterLink(),
        ],
      ),
    );
  }

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
