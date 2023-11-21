import 'package:fitness_app/app/theme/app_colors.dart';
import 'package:fitness_app/app/theme/app_text_style.dart';
import 'package:flutter/material.dart';

/// App Theme Definitions
final class AppTheme {
  /// Standard `ThemeData` for App UI.
  static final ThemeData _baseTheme = ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: _textTheme,
  );

  static final ThemeData lightTheme = _baseTheme.copyWith(
    colorScheme: AppColors.lightColorScheme,
  );

  static final ThemeData darkTheme = _baseTheme.copyWith(
    colorScheme: AppColors.darkColorScheme,
  );
  static final TextTheme _textTheme = TextTheme(
    displayLarge: AppTextStyle.displayLarge,
    displayMedium: AppTextStyle.displayMedium,
    displaySmall: AppTextStyle.displaySmall,
    headlineLarge: AppTextStyle.headlineLarge,
    headlineMedium: AppTextStyle.headlineMedium,
    headlineSmall: AppTextStyle.headlineSmall,
    titleLarge: AppTextStyle.titleLarge,
    titleMedium: AppTextStyle.titleMedium,
    titleSmall: AppTextStyle.titleSmall,
    bodyLarge: AppTextStyle.bodyLarge,
    bodyMedium: AppTextStyle.bodyMedium,
    bodySmall: AppTextStyle.bodySmall,
    labelLarge: AppTextStyle.labelLarge,
    labelMedium: AppTextStyle.labelMedium,
    labelSmall: AppTextStyle.labelSmall,
  );

  static const double defaultRadius = 16;
  static const double defaultNavBarHeight = 80;
  static final double defaultAppBarHeight = AppBar().preferredSize.height;
  static final BorderRadius defaultBoardRadius = BorderRadius.circular(defaultRadius);
  static const List<BoxShadow> defaultBoxShadow = <BoxShadow>[
    BoxShadow(
      color: AppColors.defaultBoxShadow,
      offset: Offset(0, 6),
      blurRadius: 16,
    ),
  ];
}
