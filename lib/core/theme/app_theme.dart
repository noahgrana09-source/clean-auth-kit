import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Configuración de temas de la aplicación.
///
/// Provee [ThemeData] para Material (Android) y
/// [CupertinoThemeData] para iOS, ambos alineados con la misma
/// paleta de [AppColors].
///
/// Uso en [MaterialApp]:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///   themeMode: ThemeMode.system,
/// )
/// ```
abstract final class AppTheme {
  // ── Material ─────────────────────────────────────────────────────────────

  /// Tema claro de Material (Android).
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: _lightColorScheme,
    textTheme: AppTextStyles.lightTextTheme,
    scaffoldBackgroundColor: AppColorsLight.background,
    cardColor: AppColorsLight.surface,
    dividerColor: AppColorsLight.outline,
    inputDecorationTheme: _lightInputDecoration,
    elevatedButtonTheme: _elevatedButtonTheme(
      foreground: Colors.white,
      background: AppColors.brand,
    ),
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsLight.surface,
      foregroundColor: AppColorsLight.textPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.brand
            : Colors.transparent,
      ),
    ),
  );

  /// Tema oscuro de Material (Android).
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _darkColorScheme,
    textTheme: AppTextStyles.darkTextTheme,
    scaffoldBackgroundColor: AppColorsDark.background,
    cardColor: AppColorsDark.surface,
    dividerColor: AppColorsDark.outline,
    inputDecorationTheme: _darkInputDecoration,
    elevatedButtonTheme: _elevatedButtonTheme(
      foreground: Colors.white,
      background: AppColors.brand,
    ),
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsDark.surface,
      foregroundColor: AppColorsDark.textPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.brand
            : Colors.transparent,
      ),
    ),
  );

  // ── Cupertino ────────────────────────────────────────────────────────────

  /// Tema claro de Cupertino (iOS).
  static CupertinoThemeData get cupertinoLight => const CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.brand,
    primaryContrastingColor: Colors.white,
    barBackgroundColor: AppColorsLight.surface,
    scaffoldBackgroundColor: AppColorsLight.background,
    textTheme: CupertinoTextThemeData(
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
    ),
  );

  /// Tema oscuro de Cupertino (iOS).
  static CupertinoThemeData get cupertinoDark => const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.brand,
    primaryContrastingColor: Colors.white,
    barBackgroundColor: AppColorsDark.surface,
    scaffoldBackgroundColor: AppColorsDark.background,
    textTheme: CupertinoTextThemeData(
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
    ),
  );

  // ── Private helpers ───────────────────────────────────────────────────────

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.brand,
    onPrimary: Colors.white,
    primaryContainer: AppColors.brandLight,
    onPrimaryContainer: AppColors.brandDark,
    secondary: AppColors.brandLight,
    onSecondary: AppColors.brand,
    secondaryContainer: AppColors.brandLight,
    onSecondaryContainer: AppColors.brandDark,
    error: AppColorsLight.error,
    onError: Colors.white,
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF991B1B),
    surface: AppColorsLight.surface,
    onSurface: AppColorsLight.textPrimary,
    surfaceContainerHighest: AppColorsLight.surfaceVariant,
    onSurfaceVariant: AppColorsLight.textSecondary,
    outline: AppColorsLight.outline,
    outlineVariant: AppColorsLight.outline,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.brand,
    onPrimary: Colors.white,
    primaryContainer: AppColors.brandDark,
    onPrimaryContainer: AppColors.brandLight,
    secondary: AppColors.brandDark,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.brandDark,
    onSecondaryContainer: AppColors.brandLight,
    error: AppColorsDark.error,
    onError: Colors.white,
    errorContainer: Color(0xFF7F1D1D),
    onErrorContainer: Color(0xFFFECACA),
    surface: AppColorsDark.surface,
    onSurface: AppColorsDark.textPrimary,
    surfaceContainerHighest: AppColorsDark.surfaceVariant,
    onSurfaceVariant: AppColorsDark.textSecondary,
    outline: AppColorsDark.outline,
    outlineVariant: AppColorsDark.outline,
  );

  static InputDecorationTheme get _lightInputDecoration => InputDecorationTheme(
    filled: true,
    fillColor: AppColorsLight.surfaceVariant,
    hintStyle: AppTextStyles.bodyMedium.copyWith(
      color: AppColorsLight.textDisabled,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColorsLight.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColorsLight.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.brand, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColorsLight.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColorsLight.error, width: 2),
    ),
  );

  static InputDecorationTheme get _darkInputDecoration => InputDecorationTheme(
    filled: true,
    fillColor: AppColorsDark.surfaceVariant,
    hintStyle: AppTextStyles.bodyMedium.copyWith(
      color: AppColorsDark.textDisabled,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColorsDark.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColorsDark.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.brand, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColorsDark.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColorsDark.error, width: 2),
    ),
  );

  static ElevatedButtonThemeData _elevatedButtonTheme({
    required Color foreground,
    required Color background,
  }) => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: foreground,
      backgroundColor: background,
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: AppTextStyles.labelLarge,
      elevation: 0,
    ),
  );

  static OutlinedButtonThemeData get _outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brand,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.brand),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      );

  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.brand,
      textStyle: AppTextStyles.labelLarge,
    ),
  );
}
