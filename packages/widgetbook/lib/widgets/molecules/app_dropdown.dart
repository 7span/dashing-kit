import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(
  name: 'Interactive AppDropDownWidget',
  type: AppDropDownWidget,
)
Widget interactiveAppDropDownWidget(BuildContext context) {
  // Label knob
  final label = context.knobs.string(
    label: 'Label Text',
    initialValue: 'Select Option',
  );

  // Background color knob
  final useCustomBgColor = context.knobs.boolean(
    label: 'Use Custom Background Color',
    initialValue: false,
  );

  final bgColor = context.knobs.color(
    label: 'Background Color',
    initialValue: Colors.grey.shade100,
  );

  // Border radius knob
  final borderRadiusStr = context.knobs.string(
    label: 'Border Radius',
    initialValue: '4',
    description: 'Enter a value between 0 and 20',
  );

  // Parse the string input to double with fallback
  double borderRadius = 4;
  try {
    borderRadius = double.parse(borderRadiusStr);
  } catch (e) {
    // Keep default if parsing fails
  }

  // Dropdown items
  final categoryItems = context.knobs.list<String>(
    label: 'Items Category',
    options: const [
      'Status',
      'Roles',
      'Priority',
      'Colors',
      'Custom',
    ],
    initialOption: 'Status',
  );

  // Generate sample dropdown items based on category
  List<AppDropDownModel> dropdownItems = [];

  switch (categoryItems) {
    case 'Status':
      dropdownItems = [
        const AppDropDownModel(color: Colors.green, name: 'New Lead'),
        const AppDropDownModel(
          color: Colors.blue,
          name: 'In Progress',
        ),
        const AppDropDownModel(color: Colors.orange, name: 'Pending'),
        const AppDropDownModel(color: Colors.red, name: 'Closed'),
      ];
      break;
    case 'Roles':
      dropdownItems = [
        const AppDropDownModel(name: 'UI/UX Designer'),
        const AppDropDownModel(name: 'Flutter Developer'),
        const AppDropDownModel(name: 'Project Manager'),
        const AppDropDownModel(name: 'QA Engineer'),
      ];
      break;
    case 'Priority':
      dropdownItems = [
        const AppDropDownModel(color: Colors.red, name: 'High'),
        const AppDropDownModel(color: Colors.orange, name: 'Medium'),
        const AppDropDownModel(color: Colors.green, name: 'Low'),
      ];
      break;
    case 'Colors':
      dropdownItems = [
        const AppDropDownModel(color: Colors.red, name: 'Red'),
        const AppDropDownModel(color: Colors.green, name: 'Green'),
        const AppDropDownModel(color: Colors.blue, name: 'Blue'),
        const AppDropDownModel(color: Colors.yellow, name: 'Yellow'),
        const AppDropDownModel(color: Colors.purple, name: 'Purple'),
      ];
      break;
    case 'Custom':
      // Use a string from the knobs to create custom items
      final customItemsStr = context.knobs.string(
        label: 'Custom Items (comma separated)',
        initialValue: 'Item 1, Item 2, Item 3',
      );

      final customItems =
          customItemsStr.split(',').map((e) => e.trim()).toList();
      dropdownItems =
          customItems
              .map((item) => AppDropDownModel(name: item))
              .toList();
      break;
  }

  // Set initial item if available
  final useInitialItem = context.knobs.boolean(
    label: 'Use Initial Item',
    initialValue: false,
  );

  final initialItemIndex = context.knobs.list<String>(
    label: 'Initial Item Index',
    options: ['0', '1', '2', '3', '4'],
    initialOption: '0',
  );

  final index = int.tryParse(initialItemIndex) ?? 0;
  final initialItem =
      useInitialItem &&
              dropdownItems.isNotEmpty &&
              index < dropdownItems.length
          ? dropdownItems[index]
          : null;

  // Show validation error
  final showError = context.knobs.boolean(
    label: 'Show Validation Error',
    initialValue: false,
  );

  String? validateDropdown(AppDropDownModel? value) {
    if (showError) {
      return 'Please select a valid option';
    }
    return null;
  }

  return AppScaffold(
    backgroundColor: context.colorScheme.grey300,
    body: Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: AppDropDownWidget(
          label: label,
          items: dropdownItems,
          validator: showError ? validateDropdown : null,
          backgroundColor: useCustomBgColor ? bgColor : null,
          borderRadius: borderRadius,
          initialItem: initialItem,
          onChanged: (value) {
            // In a real implementation, you would handle the change
          },
        ),
      ),
    ),
  );
}
