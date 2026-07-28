import 'package:flutter/material.dart';

/// Paleta de colores de la aplicación.
///
/// Define todos los colores usados en el sistema de diseño:
/// - [brand]: morado como color principal de marca
/// - [AppColorsLight]: escala de grises claros para temas light
/// - [AppColorsDark]: escala de grises oscuros para temas dark
///
/// Uso recomendado:
/// ```dart
/// color: AppColors.brand,
/// color: AppColorsLight.background,
/// color: AppColorsDark.surface,
/// ```
abstract final class AppColors {
  // ── Brand ────────────────────────────────────────────────────────────────

  /// Color principal de marca: morado vibrante.
  static const Color brand = Color(0xFF7C3AED);

  /// Variante más oscura del brand (hover / pressed).
  static const Color brandDark = Color(0xFF5B21B6);

  /// Variante más clara del brand (fondos sutiles, badges).
  static const Color brandLight = Color(0xFFB07EFA);

  /// Brand con opacidad reducida para overlays.
  static const Color brandFaded = Color(0x337C3AED);
}

// ── Light theme ──────────────────────────────────────────────────────────

/// Colores para el tema claro.
abstract final class AppColorsLight {
  /// Fondo principal de la app.
  static const Color background = Color(0xFFF9F9FB);

  /// Superficie elevada (cards, dialogs).
  static const Color surface = Color(0xFFFFFFFF);

  /// Superficie con elevación secundaria.
  static const Color surfaceVariant = Color(0xFFF3F3F7);

  /// Borde y divisores suaves.
  static const Color outline = Color(0xFFE2E2EA);

  /// Texto primario (títulos, cuerpo).
  static const Color textPrimary = Color(0xFF1A1A2E);

  /// Texto secundario (hints, subtítulos).
  static const Color textSecondary = Color(0xFF6E6E8A);

  /// Texto deshabilitado / placeholder.
  static const Color textDisabled = Color(0xFFB0B0C8);

  /// Ícono por defecto.
  static const Color icon = Color(0xFF4A4A6A);

  /// Color de error.
  static const Color error = Color(0xFFDC2626);

  /// Color de éxito.
  static const Color success = Color(0xFF16A34A);
}

// ── Dark theme ───────────────────────────────────────────────────────────

/// Colores para el tema oscuro.
abstract final class AppColorsDark {
  /// Fondo principal de la app.
  static const Color background = Color(0xFF0D0D14);

  /// Superficie elevada (cards, dialogs).
  static const Color surface = Color(0xFF16161F);

  /// Superficie con elevación secundaria.
  static const Color surfaceVariant = Color(0xFF1E1E2A);

  /// Borde y divisores suaves.
  static const Color outline = Color(0xFF2E2E3E);

  /// Texto primario (títulos, cuerpo).
  static const Color textPrimary = Color(0xFFF0F0FA);

  /// Texto secundario (hints, subtítulos).
  static const Color textSecondary = Color(0xFF9898B0);

  /// Texto deshabilitado / placeholder.
  static const Color textDisabled = Color(0xFF4E4E64);

  /// Ícono por defecto.
  static const Color icon = Color(0xFFB0B0C8);

  /// Color de error.
  static const Color error = Color(0xFFF87171);

  /// Color de éxito.
  static const Color success = Color(0xFF4ADE80);
}

// ── Social / Third Party ─────────────────────────────────────────────────

/// Colores de branding para servicios externos.
abstract final class SocialColors {
  /// Google - Fondo (Light).
  static const Color googleBgLight = Color(0xFFFFFFFF);

  /// Google - Fondo (Dark).
  static const Color googleBgDark = Color(0xFF131314);

  /// Google - Borde (Light).
  static const Color googleOutlineLight = Color(0xFF747775);

  /// Google - Borde (Dark).
  static const Color googleOutlineDark = Color(0xFF8E918F);

  /// Google - Texto (Light).
  static const Color googleTextLight = Color(0xFF1F1F1F);

  /// Google - Texto (Dark).
  static const Color googleTextDark = Color(0xFFE3E3E3);
}
