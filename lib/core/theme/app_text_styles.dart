import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Estilos de texto de la aplicación.
///
/// Basados en la escala tipográfica de Material 3.
/// Todos los estilos están disponibles para light y dark
/// a través de [ThemeData.textTheme].
abstract final class AppTextStyles {
  // ── Display ──────────────────────────────────────────────────────────────

  /// Texto muy grande para títulos de pantalla completa.
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  /// Texto grande para cabeceras principales.
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
  );

  // ── Headline ─────────────────────────────────────────────────────────────

  /// Titular principal de pantallas de auth.
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.25,
  );

  /// Titular mediano (subtítulos de sección).
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
  );

  /// Titular pequeño.
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
  );

  // ── Title ────────────────────────────────────────────────────────────────

  /// Título de componente grande (AppBar, Card header).
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
  );

  /// Título de componente mediano.
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.50,
  );

  /// Título de componente pequeño.
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // ── Body ─────────────────────────────────────────────────────────────────

  /// Texto de cuerpo principal.
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
  );

  /// Texto de cuerpo secundario.
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  /// Texto de cuerpo pequeño (captions, hints).
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // ── Label ────────────────────────────────────────────────────────────────

  /// Etiqueta grande (botones).
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  /// Etiqueta mediana (chips, tabs).
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
  );

  /// Etiqueta pequeña (badges, overlines).
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Construye un [TextTheme] para el tema claro.
  static TextTheme get lightTextTheme => TextTheme(
    displayLarge: displayLarge.copyWith(color: AppColorsLight.textPrimary),
    displayMedium: displayMedium.copyWith(color: AppColorsLight.textPrimary),
    headlineLarge: headlineLarge.copyWith(color: AppColorsLight.textPrimary),
    headlineMedium: headlineMedium.copyWith(color: AppColorsLight.textPrimary),
    headlineSmall: headlineSmall.copyWith(color: AppColorsLight.textPrimary),
    titleLarge: titleLarge.copyWith(color: AppColorsLight.textPrimary),
    titleMedium: titleMedium.copyWith(color: AppColorsLight.textPrimary),
    titleSmall: titleSmall.copyWith(color: AppColorsLight.textSecondary),
    bodyLarge: bodyLarge.copyWith(color: AppColorsLight.textPrimary),
    bodyMedium: bodyMedium.copyWith(color: AppColorsLight.textPrimary),
    bodySmall: bodySmall.copyWith(color: AppColorsLight.textSecondary),
    labelLarge: labelLarge.copyWith(color: AppColorsLight.textPrimary),
    labelMedium: labelMedium.copyWith(color: AppColorsLight.textSecondary),
    labelSmall: labelSmall.copyWith(color: AppColorsLight.textDisabled),
  );

  /// Construye un [TextTheme] para el tema oscuro.
  static TextTheme get darkTextTheme => TextTheme(
    displayLarge: displayLarge.copyWith(color: AppColorsDark.textPrimary),
    displayMedium: displayMedium.copyWith(color: AppColorsDark.textPrimary),
    headlineLarge: headlineLarge.copyWith(color: AppColorsDark.textPrimary),
    headlineMedium: headlineMedium.copyWith(color: AppColorsDark.textPrimary),
    headlineSmall: headlineSmall.copyWith(color: AppColorsDark.textPrimary),
    titleLarge: titleLarge.copyWith(color: AppColorsDark.textPrimary),
    titleMedium: titleMedium.copyWith(color: AppColorsDark.textPrimary),
    titleSmall: titleSmall.copyWith(color: AppColorsDark.textSecondary),
    bodyLarge: bodyLarge.copyWith(color: AppColorsDark.textPrimary),
    bodyMedium: bodyMedium.copyWith(color: AppColorsDark.textPrimary),
    bodySmall: bodySmall.copyWith(color: AppColorsDark.textSecondary),
    labelLarge: labelLarge.copyWith(color: AppColorsDark.textPrimary),
    labelMedium: labelMedium.copyWith(color: AppColorsDark.textSecondary),
    labelSmall: labelSmall.copyWith(color: AppColorsDark.textDisabled),
  );
}
