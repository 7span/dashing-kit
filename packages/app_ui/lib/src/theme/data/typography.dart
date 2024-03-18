// ignore_for_file: non_constant_identifier_names

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
        ),
        subTitle10: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          package: _packageName,
        ),
        paragraph1: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          package: _packageName,
        ),
        xsRegular: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          package: _packageName,
        ),
        S: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          package: _packageName,
        ),
        xsSemiBold: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          package: _packageName,
        ),
        sSemiBold: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          package: _packageName,
        ),
        L: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          package: _packageName,
        ),
        XL: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          package: _packageName,
        ),
        brand: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          package: _packageName,
          letterSpacing: -2,
        ),
        regular10: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          package: _packageName,
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
