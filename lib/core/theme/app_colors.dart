import 'package:flutter/material.dart';

/// Application color palette.
///
/// Defines all colors used across the design system:
/// - [AppColors.brand]: purple as the main brand color
/// - [AppColorsLight]: light gray scale for light themes
/// - [AppColorsDark]: dark gray scale for dark themes
///
/// Recommended usage:
/// ```dart
/// color: AppColors.brand,
/// color: AppColorsLight.background,
/// color: AppColorsDark.surface,
/// ```
abstract final class AppColors {
  // ── Brand ────────────────────────────────────────────────────────────────

  /// Main brand color: vibrant purple.
  static const Color brand = Color(0xFF7C3AED);

  /// Darker brand variant (hover / pressed).
  static const Color brandDark = Color(0xFF5B21B6);

  /// Lighter brand variant (subtle backgrounds, badges).
  static const Color brandLight = Color(0xFFB07EFA);

  /// Brand with reduced opacity for overlays.
  static const Color brandFaded = Color(0x337C3AED);
}

// ── Light theme ──────────────────────────────────────────────────────────

/// Colors for the light theme.
abstract final class AppColorsLight {
  /// App's main background.
  static const Color background = Color(0xFFF9F9FB);

  /// Elevated surface (cards, dialogs).
  static const Color surface = Color(0xFFFFFFFF);

  /// Secondary elevation surface.
  static const Color surfaceVariant = Color(0xFFF3F3F7);

  /// Soft borders and dividers.
  static const Color outline = Color(0xFFE2E2EA);

  /// Primary text (titles, body).
  static const Color textPrimary = Color(0xFF1A1A2E);

  /// Secondary text (hints, subtitles).
  static const Color textSecondary = Color(0xFF6E6E8A);

  /// Disabled / placeholder text.
  static const Color textDisabled = Color(0xFFB0B0C8);

  /// Default icon color.
  static const Color icon = Color(0xFF4A4A6A);

  /// Error color.
  static const Color error = Color(0xFFDC2626);

  /// Success color.
  static const Color success = Color(0xFF16A34A);
}

// ── Dark theme ───────────────────────────────────────────────────────────

/// Colors for the dark theme.
abstract final class AppColorsDark {
  /// App's main background.
  static const Color background = Color(0xFF0D0D14);

  /// Elevated surface (cards, dialogs).
  static const Color surface = Color(0xFF16161F);

  /// Secondary elevation surface.
  static const Color surfaceVariant = Color(0xFF1E1E2A);

  /// Soft borders and dividers.
  static const Color outline = Color(0xFF2E2E3E);

  /// Primary text (titles, body).
  static const Color textPrimary = Color(0xFFF0F0FA);

  /// Secondary text (hints, subtitles).
  static const Color textSecondary = Color(0xFF9898B0);

  /// Disabled / placeholder text.
  static const Color textDisabled = Color(0xFF4E4E64);

  /// Default icon color.
  static const Color icon = Color(0xFFB0B0C8);

  /// Error color.
  static const Color error = Color(0xFFF87171);

  /// Success color.
  static const Color success = Color(0xFF4ADE80);
}

// ── Social / Third Party ─────────────────────────────────────────────────

/// Branding colors for external services.
abstract final class SocialColors {
  /// Google - Background (Light).
  static const Color googleBgLight = Color(0xFFFFFFFF);

  /// Google - Background (Dark).
  static const Color googleBgDark = Color(0xFF131314);

  /// Google - Border (Light).
  static const Color googleOutlineLight = Color(0xFF747775);

  /// Google - Border (Dark).
  static const Color googleOutlineDark = Color(0xFF8E918F);

  /// Google - Text (Light).
  static const Color googleTextLight = Color(0xFF1F1F1F);

  /// Google - Text (Dark).
  static const Color googleTextDark = Color(0xFFE3E3E3);
}
