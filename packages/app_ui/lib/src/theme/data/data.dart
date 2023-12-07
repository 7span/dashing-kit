import 'package:app_ui/src/theme/data/colors.dart';
import 'package:app_ui/src/theme/data/typography.dart';
import 'package:equatable/equatable.dart';

class AppThemeData extends Equatable {
  const AppThemeData({
    required this.colors,
    // required this.icons,
    required this.typography,
  });

  factory AppThemeData.regular() => AppThemeData(
        colors: AppColorsData.dark(),
        // icons: AppIconsData.regular(),
        typography: AppTypographyData.regular(),
      );
  final AppColorsData colors;
  // final AppIconsData icons;
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
