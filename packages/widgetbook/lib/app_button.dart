import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(name: 'Interactive AppButton', type: AppButton)
Widget interactiveAppButton(BuildContext context) {
  // Text knob
  final buttonText = context.knobs.string(
    label: 'Button Text',
    initialValue: 'Click Me',
  );

  // Button type knob
  final buttonType = context.knobs.list(
    label: 'Button Type',
    options: ButtonType.values,
    initialOption: ButtonType.filled,
  );

  // Background color knob
  final useCustomBgColor = context.knobs.boolean(
    label: 'Use Custom Background Color',
    initialValue: false,
  );

  final bgColor = context.knobs.color(
    label: 'Background Color',
    initialValue: Colors.blue,
  );

  // Text color knob
  final useCustomTextColor = context.knobs.boolean(
    label: 'Use Custom Text Color',
    initialValue: false,
  );

  final textColor = context.knobs.color(
    label: 'Text Color',
    initialValue: Colors.white,
  );

  // Loading state knob
  final isLoading = context.knobs.boolean(
    label: 'Loading State',
    initialValue: false,
  );

  // Rounded corners knob
  final isRounded = context.knobs.boolean(
    label: 'Rounded Corners',
    initialValue: true,
  );

  // Expanded width knob
  final isExpanded = context.knobs.boolean(
    label: 'Expanded Width',
    initialValue: false,
  );

  // Icon knob
  final showIcon = context.knobs.boolean(
    label: 'Show Icon',
    initialValue: false,
  );

  // Icon selection knob (if showIcon is true)
  final iconData = context.knobs.list<IconData>(
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
    //enabled: showIcon,
  );

  return Center(
    child: Container(
      padding: const EdgeInsets.all(24),
      width: isExpanded ? double.infinity : null,
      child: AppButton(
        text: buttonText,
        onPressed: () {},
        buttonType: buttonType,
        isLoading: isLoading,
        isRounded: isRounded,
        isExpanded: isExpanded,
        backgroundColor: useCustomBgColor ? bgColor : null,
        textColor: useCustomTextColor ? textColor : null,
        icon: showIcon ? Icon(iconData) : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Button States', type: AppButton)
Widget buttonStates(BuildContext context) {
  // Button state options
  final isEnabled = context.knobs.boolean(
    label: 'Enabled',
    initialValue: true,
  );

  final isLoading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );

  final buttonType = context.knobs.list(
    label: 'Button Type',
    options: ButtonType.values,
    initialOption: ButtonType.filled,
  );

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton(
          text:
              isLoading
                  ? 'Loading...'
                  : (isEnabled
                      ? 'Enabled Button'
                      : 'Disabled Button'),
          onPressed: isEnabled ? () {} : null,
          isLoading: isLoading,
          buttonType: buttonType,
        ),
      ],
    ),
  );
}

// Button variants showcase
@widgetbook.UseCase(name: 'Button Types', type: AppButton)
Widget buttonTypes(BuildContext context) {
  final buttonType = context.knobs.list(
    label: 'Button Type',
    options: ButtonType.values,
    initialOption: ButtonType.filled,
  );

  final showIcon = context.knobs.boolean(
    label: 'Show Icon',
    initialValue: false,
  );

  final buttonText = context.knobs.string(
    label: 'Button Text',
    initialValue: 'Button Text',
  );

  return Center(
    child: AppButton(
      text: buttonText,
      onPressed: () {},
      buttonType: buttonType,
      icon: showIcon ? const Icon(Icons.star) : null,
    ),
  );
}

// Button size and styling
@widgetbook.UseCase(name: 'Button Styling', type: AppButton)
Widget buttonStyling(BuildContext context) {
  final isRounded = context.knobs.boolean(
    label: 'Rounded Corners',
    initialValue: true,
  );

  final isExpanded = context.knobs.boolean(
    label: 'Expanded Width',
    initialValue: false,
  );

  final buttonColor = context.knobs.color(
    label: 'Button Color',
    initialValue: Colors.blue,
  );

  final textColor = context.knobs.color(
    label: 'Text Color',
    initialValue: Colors.white,
  );

  return Container(
    padding: const EdgeInsets.all(16),
    width: double.infinity,
    child: Center(
      child: AppButton(
        text: 'Styled Button',
        onPressed: () {},
        isRounded: isRounded,
        isExpanded: isExpanded,
        backgroundColor: buttonColor,
        textColor: textColor,
      ),
    ),
  );
}

// Button in different containers
@widgetbook.UseCase(name: 'Container Variations', type: AppButton)
Widget containerVariations(BuildContext context) {
  final containerType = context.knobs.list<String>(
    label: 'Container Type',
    options: const ['None', 'Card', 'Column', 'Row'],
    initialOption: 'None',
  );

  final isExpanded = context.knobs.boolean(
    label: 'Is Button Expanded',
    initialValue: false,
  );

  Widget buttonWidget = AppButton(
    text: 'Container Button',
    onPressed: () {},
    isExpanded: isExpanded,
  );

  // Wrap the button in different containers based on selection
  switch (containerType) {
    case 'Card':
      return Center(
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: buttonWidget,
          ),
        ),
      );
    case 'Column':
      return Center(
        child: Container(
          color: Colors.grey.withOpacity(0.2),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Button in Column'),
              const SizedBox(height: 16),
              buttonWidget,
            ],
          ),
        ),
      );
    case 'Row':
      return Center(
        child: Container(
          color: Colors.grey.withOpacity(0.2),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Button in Row'),
              const SizedBox(width: 16),
              buttonWidget,
            ],
          ),
        ),
      );
    case 'None':
    default:
      return Center(child: buttonWidget);
  }
}
