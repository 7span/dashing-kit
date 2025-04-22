import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(
  name: 'All-in-One Showcase',
  type: AppCircularProgressIndicator,
)
Widget allInOneCircularProgressIndicator(BuildContext context) {
  final useCustomColor = context.knobs.boolean(
    label: 'Use Custom Color',
    initialValue: false,
  );

  final selectedColorName = context.knobs.list<String>(
    label: 'Color',
    options: const [
      'Primary',
      'Red',
      'Green',
      'Blue',
      'Orange',
      'Purple',
    ],
    initialOption: 'Primary',
  );

  Color? selectedColor;
  switch (selectedColorName) {
    case 'Red':
      selectedColor = Colors.red;
      break;
    case 'Green':
      selectedColor = Colors.green;
      break;
    case 'Blue':
      selectedColor = Colors.blue;
      break;
    case 'Orange':
      selectedColor = Colors.orange;
      break;
    case 'Purple':
      selectedColor = Colors.purple;
      break;
    case 'Primary':
    default:
      selectedColor = null;
      break;
  }

  final customColor = context.knobs.color(
    label: 'Custom Color',
    initialValue: Colors.teal,
  );

  final selectedSize = context.knobs.list<String>(
    label: 'Size',
    options: const [
      'Tiny',
      'Small',
      'Regular',
      'Large',
      'Extra Large',
      'Custom',
    ],
    initialOption: 'Regular',
  );

  final customStrokeWidthStr = context.knobs.string(
    label: 'Custom Stroke Width',
    initialValue: '3',
    description: 'Enter a value between 0.5 and 10',
  );

  double customStrokeWidth = 3;
  try {
    customStrokeWidth = double.parse(customStrokeWidthStr);
  } catch (_) {}

  double strokeWidth;
  switch (selectedSize) {
    case 'Tiny':
      strokeWidth = 1;
      break;
    case 'Small':
      strokeWidth = 2;
      break;
    case 'Regular':
      strokeWidth = 3;
      break;
    case 'Large':
      strokeWidth = 5;
      break;
    case 'Extra Large':
      strokeWidth = 8;
      break;
    case 'Custom':
      strokeWidth = customStrokeWidth;
      break;
    default:
      strokeWidth = 3;
      break;
  }

  final layout = context.knobs.list<String>(
    label: 'Layout Example',
    options: const [
      'Plain Centered',
      'Button Loading',
      'Card Loading',
      'Full Screen Overlay',
    ],
    initialOption: 'Plain Centered',
  );

  final indicator = AppCircularProgressIndicator(
    strokeWidth: strokeWidth,
    color: useCustomColor ? customColor : selectedColor,
  );

  switch (layout) {
    case 'Button Loading':
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: ElevatedButton(
            onPressed: null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 20, height: 20, child: indicator),
                const SizedBox(width: 8),
                const Text('Loading...'),
              ],
            ),
          ),
        ),
      );
    case 'Card Loading':
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 300),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Loading Data',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  indicator,
                  const SizedBox(height: 16),
                  const Text(
                    'Please wait while we fetch your data...',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    case 'Full Screen Overlay':
      return Stack(
        children: [
          const Center(child: Text('Content behind loading overlay')),
          Container(
            color: Colors.black.withAlpha(30),
            alignment: Alignment.center,
            child: AppCircularProgressIndicator(
              color: useCustomColor ? customColor : Colors.white,
              strokeWidth: strokeWidth,
            ),
          ),
        ],
      );
    case 'Plain Centered':
    default:
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: indicator,
        ),
      );
  }
}
