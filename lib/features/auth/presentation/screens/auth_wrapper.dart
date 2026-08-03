import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/platform_utils.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_state.dart';
import 'login_screen.dart';

/// Widget raíz de autenticación que observa el estado de auth.
///
/// Observa [authProvider] y redirige según el estado:
/// - [AuthAuthenticated] → pantalla principal (placeholder).
/// - [AuthUnauthenticated] / [AuthError] / [AuthLoading] → [LoginScreen]
///   (que muestra su propio indicador de carga superpuesto).
/// - [AuthInitial] → indicador de carga nativo, antes de saber si hay
///   una sesión activa.
class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  /// Tiempo que se sigue mostrando [LoginScreen] tras un login/registro
  /// exitoso, para que la animación de éxito del [AuthHeader] alcance a
  /// reproducirse antes de mostrar la pantalla principal.
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

  /// Pantalla de carga mientras se determina el estado de auth.
  Widget _buildLoadingScreen() {
    if (PlatformUtils.isCupertino) {
      return const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator(radius: 16)),
      );
    }
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  /// Placeholder de pantalla autenticada.
  ///
  /// Será reemplazado por la pantalla principal real de la app.
  Widget _buildAuthenticatedScreen(
    BuildContext context,
    WidgetRef ref,
    String? displayName,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    void signOut() => ref.read(authProvider.notifier).signOut();

    if (PlatformUtils.isCupertino) {
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text('Inicio')),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bienvenido, ${displayName ?? 'usuario'}',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 24),
              CupertinoButton(
                onPressed: signOut,
                child: const Text('Cerrar sesión'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bienvenido, ${displayName ?? 'usuario'}',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: signOut,
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
