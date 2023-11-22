import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class AppColorsData extends Equatable {
  const AppColorsData({
    required this.background,
    required this.foreground,
    required this.error,
  });

  factory AppColorsData.light() => const AppColorsData(
        foreground: Color(0xffffffff),
        background: Color(0xff000000),
        error: Color(0xffff0000),
      );

  factory AppColorsData.dark() => const AppColorsData(
        foreground: Color(0xffffffff),
        background: Color(0xff000000),
        error: Color(0xffff0000),
      );

  final Color background;
  final Color foreground;
  final Color error;
  @override
  List<Object?> get props => [background, foreground];
}
