import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Interactive Padding', type: AppPadding)
Widget interactiveAppPadding(BuildContext context) {
  final knobs = context.knobs;

  final padding = knobs.list<double>(
    label: 'Padding',
    options: [
      Insets.zero,
      Insets.xxsmall4,
      Insets.xsmall8,
      Insets.small12,
      Insets.medium16,
      Insets.medium20,
      Insets.large24,
      Insets.xlarge32,
      Insets.xxlarge40,
      Insets.xxxlarge66,
      Insets.xxxxlarge80,
      Insets.infinity,
    ],
    labelBuilder: (paddingValue) {
      if (paddingValue == Insets.xxsmall4) return 'xxsmall (4)';
      if (paddingValue == Insets.xsmall8) return 'xsmall (8)';
      if (paddingValue == Insets.small12) return 'Small (12)';
      if (paddingValue == Insets.medium16) return 'Medium (16)';
      if (paddingValue == Insets.medium20) return 'Medium (20)';
      if (paddingValue == Insets.large24) return 'Large (24)';
      if (paddingValue == Insets.xlarge32) return 'Extra Large (32)';
      if (paddingValue == Insets.xxlarge40) {
        return 'xExtra Large (40)';
      }
      if (paddingValue == Insets.xxxlarge66) {
        return 'xxExtra Large (40)';
      }
      if (paddingValue == Insets.xxxxlarge80) {
        return 'xxxExtra Large (40)';
      }
      if (paddingValue == Insets.infinity) return 'infinity';
      return 'Zero (0)';
    },
  );

  return AppScaffold(
    appBar: CustomAppBar(title: 'Interactive AppPadding'),
    body: Center(
      child: Container(
        color: Colors.red,
        child: AppPadding(
          padding: EdgeInsets.all(padding),
          child: const Text('This text has dynamic padding!'),
        ),
      ),
    ),
  );
}
