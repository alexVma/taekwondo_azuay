import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_radii.dart';

abstract final class EliteMartialTheme {
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: EliteMartialColors.primary,
      onPrimary: EliteMartialColors.onPrimary,
      primaryContainer: EliteMartialColors.primaryContainer,
      onPrimaryContainer: EliteMartialColors.onPrimaryContainer,
      secondary: EliteMartialColors.secondary,
      onSecondary: EliteMartialColors.onSecondary,
      secondaryContainer: EliteMartialColors.secondaryContainer,
      onSecondaryContainer: EliteMartialColors.onSecondaryContainer,
      tertiary: EliteMartialColors.tertiary,
      onTertiary: EliteMartialColors.onTertiary,
      tertiaryContainer: EliteMartialColors.tertiaryContainer,
      onTertiaryContainer: EliteMartialColors.onTertiaryContainer,
      error: EliteMartialColors.error,
      onError: EliteMartialColors.onError,
      errorContainer: EliteMartialColors.errorContainer,
      onErrorContainer: EliteMartialColors.onErrorContainer,
      surface: EliteMartialColors.surface,
      onSurface: EliteMartialColors.onSurface,
      surfaceContainerLowest: EliteMartialColors.surfaceContainerLowest,
      surfaceContainerLow: EliteMartialColors.surfaceContainerLow,
      surfaceContainer: EliteMartialColors.surfaceContainer,
      surfaceContainerHigh: EliteMartialColors.surfaceContainerHigh,
      surfaceContainerHighest: EliteMartialColors.surfaceContainerHighest,
      outline: EliteMartialColors.outline,
      outlineVariant: EliteMartialColors.outlineVariant,
      inverseSurface: EliteMartialColors.inverseSurface,
      onInverseSurface: EliteMartialColors.inverseOnSurface,
      inversePrimary: EliteMartialColors.inversePrimary,
      surfaceTint: EliteMartialColors.surfaceTint,
    );

    final textTheme = _textTheme.apply(
      bodyColor: EliteMartialColors.onSurface,
      displayColor: EliteMartialColors.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: EliteMartialColors.background,
      fontFamily: 'Inter',
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: EliteMartialColors.primaryContainer,
        foregroundColor: EliteMartialColors.onPrimary,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: EliteMartialColors.onPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: EliteMartialColors.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: EliteMartialRadii.card,
          side: const BorderSide(color: Color(0xffe9ecef)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: EliteMartialColors.secondaryContainer,
          foregroundColor: EliteMartialColors.onSecondary,
          shape: RoundedRectangleBorder(borderRadius: EliteMartialRadii.pill),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: EliteMartialColors.primaryContainer,
          side: const BorderSide(color: EliteMartialColors.primaryContainer),
          shape: RoundedRectangleBorder(borderRadius: EliteMartialRadii.pill),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: EliteMartialColors.surfaceContainerLowest,
        border: OutlineInputBorder(borderRadius: EliteMartialRadii.input),
        focusedBorder: OutlineInputBorder(
          borderRadius: EliteMartialRadii.input,
          borderSide: const BorderSide(
            color: EliteMartialColors.primaryContainer,
            width: 2,
          ),
        ),
      ),
    );
  }

  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 48,
      fontWeight: FontWeight.w800,
      height: 56 / 48,
      letterSpacing: 0,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 40 / 32,
      letterSpacing: 0,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Inter',
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 32 / 24,
      letterSpacing: 0,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 28 / 18,
      letterSpacing: 0,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Inter',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
      letterSpacing: 0,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 20 / 14,
      letterSpacing: .7,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Inter',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
      letterSpacing: 0,
    ),
  );
}
