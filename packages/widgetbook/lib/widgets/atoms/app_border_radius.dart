import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Interactive Border Radius', type: AppBorderRadius)
Widget interactiveAppBorderRadius(BuildContext context) {
  final knobs = context.knobs;

  // Knobs to dynamically select border radius values
  final borderRadiusValue = knobs.list<double>(
    label: 'Border Radius',
    options: [
      AppBorderRadius.zero,
      AppBorderRadius.xsmall4,
      AppBorderRadius.small8,
      AppBorderRadius.medium16,
      AppBorderRadius.big44,
    ],
    initialOption: AppBorderRadius.medium16,
    labelBuilder: (radius) {
      switch (radius) {
        case AppBorderRadius.zero:
          return 'Zero';
        case AppBorderRadius.xsmall4:
          return 'Xsmall 4';
        case AppBorderRadius.small8:
          return 'Small 8';
        case AppBorderRadius.medium16:
          return 'Medium 16';
        case AppBorderRadius.big44:
          return 'Big 44';
        default:
          return 'Unknown';
      }
    },
  );

  // Sample widget to apply the border radius
  return AppScaffold(
    appBar: const CustomAppBar(title: 'Interactive Border Radius'),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        child: Center(
          child: Text('Border Radius: $borderRadiusValue', style: TextStyle(color: Colors.white)),
        ),
      ),
    ),
  );
}
