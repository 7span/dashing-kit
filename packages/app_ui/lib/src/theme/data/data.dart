import 'package:app_ui/src/theme/data/colors.dart';
import 'package:app_ui/src/theme/data/typography.dart';
import 'package:equatable/equatable.dart';

class AppThemeData extends Equatable {
  const AppThemeData({
    required this.colors,
    required this.typography,
  });

  factory AppThemeData.regular() => AppThemeData(
        colors: AppColorsData.light(),
        typography: AppTypographyData.regular(),
      );
  final AppColorsData colors;
  final AppTypographyData typography;

  AppThemeData withColors(AppColorsData colors) {
    return AppThemeData(
      colors: colors,
      typography: typography,
    );
  }

  @override
  List<Object?> get props => [
        colors,
        typography,
        // icons,
      ];
}
