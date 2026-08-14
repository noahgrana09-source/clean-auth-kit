import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/platform_utils.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_state.dart';
import 'login_screen.dart';

/// Root authentication widget that observes the auth state.
///
/// Watches [authProvider] and redirects based on its state:
/// - [AuthAuthenticated] → main screen (placeholder).
/// - [AuthUnauthenticated] / [AuthError] / [AuthLoading] → [LoginScreen]
///   (which shows its own overlaid loading indicator).
/// - [AuthInitial] → native loading indicator, before knowing whether
///   there is an active session.
class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  /// How long [LoginScreen] stays visible after a successful
  /// login/registration, so the [AuthHeader] success animation has
  /// time to finish playing before the main screen is shown.
  static const _successCelebrationDelay = Duration(milliseconds: 2000);

  bool _showAuthenticatedScreen = false;

  @override
  void initState() {
    super.initState();
    // If the app starts with an already-authenticated session (a
    // returning user, not a live login just now), skip straight to
    // the home screen: there is no "just succeeded" transition for
    // ref.listen to observe in build(), so without this the delayed
    // flip below would never run and _showAuthenticatedScreen would
    // stay false forever, stranding the user on LoginScreen.
    _showAuthenticatedScreen = ref.read(authProvider) is AuthAuthenticated;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        if (previous is! AuthAuthenticated) {
          Future.delayed(_successCelebrationDelay, () {
            if (mounted) setState(() => _showAuthenticatedScreen = true);
          });
        }
      } else {
        _showAuthenticatedScreen = false;
      }
    });

    final authState = ref.watch(authProvider);

    return authState.when(
      initial: _buildLoadingScreen,
      // Stay on LoginScreen while loading instead of swapping to a
      // different widget: that would unmount it and lose local state
      // (attempted-sign-in flag, field errors, text controllers) right
      // before the result of the attempt arrives.
      loading: () => const LoginScreen(),
      authenticated: (user) => _showAuthenticatedScreen
          ? _buildAuthenticatedScreen(context, ref, user.displayName)
          : const LoginScreen(),
      unauthenticated: () => const LoginScreen(),
      error: (_, _) => const LoginScreen(),
    );
  }

  /// Loading screen shown while the auth state is being determined.
  Widget _buildLoadingScreen() {
    if (PlatformUtils.isCupertino) {
      return const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator(radius: 16)),
      );
    }
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  /// Placeholder for the authenticated screen.
  ///
  /// Will be replaced by the app's real main screen.
  Widget _buildAuthenticatedScreen(
    BuildContext context,
    WidgetRef ref,
    String? displayName,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    void signOut() => ref.read(authProvider.notifier).signOut();

    if (PlatformUtils.isCupertino) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text(l10n.homeTitle)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.welcomeUser(displayName ?? l10n.defaultUserName),
                style: TextStyle(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 24),
              CupertinoButton(onPressed: signOut, child: Text(l10n.signOut)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeTitle)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.welcomeUser(displayName ?? l10n.defaultUserName),
              style: TextStyle(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: signOut,
              icon: const Icon(Icons.logout),
              label: Text(l10n.signOut),
            ),
          ],
        ),
      ),
    );
  }
}
