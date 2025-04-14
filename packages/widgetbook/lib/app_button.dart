import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(name: 'with green color', type: AppButton)
Widget greenContainerUseCase(BuildContext context) {
  return Center(
    child: AppButton(
      text: 'Text',
      onPressed: () {},
      backgroundColor: Colors.green,
    ),
  );
}

@widgetbook.UseCase(name: 'with red color', type: AppButton)
Widget redContainerUseCase(BuildContext context) {
  return Center(
    child: AppButton(
      text: 'Text',
      onPressed: () {},
      backgroundColor: Colors.red,
    ),
  );
}
