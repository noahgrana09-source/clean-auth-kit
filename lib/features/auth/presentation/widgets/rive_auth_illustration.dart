// This widget drives a classic Rive State Machine via named Boolean/Trigger
// inputs, not Data Binding view models — the .riv file was authored with
// plain inputs, so `boolean`/`trigger` (marked deprecated in favor of Data
// Binding) are the correct API here.
// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/platform_utils.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_state.dart';

/// Animated Rive illustration for the authentication screens
/// (login and registration).
///
/// Loads the `robot_login_machine` state machine from the
/// `robot_artboard` artboard (`assets/rive/robot_sign_in.riv`) and
/// wires it to the real app state:
/// - `is_hands_up` (Boolean): covers its eyes while [isPasswordActive]
///   is `true` (the password field has focus).
/// - `success` (Trigger): fires when [authProvider] becomes
///   [AuthAuthenticated].
/// - `fail` (Trigger): fires when [authProvider] becomes [AuthError].
class RiveAuthIllustration extends ConsumerStatefulWidget {
  /// If `true`, the robot covers its eyes (meant for when the
  /// password field has focus).
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
    // Listens for AuthState changes to fire the state machine's
    // triggers at the exact moment they happen.
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

  /// Shown when the `.riv` file fails to load, instead of leaving a
  /// blank space with no feedback for the user.
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
            AppLocalizations.of(context)!.animationLoadError,
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
