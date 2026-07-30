import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/platform_utils.dart';

/// Superpone un indicador de carga sobre [child] sin desmontarlo.
///
/// A diferencia de reemplazar [child] por otra pantalla, esto preserva
/// el [State] del árbol debajo (controllers de texto, flags locales,
/// listeners de Riverpod ya conectados) mientras dura una operación
/// asíncrona como iniciar sesión o registrarse.
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
