import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(name: 'Interactive AppText', type: AppText)
Widget interactiveAppText(BuildContext context) {
  final knobs = context.knobs;

  // Knobs to dynamically select the text level
  final level = knobs.list<AppTextLevel>(
    label: 'Text Level',
    options: AppTextLevel.values,
    initialOption: AppTextLevel.title,
    labelBuilder: (level) {
      switch (level) {
        case AppTextLevel.title:
          return 'Title';
        case AppTextLevel.subTitle:
          return 'Subtitle';
        case AppTextLevel.paragraph1:
          return 'Paragraph 1';
        case AppTextLevel.paragraph2:
          return 'Paragraph 2';
        case AppTextLevel.s:
          return 'S';
        case AppTextLevel.xsSemiBold:
          return 'XS SemiBold';
        case AppTextLevel.sSemiBold:
          return 'S SemiBold';
        case AppTextLevel.XL:
          return 'XL';
        case AppTextLevel.L:
          return 'L';
        case AppTextLevel.brand:
          return 'Brand';
        case AppTextLevel.regular10:
          return 'Regular 10';
      }
    },
  );

  // Knobs to adjust other properties like font size, color, and text alignment
  final fontSize = knobs.double.slider(
    label: 'Font Size',
    initialValue: 16.0,
    min: 10.0,
    max: 40.0,
  );

  final color = knobs.color(
    label: 'Text Color',
    initialValue: Colors.white,
  );

  final textAlign = knobs.list<TextAlign>(
    label: 'Text Align',
    options: TextAlign.values,

    labelBuilder: (alignment) {
      switch (alignment) {
        case TextAlign.left:
          return 'Left';
        case TextAlign.center:
          return 'Center';
        case TextAlign.right:
          return 'Right';
        default:
          return 'Justify';
      }
    },
  );

  return AppScaffold(
    appBar: AppBar(title: const Text('Interactive AppText')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppText(
        text: 'This is a sample text.',
        level: level,
        fontSize: fontSize,
        color: color,
        textAlign: textAlign,
      ),
    ),
  );
}
