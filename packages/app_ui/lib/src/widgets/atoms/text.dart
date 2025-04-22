// ignore_for_file: constant_identifier_names

import 'package:app_ui/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum AppTextLevel {
  title,
  subTitle,
  paragraph1,
  paragraph2,
  s,
  xsSemiBold,
  sSemiBold,
  XL,
  L,
  brand,
  regular10,
}

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    this.text,
    this.color,
    this.fontSize,
    this.maxLines,
    this.level = AppTextLevel.paragraph1,
    this.isUnderLine,
    this.style,
    this.textAlign,
  });

  const AppText.subTitle10({
    super.key,
    this.text,
    this.color,
    this.fontSize,
    this.maxLines,
    this.isUnderLine,
    this.style,
    this.textAlign,
  }) : level = AppTextLevel.subTitle;

  const AppText.regular10({
    super.key,
    this.text,
    this.color,
    this.fontSize,
    this.maxLines,
    this.isUnderLine,
    this.style,
    this.textAlign,
  }) : level = AppTextLevel.regular10;

  const AppText.paragraph({
    super.key,
    this.text,
    this.color,
    this.fontSize,
    this.maxLines,
    this.isUnderLine,
    this.style,
    this.textAlign,
  }) : level = AppTextLevel.paragraph1;

  const AppText.base({
    super.key,
    this.text,
    this.color,
    this.fontSize,
    this.maxLines,
    this.isUnderLine,
    this.style,
    this.textAlign,
  }) : level = AppTextLevel.title;

  const AppText.xs({
    super.key,
    this.text,
    this.color,
    this.fontSize,
    this.maxLines,
    this.isUnderLine,
    this.style,
    this.textAlign,
  }) : level = AppTextLevel.paragraph1;

  const AppText.xsRegular({
    super.key,
    this.text,
    this.color,
    this.fontSize,
    this.maxLines,
    this.isUnderLine,
    this.style,
    this.textAlign,
  }) : level = AppTextLevel.paragraph2;

  const AppText.sSemiBold({
    super.key,
    this.text,
    this.color,
    this.fontSize,
    this.maxLines,
    this.isUnderLine,
    this.style,
    this.textAlign,
  }) : level = AppTextLevel.sSemiBold;

  const AppText.L({
    super.key,
    this.text,
    this.color,
    this.fontSize,
    this.maxLines,
    this.isUnderLine,
    this.style,
    this.textAlign,
  }) : level = AppTextLevel.L;

  // ignore: non_constant_identifier_names
  const AppText.XL({
    super.key,
    this.text,
    this.color,
    this.fontSize,
    this.maxLines,
    this.isUnderLine,
    this.style,
    this.textAlign,
  }) : level = AppTextLevel.XL;

  const AppText.xsSemiBold({
    super.key,
    this.text,
    this.color,
    this.fontSize,
    this.maxLines,
    this.isUnderLine,
    this.style,
    this.textAlign,
  }) : level = AppTextLevel.xsSemiBold;

  const AppText.s({
    super.key,
    this.text,
    this.color,
    this.fontSize,
    this.maxLines,
    this.isUnderLine,
    this.style,
    this.textAlign,
  }) : level = AppTextLevel.s;

  /// Use this text in case you want to write something in Vepaar logo's font style
  const AppText.brand({
    super.key,
    this.text,
    this.color,
    this.fontSize,
    this.maxLines,
    this.isUnderLine,
    this.style,
    this.textAlign,
  }) : level = AppTextLevel.brand;

  final String? text;
  final AppTextLevel level;
  final Color? color;
  final double? fontSize;
  final int? maxLines;
  final bool? isUnderLine;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.maybeOf(context);
    final color =
        this.color ??
        () {
          switch (level) {
            case AppTextLevel.regular10:
              return theme?.colors.grey600;
            case AppTextLevel.paragraph1:
            case AppTextLevel.xsSemiBold:
              return theme?.colors.grey500;
            case AppTextLevel.paragraph2:
            case AppTextLevel.sSemiBold:
              return theme?.colors.grey700;
            case AppTextLevel.subTitle:
              return theme?.colors.grey500;
            case AppTextLevel.title:
            case AppTextLevel.s:
            case AppTextLevel.L:
            case AppTextLevel.XL:
            case AppTextLevel.brand:
              return theme?.colors.black;
          }
        }();
    final textStyle = () {
      switch (level) {
        case AppTextLevel.regular10:
          return theme?.typography.regular10;
        case AppTextLevel.title:
          return theme?.typography.title;
        case AppTextLevel.subTitle:
          return theme?.typography.subTitle10;
        case AppTextLevel.paragraph1:
          return theme?.typography.paragraph1;
        case AppTextLevel.paragraph2:
          return theme?.typography.xsRegular;
        case AppTextLevel.s:
          return theme?.typography.S;
        case AppTextLevel.xsSemiBold:
          return theme?.typography.xsSemiBold;
        case AppTextLevel.sSemiBold:
          return theme?.typography.sSemiBold;
        case AppTextLevel.L:
          return theme?.typography.L;
        case AppTextLevel.XL:
          return theme?.typography.XL;
        case AppTextLevel.brand:
          return theme?.typography.brand;
      }
    }();
    return Text(
      text ?? '',
      textAlign: textAlign,
      style: textStyle
          ?.copyWith(
            color: color,
            fontSize: fontSize,
            decoration:
                isUnderLine ?? false
                    ? TextDecoration.underline
                    : null,
            decorationColor: color,
          )
          .merge(style),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
