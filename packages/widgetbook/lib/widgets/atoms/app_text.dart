import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(name: 'Interactive AppText', type: AppText)
Widget interactiveAppText(BuildContext context) {
  final knobs = context.knobs;

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

  final color = knobs.color(
    label: 'Text Color',
    initialValue: Colors.black,
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
        case TextAlign.start:
          return 'Start';
        case TextAlign.end:
          return 'End';
        default:
          return 'Justify';
      }
    },
  );

  return AppScaffold(
    appBar: AppBar(title: const Text('Interactive AppText')),
    body: Container(
      color: Colors.white,
      width: double.infinity,
      child: AppText(
        text: 'This is a sample text.',
        level: level,
        textAlign: textAlign,
        color: color,
      ),
    ),
  );
}
