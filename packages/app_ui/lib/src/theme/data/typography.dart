// ignore_for_file: non_constant_identifier_names

import 'package:app_ui/src/gen/fonts.gen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class AppTypographyData extends Equatable {
  const AppTypographyData({
    required this.title,
    required this.subTitle10,
    required this.paragraph1,
    required this.xsRegular,
    required this.S,
    required this.xsSemiBold,
    required this.sSemiBold,
    required this.XL,
    required this.L,
    required this.brand,
    required this.regular10,
  });

  factory AppTypographyData.regular() => const AppTypographyData(
    title: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      package: _packageName,
      fontFamily: FontFamily.opensans,
    ),
    subTitle10: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      package: _packageName,
      fontFamily: FontFamily.opensans,
    ),
    paragraph1: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      package: _packageName,
      fontFamily: FontFamily.opensans,
    ),
    xsRegular: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      package: _packageName,
      fontFamily: FontFamily.opensans,
    ),
    S: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      package: _packageName,
      fontFamily: FontFamily.opensans,
    ),
    xsSemiBold: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      package: _packageName,
      fontFamily: FontFamily.opensans,
    ),
    sSemiBold: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      package: _packageName,
      fontFamily: FontFamily.opensans,
    ),
    L: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      package: _packageName,
      fontFamily: FontFamily.opensans,
    ),
    XL: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      package: _packageName,
      fontFamily: FontFamily.opensans,
    ),
    brand: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w600,
      package: _packageName,
      letterSpacing: -2,
      fontFamily: FontFamily.opensans,
    ),
    regular10: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      package: _packageName,
      fontFamily: FontFamily.opensans,
    ),
  );

  static const _packageName = 'app_ui';

  final TextStyle title;
  final TextStyle subTitle10;
  final TextStyle paragraph1;
  final TextStyle xsRegular;
  final TextStyle S;
  final TextStyle xsSemiBold;
  final TextStyle sSemiBold;
  final TextStyle L;
  final TextStyle XL;
  final TextStyle regular10;
  final TextStyle brand;

  @override
  List<Object?> get props => [
    title,
    subTitle10,
    paragraph1,
    xsRegular,
    xsSemiBold,
    regular10,
    sSemiBold,
    L,
    XL,
    brand,
  ];
}
