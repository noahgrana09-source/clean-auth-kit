import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Application text styles.
///
/// Based on the Material 3 type scale.
/// All styles are available for light and dark
/// through [ThemeData.textTheme].
abstract final class AppTextStyles {
  // ── Display ──────────────────────────────────────────────────────────────

  /// Very large text for full-screen titles.
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  /// Large text for main headers.
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
  );

  // ── Headline ─────────────────────────────────────────────────────────────

  /// Main headline.
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.25,
  );

  /// Medium headline (section subtitles).
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
  );

  /// Small headline.
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
  );

  // ── Title ────────────────────────────────────────────────────────────────

  /// Large component title (AppBar, card header).
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
  );

  /// Medium component title.
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.50,
  );

  /// Small component title.
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // ── Body ─────────────────────────────────────────────────────────────────

  /// Main body text.
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
  );

  /// Secondary body text.
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  /// Small body text (captions, hints).
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // ── Label ────────────────────────────────────────────────────────────────

  /// Large label (buttons).
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  /// Medium label (chips, tabs).
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
  );

  /// Small label (badges, overlines).
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Builds a [TextTheme] for the light theme.
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

  /// Builds a [TextTheme] for the dark theme.
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

  static final CupertinoTextThemeData lightCupertinoTextTheme =
      CupertinoTextThemeData(
        primaryColor: AppColors.brand,
        textStyle: TextStyle(color: AppColorsLight.textPrimary, fontSize: 16),
        navTitleTextStyle: TextStyle(
          color: AppColorsLight.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        navLargeTitleTextStyle: TextStyle(
          color: AppColorsLight.textPrimary,
          fontSize: 34,
          fontWeight: FontWeight.w700,
        ),
      );

  static final CupertinoTextThemeData darkCupertinoTextTheme =
      CupertinoTextThemeData(
        primaryColor: AppColors.brand,
        textStyle: TextStyle(color: AppColorsDark.textPrimary, fontSize: 16),
        navTitleTextStyle: TextStyle(
          color: AppColorsDark.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        navLargeTitleTextStyle: TextStyle(
          color: AppColorsDark.textPrimary,
          fontSize: 34,
          fontWeight: FontWeight.w700,
        ),
      );
}
