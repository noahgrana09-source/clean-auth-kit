import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/platform_utils.dart';

/// Overlays a loading indicator on top of [child] without unmounting it.
///
/// Unlike replacing [child] with a different screen, this preserves
/// the [State] of the tree below (text controllers, local flags,
/// already-connected Riverpod listeners) for as long as an async
/// operation like signing in or registering is running.
class LoadingOverlay extends StatelessWidget {
  /// Si `true`, muestra el velo y el indicador de carga sobre [child].
  final bool isLoading;

  /// Contenido sobre el que se superpone el indicador.
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(ignoring: isLoading, child: child),
        if (isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.scrim.withAlpha(40),
              child: Center(
                child: PlatformUtils.isCupertino
                    ? const CupertinoActivityIndicator(radius: 16)
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
