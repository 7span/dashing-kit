import 'package:flutter/material.dart';

/// Defines the color palette for the UI.
final class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  /// Default colors for shimmer
  static const Color lightShimmerHighlight = Color(0xffE6E8EB);
  static const Color darkShimmerHighlight = Color(0xff2A2C2E);
  static const Color lightShimmerBase = Color(0xffF9F9FB);
  static const Color darkShimmerBase = Color(0xff3A3E3F);

  /// Text url default color
  static const Color defaultTextUrl = Colors.lightBlue;
  static const Color defaultBoxShadow = Color(0x1F000000);

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0061A4),
    onPrimary: AppColors.white,
    primaryContainer: Color(0xFFD1E4FF),
    onPrimaryContainer: Color(0xFF001D36),
    secondary: Color(0xFF535F70),
    onSecondary: AppColors.white,
    secondaryContainer: Color(0xFFD7E3F7),
    onSecondaryContainer: Color(0xFF101C2B),
    tertiary: Color(0xFF6B5778),
    onTertiary: AppColors.white,
    tertiaryContainer: Color(0xFFF2DAFF),
    onTertiaryContainer: Color(0xFF251431),
    error: Color(0xFFBA1A1A),
    onError: AppColors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFDFCFF),
    onBackground: Color(0xFF1A1C1E),
    surface: Color(0xFFFDFCFF),
    onSurface: Color(0xFF1A1C1E),
    surfaceVariant: Color(0xFFDFE2EB),
    onSurfaceVariant: Color(0xFF43474E),
    outline: Color(0xFF73777F),
    outlineVariant: Color(0xFFC3C7CF),
    shadow: AppColors.black,
    scrim: AppColors.black,
    inverseSurface: Color(0xFF2F3033),
    onInverseSurface: Color(0xFFF1F0F4),
    inversePrimary: Color(0xFF9ECAFF),
    surfaceTint: Color(0xFF0061A4),
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF9ECAFF),
    onPrimary: Color(0xFF003258),
    primaryContainer: Color(0xFF00497D),
    onPrimaryContainer: Color(0xFFD1E4FF),
    secondary: Color(0xFFBBC7DB),
    onSecondary: Color(0xFF253140),
    secondaryContainer: Color(0xFF3B4858),
    onSecondaryContainer: Color(0xFFD7E3F7),
    tertiary: Color(0xFFD6BEE4),
    onTertiary: Color(0xFF3B2948),
    tertiaryContainer: Color(0xFF523F5F),
    onTertiaryContainer: Color(0xFFF2DAFF),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1A1C1E),
    onBackground: Color(0xFFE2E2E6),
    surface: Color(0xFF1A1C1E),
    onSurface: Color(0xFFE2E2E6),
    surfaceVariant: Color(0xFF43474E),
    onSurfaceVariant: Color(0xFFC3C7CF),
    outline: Color(0xFF8D9199),
    outlineVariant: Color(0xFF43474E),
    shadow: AppColors.black,
    scrim: AppColors.black,
    inverseSurface: Color(0xFFE2E2E6),
    onInverseSurface: Color(0xFF1A1C1E),
    inversePrimary: Color(0xFF0061A4),
    surfaceTint: Color(0xFF9ECAFF),
  );
}
