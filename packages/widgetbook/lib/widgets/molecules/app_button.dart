import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(
  name: 'All-in-One Button Showcase',
  type: AppButton,
)
Widget allInOneButtonShowcase(BuildContext context) {
  final buttonText = context.knobs.string(
    label: 'Button Text',
    initialValue: 'Click Me',
  );

  final buttonType = context.knobs.object.dropdown<ButtonType>(
    label: 'Button Type',
    options: ButtonType.values,
    initialOption: ButtonType.filled,
  );

  final isLoading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );
  final isEnabled = context.knobs.boolean(
    label: 'Enabled',
    initialValue: true,
  );
  final isRounded = context.knobs.boolean(
    label: 'Rounded Corners',
    initialValue: true,
  );
  final isExpanded = context.knobs.boolean(
    label: 'Expanded Width',
    initialValue: false,
  );

  final useCustomBgColor = context.knobs.boolean(
    label: 'Custom Background Color',
    initialValue: false,
  );
  final backgroundColor = context.knobs.color(
    label: 'Background Color',
    initialValue: Colors.blue,
  );

  final useCustomTextColor = context.knobs.boolean(
    label: 'Custom Text Color',
    initialValue: false,
  );
  final textColor = context.knobs.color(
    label: 'Text Color',
    initialValue: Colors.white,
  );

  final showIcon = context.knobs.boolean(
    label: 'Show Icon',
    initialValue: false,
  );
  final iconData = context.knobs.object.dropdown<IconData>(
    label: 'Icon',
    options: const [
      Icons.favorite,
      Icons.star,
      Icons.check,
      Icons.add,
      Icons.send,
      Icons.download,
    ],
    initialOption: Icons.favorite,
  );

  final containerType = context.knobs.object.dropdown<String>(
    label: 'Container Type',
    options: const ['None', 'Card', 'Column', 'Row'],
    initialOption: 'None',
  );

  final button = AppButton(
    text: buttonText,
    onPressed: isEnabled ? () {} : null,
    buttonType: buttonType,
    isLoading: isLoading,
    isRounded: isRounded,
    isExpanded: isExpanded,
    backgroundColor: useCustomBgColor ? backgroundColor : null,
    textColor: useCustomTextColor ? textColor : null,
    icon: showIcon ? Icon(iconData) : null,
  );

  Widget wrappedButton;

  switch (containerType) {
    case 'Card':
      wrappedButton = Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: button,
        ),
      );
      break;
    case 'Column':
      wrappedButton = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Button in Column'),
          const SizedBox(height: 16),
          button,
        ],
      );
      break;
    case 'Row':
      wrappedButton = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Button in Row'),
          const SizedBox(width: 16),
          button,
        ],
      );
      break;
    case 'None':
    default:
      wrappedButton = button;
  }

  return AppScaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: wrappedButton,
      ),
    ),
  );
}
