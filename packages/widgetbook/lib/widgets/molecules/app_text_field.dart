import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(
  name: 'Interactive AppTextField and Variations',
  type: AppTextField,
)
Widget combinedAppTextFieldUseCases(BuildContext context) {
  // Common knobs
  final label = context.knobs.string(
    label: 'Label Text',
    initialValue: 'Email',
  );

  final showLabel = context.knobs.boolean(
    label: 'Show Label',
    initialValue: true,
  );

  final inputType = context.knobs.list<String>(
    label: 'Input Type',
    options: const [
      'Text',
      'Email',
      'Number',
      'Phone',
      'Password',
      'Multiline',
    ],
    initialOption: 'Text',
  );

  final hintText = context.knobs.string(
    label: 'Hint Text',
    initialValue: 'Enter your email',
  );

  final showError = context.knobs.boolean(
    label: 'Show Error',
    initialValue: false,
  );

  final errorText = context.knobs.string(
    label: 'Error Text',
    initialValue: 'Please enter a valid email',
  );

  final showHintTextBelow = context.knobs.boolean(
    label: 'Show Hint Text Below',
    initialValue: false,
  );

  final hintTextBelow = context.knobs.string(
    label: 'Hint Text Below',
    initialValue: 'We will never share your email with anyone',
  );

  final useCustomBgColor = context.knobs.boolean(
    label: 'Use Custom Background Color',
    initialValue: false,
  );

  final bgColor = context.knobs.color(
    label: 'Background Color',
    initialValue: Colors.grey.shade100,
  );

  final paddingType = context.knobs.list<String>(
    label: 'Content Padding Type',
    options: const [
      'None',
      'Compact',
      'Standard',
      'Comfortable',
      'Custom',
    ],
    initialOption: 'Standard',
  );

  final horizontalPaddingStr = context.knobs.string(
    label: 'Horizontal Padding',
    initialValue: '16',
    description: 'Enter a value between 0 and 32',
  );

  final verticalPaddingStr = context.knobs.string(
    label: 'Vertical Padding',
    initialValue: '16',
    description: 'Enter a value between 0 and 32',
  );

  // Parse padding values
  double horizontalPadding = 16;
  try {
    horizontalPadding = double.parse(horizontalPaddingStr);
  } catch (e) {
    debugPrint('error-${e.toString()}');
  }

  double verticalPadding = 16;
  try {
    verticalPadding = double.parse(verticalPaddingStr);
  } catch (e) {
    debugPrint('error-${e.toString()}');
  }

  // Determine keyboard type
  TextInputType? keyboardType;
  switch (inputType) {
    case 'Email':
      keyboardType = TextInputType.emailAddress;
      break;
    case 'Number':
      keyboardType = TextInputType.number;
      break;
    case 'Phone':
      keyboardType = TextInputType.phone;
      break;
    case 'Multiline':
      keyboardType = TextInputType.multiline;
      break;
    default:
      keyboardType = TextInputType.text;
      break;
  }

  List<String>? autofillHints;
  if (inputType == 'Email') {
    autofillHints = [AutofillHints.email];
  } else if (inputType == 'Password') {
    autofillHints = [AutofillHints.password];
  } else if (inputType == 'Phone') {
    autofillHints = [AutofillHints.telephoneNumber];
  }

  // Determine content padding
  EdgeInsets? contentPadding;
  switch (paddingType) {
    case 'None':
      contentPadding = EdgeInsets.zero;
      break;
    case 'Compact':
      contentPadding = const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      );
      break;
    case 'Standard':
      contentPadding = const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      );
      break;
    case 'Comfortable':
      contentPadding = const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      );
      break;
    case 'Custom':
      contentPadding = EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      );
      break;
  }

  final minLinesOptions = ['1', '2', '3', '4', '5'];
  final minLinesString = context.knobs.list(
    label: 'Min Lines (for multiline)',
    options: minLinesOptions,
    initialOption: '3',
  );
  final minLines = int.parse(minLinesString);

  // Use AppTextField.password when input type is password
  Widget textFieldWidget;
  if (inputType == 'Password') {
    textFieldWidget = AppTextField.password(
      label: label,
      showLabel: showLabel,
      hintText: hintText,
      keyboardType: keyboardType,
      errorText: showError ? errorText : null,
      backgroundColor: useCustomBgColor ? bgColor : null,
      hintTextBelowTextField:
          showHintTextBelow ? hintTextBelow : null,
      autofillHints: autofillHints,
      contentPadding: contentPadding,
    );
  } else {
    textFieldWidget = AppTextField(
      label: label,
      showLabel: showLabel,
      hintText: hintText,
      keyboardType: keyboardType,
      errorText: showError ? errorText : null,
      backgroundColor: useCustomBgColor ? bgColor : null,
      hintTextBelowTextField:
          showHintTextBelow ? hintTextBelow : null,
      autofillHints: autofillHints,
      contentPadding: contentPadding,
      minLines: inputType == 'Multiline' ? minLines : null,
    );
  }

  return AppScaffold(
    backgroundColor: context.colorScheme.grey300,
    body: Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: textFieldWidget,
      ),
    ),
  );
}
