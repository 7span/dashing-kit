import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(
  name: 'Interactive AppAlertDialog',
  type: AppAlertDialog,
)
Widget interactiveAppAlertDialog(BuildContext context) {
  final knobs = context.knobs;

  final title = knobs.string(
    label: 'Title',
    initialValue: 'Alert Dialog Title',
  );

  final content = knobs.string(
    label: 'Content',
    initialValue: 'This is the content of the alert dialog.',
  );

  final leftText = knobs.string(
    label: 'Left Button Text',
    initialValue: 'Cancel',
  );

  final rightText = knobs.string(
    label: 'Right Button Text',
    initialValue: 'Ok',
  );

  final leftButtonPressed = knobs.boolean(
    label: 'Left Button Pressed',
    initialValue: false,
  );

  final rightButtonPressed = knobs.boolean(
    label: 'Right Button Pressed',
    initialValue: false,
  );

  if (leftButtonPressed) {
    print('Left Button Pressed');
  }

  if (rightButtonPressed) {
    print('Right Button Pressed');
  }

  return AppScaffold(
    backgroundColor: context.colorScheme.grey300,

    body: AppAlertDialog(
      title: title,
      content: content,
      leftText: leftText,
      rightText: rightText,
      onLeftOptionTap: () {
        if (leftButtonPressed) {
          print('Left button action executed');
        }
      },
      onRightOptionTap: () {
        if (rightButtonPressed) {
          print('Right button action executed');
        }
      },
    ),
  );
}
