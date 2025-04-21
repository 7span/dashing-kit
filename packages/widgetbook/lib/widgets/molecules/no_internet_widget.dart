import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(
  name: 'Interactive No Internet Widget',
  type: NoInternetWidget,
)
Widget interactiveNoInternetWidget(BuildContext context) {
  // Knobs for customizing the NoInternetWidget
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'No Internet Connection',
  );

  final description = context.knobs.string(
    label: 'Description',
    initialValue:
        'Please check your internet connection and try again.',
  );

  final backgroundColor = context.knobs.color(
    label: 'Background Color',
    initialValue: Colors.white,
  );

  return AppScaffold(
    body: Stack(
      children: [
        // Background color demonstration
        Container(
          color: backgroundColor,
          child: const Placeholder(), // Placeholder as background
        ),
        NoInternetWidget(title: title, description: description),
      ],
    ),
  );
}
