import 'package:app_ui/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum AppTextLevel { paragraph, title }

class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.level = AppTextLevel.paragraph,
  });

  const AppText.paragraph(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.paragraph;

  const AppText.title(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.title;

  final String data;
  final AppTextLevel level;
  final Color? color;
  final double? fontSize;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.maybeOf(context);
    final color = this.color ?? theme?.colors.foreground;
    final style = () {
      switch (level) {
        case AppTextLevel.paragraph:
          return theme?.typography.paragraph;
        case AppTextLevel.title:
          return theme?.typography.title;
      }
    }();
    return Text(
      data,
      style: style?.copyWith(
        color: color,
        fontSize: fontSize,
      ),
      maxLines: maxLines,
    );
  }
}
