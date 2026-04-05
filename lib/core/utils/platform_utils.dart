import 'dart:io';

import 'package:flutter/foundation.dart';

/// Utilidades para detección de plataforma y selección de widgets adaptativos.
///
/// Permite decidir entre widgets de Cupertino (iOS) y Material (Android)
/// en función de la plataforma actual, respetando el look & feel nativo
/// de cada sistema operativo.
///
/// Ejemplo de uso:
/// ```dart
/// if (PlatformUtils.isIOS) {
///   return CupertinoButton(...);
/// } else {
///   return ElevatedButton(...);
/// }
/// ```
abstract final class PlatformUtils {
  /// `true` si la app se ejecuta en iOS o macOS.
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// `true` si la app se ejecuta en Android.
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// `true` si la app se ejecuta en la web.
  static bool get isWeb => kIsWeb;

  /// `true` si la app se ejecuta en macOS.
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// `true` si la app usa convenciones de UI de Cupertino (Apple).
  ///
  /// Retorna `true` en iOS y macOS.
  static bool get isCupertino => isIOS || isMacOS;

  /// `true` si la app usa convenciones de UI de Material (Google).
  ///
  /// Retorna `true` en Android y Web.
  static bool get isMaterial => isAndroid || isWeb;
}
