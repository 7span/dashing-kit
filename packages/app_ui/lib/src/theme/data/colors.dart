// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class AppColorsData extends Equatable {
  const AppColorsData({
    required this.black,
    required this.white,
    required this.foreground,
    required this.background,
    required this.error,
    required this.info100,
    required this.success50,
    required this.success500,
    required this.success600,
    required this.danger50,
    required this.danger500,
    required this.danger700,
    required this.warning500,
    required this.warning600,
    required this.primary50,
    required this.primary100,
    required this.primary400,
    required this.primary500,
    required this.primary600,
    required this.primary900,
    required this.primary1000,
    required this.grey50,
    required this.grey100,
    required this.grey200,
    required this.grey300,
    required this.grey400,
    required this.grey500,
    required this.grey600,
    required this.grey700,
    required this.grey800,
  });

  factory AppColorsData.light() => const AppColorsData(
        foreground: Color(0xffffffff),
        black: Color(0xff000000),
        white: Color(0xffffffff),
        error: Color(0xffff0000),
        grey50: Color(0xffFAFAFA),
        grey100: Color(0xffF4F4F5),
        grey200: Color(0xffE4E4E7),
        grey300: Color(0xffD1D5DB),
        grey400: Color(0xffA1A1AA),
        grey500: Color(0xff71717A),
        grey600: Color(0xff52525B),
        grey700: Color(0xff3F3F46),
        grey800: Color(0xff27272A),
        background: Color(0xFFF0F4F7),
        info100: Color(0xFFDBEAFE),
        primary50: Color(0xFFF5F6FF),
        primary100: Color(0xFFD5DEFE),
        primary400: Color(0xFF637DFE),
        primary500: Color(0xFF304FFE),
        primary600: Color(0xFF233BDA),
        primary900: Color(0xFF091379),
        primary1000: Color(0xFF00053B),
        success50: Color(0xffF0FDF4),
        success500: Color(0xff22C55E),
        success600: Color(0xff16A34A),
        danger50: Color(0xffFEF2F2),
        danger500: Color(0xffEF4444),
        danger700: Color(0xffB91C1C),
        warning500: Color(0xffEAB308),
        warning600: Color(0xffEAB308),
      );

  factory AppColorsData.dark() => const AppColorsData(
        foreground: Color(0xffffffff),
        black: Color(0xff000000),
        white: Color(0xffffffff),
        error: Color(0xffff0000),
        grey50: Color(0xffFAFAFA),
        grey100: Color(0xffF4F4F5),
        grey200: Color(0xffE4E4E7),
        grey300: Color(0xffD1D5DB),
        grey400: Color(0xffA1A1AA),
        grey500: Color(0xff71717A),
        grey600: Color(0xff52525B),
        grey700: Color(0xff3F3F46),
        grey800: Color(0xff27272A),
        background: Color(0xFFF0F4F7),
        info100: Color(0xFFDBEAFE),
        primary50: Color(0xFFF5F6FF),
        primary100: Color(0xFFD5DEFE),
        primary400: Color(0xFF637DFE),
        primary500: Color(0xFF304FFE),
        primary600: Color(0xFF233BDA),
        success50: Color(0xffF0FDF4),
        success600: Color(0xff16A34A),
        primary900: Color(0xFF091379),
        primary1000: Color(0xFF00053B),
        danger50: Color(0xffFEF2F2),
        danger500: Color(0xffEF4444),
        danger700: Color(0xffB91C1C),
        warning500: Color(0xffEAB308),
        warning600: Color(0xffEAB308),
        success500: Color(0xff22C55E),
      );

  final Color black;
  final Color white;
  final Color background;
  final Color foreground;
  final Color error;
  final Color info100;
  final Color success50;
  final Color danger50;
  final Color danger500;
  final Color danger700;
  final Color warning500;
  final Color warning600;
  final Color success500;
  final Color success600;
  final Color primary50;
  final Color primary100;
  final Color primary400;
  final Color primary500;
  final Color primary600;
  final Color primary900;
  final Color primary1000;
  final Color grey50;
  final Color grey100;
  final Color grey200;
  final Color grey300;
  final Color grey400;
  final Color grey500;
  final Color grey600;
  final Color grey700;
  final Color grey800;

  @override
  List<Object> get props {
    return [
      black,
      white,
      background,
      foreground,
      error,
      info100,
      success50,
      danger50,
      danger500,
      danger700,
      warning500,
      warning600,
      success500,
      success600,
      primary50,
      primary100,
      primary400,
      primary500,
      primary600,
      primary900,
      primary1000,
      grey50,
      grey100,
      grey200,
      grey300,
      grey400,
      grey500,
      grey600,
      grey700,
      grey800,
    ];
  }
}
