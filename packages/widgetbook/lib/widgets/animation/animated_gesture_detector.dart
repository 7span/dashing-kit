import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(
  name: 'Interactive',
  type: AnimatedGestureDetector,
)
Widget animatedGestureDetectorUseCase(BuildContext context) {
  final knobs = context.knobs;

  final tapText = knobs.string(
    label: 'Tap Text',
    initialValue: 'Tap Me!',
  );
  final longPressEnabled = knobs.boolean(
    label: 'Enable Long Press',
    initialValue: true,
  );

  return AppScaffold(
    body: Center(
      child: AnimatedGestureDetector(
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Tapped!')));
        },
        onLongPress:
            longPressEnabled
                ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Long Pressed!')),
                  );
                }
                : null,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            tapText,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    ),
  );
}
