// This widget drives a classic Rive State Machine via named Boolean/Trigger
// inputs, not Data Binding view models — the .riv file was authored with
// plain inputs, so `boolean`/`trigger` (marked deprecated in favor of Data
// Binding) are the correct API here.
// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/platform_utils.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_state.dart';

/// Ilustración animada de Rive para las pantallas de autenticación
/// (login y registro).
///
/// Carga el state machine `robot_login_machine` del artboard
/// `robot_artboard` (`assets/rive/robot_sign_in.riv`) y lo conecta con
/// la app real:
/// - `is_hands_up` (Boolean): se tapa los ojos mientras [isPasswordActive]
///   es `true` (el campo de contraseña tiene el foco).
/// - `success` (Trigger): se dispara cuando [authProvider] pasa a
///   [AuthAuthenticated].
/// - `fail` (Trigger): se dispara cuando [authProvider] pasa a [AuthError].
class RiveAuthIllustration extends ConsumerStatefulWidget {
  /// Si `true`, el robot se tapa los ojos (pensado para cuando el campo
  /// de contraseña tiene el foco).
  final bool isPasswordActive;

  const RiveAuthIllustration({super.key, this.isPasswordActive = false});

  @override
  ConsumerState<RiveAuthIllustration> createState() =>
      _RiveAuthIllustrationState();
}

class _RiveAuthIllustrationState extends ConsumerState<RiveAuthIllustration> {
  static const _artboardName = 'robot_artboard';
  static const _stateMachineName = 'robot_login_machine';

  late final FileLoader _fileLoader = FileLoader.fromAsset(
    'assets/rive/robot_sign_in.riv',
    riveFactory: Factory.rive,
  );

  BooleanInput? _isHandsUp;
  TriggerInput? _success;
  TriggerInput? _fail;

  @override
  void didUpdateWidget(RiveAuthIllustration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPasswordActive != widget.isPasswordActive) {
      _isHandsUp?.value = widget.isPasswordActive;
    }
  }

  @override
  void dispose() {
    _fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Escucha los cambios de AuthState para disparar los triggers del
    // state machine en el momento exacto en que ocurren.
    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthAuthenticated) {
        _success?.fire();
      } else if (next is AuthError) {
        _fail?.fire();
      }
    });

    return SizedBox(
      height: 180,
      child: RiveWidgetBuilder(
        fileLoader: _fileLoader,
        controller: (file) => RiveWidgetController(
          file,
          artboardSelector: ArtboardSelector.byName(_artboardName),
          stateMachineSelector: StateMachineSelector.byName(_stateMachineName),
        ),
        onLoaded: (state) {
          _isHandsUp = state.controller.stateMachine.boolean('is_hands_up');
          _success = state.controller.stateMachine.trigger('success');
          _fail = state.controller.stateMachine.trigger('fail');
          _isHandsUp?.value = widget.isPasswordActive;
        },
        onFailed: (error, stackTrace) {
          debugPrint('RiveAuthIllustration failed to load: $error');
        },
        builder: (context, state) => switch (state) {
          RiveLoading() => const SizedBox.shrink(),
          RiveFailed() => _buildFailedPlaceholder(context),
          RiveLoaded() => RiveWidget(
            controller: state.controller,
            fit: Fit.contain,
          ),
        },
      ),
    );
  }

  /// Se muestra cuando el `.riv` no pudo cargarse, en vez de dejar el
  /// espacio en blanco sin avisar nada al usuario.
  Widget _buildFailedPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            PlatformUtils.isCupertino
                ? CupertinoIcons.exclamationmark_triangle
                : Icons.broken_image_outlined,
            color: colorScheme.onSurfaceVariant,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            'No se pudo cargar la animación',
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
