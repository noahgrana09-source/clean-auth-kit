import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show AutofillHints, TextInput;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/platform_utils.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_state.dart';
import '../widgets/adaptive_button.dart';
import '../widgets/adaptive_text_field.dart';
import '../widgets/auth_error_widget.dart';
import '../widgets/auth_header.dart';
import '../widgets/google_auth_button.dart';
import '../widgets/loading_overlay.dart';

/// Adaptive, responsive registration screen.
///
/// Uses Riverpod's [ConsumerStatefulWidget] to manage authentication
/// state. Renders native Cupertino widgets on iOS and Material on
/// Android. The form is capped at 400px wide on tablets/landscape.
class RegisterScreen extends ConsumerStatefulWidget {
  /// Creates a [RegisterScreen].
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  /// How long the screen stays visible after a successful
  /// registration/login, so the [AuthHeader] success animation has
  /// time to finish playing before navigating away.
  static const _successCelebrationDelay = Duration(milliseconds: 2000);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isPasswordFocused = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      setState(() => _isPasswordFocused = _passwordFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  /// Validates that the name is not empty.
  String? _validateName(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.nameRequired;
    }
    return null;
  }

  /// Validates an email against a basic regular expression.
  String? _validateEmail(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return l10n.invalidEmail;
    }
    return null;
  }

  /// Validates that the password meets the security requirements:
  /// minimum 8 characters, one uppercase letter, one digit, and one
  /// special character.
  String? _validatePassword(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value.length < 8) {
      return l10n.passwordTooShort;
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return l10n.passwordNeedsUppercase;
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return l10n.passwordNeedsNumber;
    }
    if (!RegExp(r"[!@#$%^&*()\-_=+\[\]{};:,.<>?/\\|~]").hasMatch(value)) {
      return l10n.passwordNeedsSpecialChar;
    }
    return null;
  }

  /// Validates that the password confirmation matches.
  String? _validateConfirmPassword(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.confirmPasswordRequired;
    }
    if (value != _passwordController.text) {
      return l10n.passwordsDoNotMatch;
    }
    return null;
  }

  /// Runs registration with email and password.
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

  /// Runs registration/sign-in with Google.
  Future<void> _signInWithGoogle() async {
    await ref.read(authProvider.notifier).signInWithGoogle();
  }

  /// Returns to the login screen.
  void _navigateToLogin() {
    ref.read(authProvider.notifier).clearError();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthAuthenticated) {
        // Tell the platform the submission succeeded so it can offer to
        // save the credentials just entered (Google Password Manager on
        // Android, Keychain on iOS).
        TextInput.finishAutofillContext();
        final navigator = Navigator.of(context);
        Future.delayed(_successCelebrationDelay, () {
          if (mounted) navigator.popUntil((route) => route.isFirst);
        });
      }
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;
    final errorMessage = authState is AuthError ? authState.message : null;

    if (PlatformUtils.isCupertino) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            onPressed: _navigateToLogin,
          ),
        ),
        child: SafeArea(
          child: LoadingOverlay(
            isLoading: isLoading,
            child: _buildBody(isLoading, errorMessage),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: _navigateToLogin)),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: isLoading,
          child: _buildBody(isLoading, errorMessage),
        ),
      ),
    );
  }

  /// Builds the screen body with a responsive layout.
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

  /// Builds the registration form.
  Widget _buildForm(bool isLoading, String? errorMessage) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      autovalidateMode: _submitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthHeader(
              title: l10n.createAccountTitle,
              subtitle: l10n.registerSubtitle,
              isPasswordActive: _isPasswordFocused,
            ),
            const SizedBox(height: 32),

            AuthErrorWidget(message: errorMessage),
            if (errorMessage != null) const SizedBox(height: 16),

            AdaptiveTextField(
              controller: _nameController,
              hint: l10n.nameHint,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              prefixIcon: PlatformUtils.isCupertino
                  ? CupertinoIcons.person
                  : Icons.person_outlined,
              validator: _validateName,
              autofillHints: const [AutofillHints.name],
            ),
            const SizedBox(height: 16),

            AdaptiveTextField(
              controller: _emailController,
              hint: l10n.emailHint,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefixIcon: PlatformUtils.isCupertino
                  ? CupertinoIcons.mail
                  : Icons.email_outlined,
              validator: _validateEmail,
              autofillHints: const [
                AutofillHints.newUsername,
                AutofillHints.email,
              ],
            ),
            const SizedBox(height: 16),

            AdaptiveTextField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              hint: l10n.passwordHint,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              prefixIcon: PlatformUtils.isCupertino
                  ? CupertinoIcons.lock
                  : Icons.lock_outlined,
              suffixIcon: GestureDetector(
                onTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
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
              autofillHints: const [AutofillHints.newPassword],
            ),
            const SizedBox(height: 16),

            AdaptiveTextField(
              controller: _confirmPasswordController,
              hint: l10n.confirmPasswordHint,
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
              autofillHints: const [AutofillHints.newPassword],
            ),
            const SizedBox(height: 24),

            AdaptiveButton(
              text: l10n.createAccountTitle,
              isLoading: isLoading,
              onPressed: isLoading ? null : _signUpWithEmail,
            ),
            const SizedBox(height: 16),

            _buildDivider(),
            const SizedBox(height: 16),

            GoogleAuthButton(
              isLoading: isLoading,
              onPressed: isLoading ? null : _signInWithGoogle,
              text: l10n.signUpWithGoogle,
            ),
            const SizedBox(height: 24),

            _buildLoginLink(),
          ],
        ),
      ),
    );
  }

  /// Divider with an "or" label.
  Widget _buildDivider() {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      children: [
        Expanded(child: Divider(color: color.withAlpha(77))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppLocalizations.of(context)!.orDivider,
            style: AppTextStyles.bodySmall.copyWith(color: color),
          ),
        ),
        Expanded(child: Divider(color: color.withAlpha(77))),
      ],
    );
  }

  /// Navigation link to the login screen.
  Widget _buildLoginLink() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.haveAccountPrompt,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: _navigateToLogin,
          child: Text(
            l10n.signIn,
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.brand),
          ),
        ),
      ],
    );
  }
}
