import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(
  name: 'Interactive AppTextField',
  type: AppTextField,
)
Widget interactiveAppTextField(BuildContext context) {
  // Label knob
  final label = context.knobs.string(
    label: 'Label Text',
    initialValue: 'Email',
  );

  // Show label knob
  final showLabel = context.knobs.boolean(
    label: 'Show Label',
    initialValue: true,
  );

  // Input type knob
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

  // Hint text knob
  final hintText = context.knobs.string(
    label: 'Hint Text',
    initialValue: 'Enter your email',
  );

  // Error text knob
  final showError = context.knobs.boolean(
    label: 'Show Error',
    initialValue: false,
  );

  final errorText = context.knobs.string(
    label: 'Error Text',
    initialValue: 'Please enter a valid email',
  );

  // Hint text below field knob
  final showHintTextBelow = context.knobs.boolean(
    label: 'Show Hint Text Below',
    initialValue: false,
  );

  final hintTextBelow = context.knobs.string(
    label: 'Hint Text Below',
    initialValue: 'We will never share your email with anyone',
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

  // Content Padding controls
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

  // Custom padding values using string inputs
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

  // Parse the string inputs to doubles with fallbacks
  double horizontalPadding = 16;
  try {
    horizontalPadding = double.parse(horizontalPaddingStr);
  } catch (e) {
    // Keep default if parsing fails
  }

  double verticalPadding = 16;
  try {
    verticalPadding = double.parse(verticalPaddingStr);
  } catch (e) {
    // Keep default if parsing fails
  }

  final minLinesOptions = ['1', '2', '3', '4', '5'];
  final minLinesString = context.knobs.list(
    label: 'Min Lines (for multiline)',
    options: minLinesOptions,
    initialOption: '3',
  );
  final minLines = int.parse(minLinesString);

  // Determine keyboard type based on selected input type
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

  // Determine autofill hints
  List<String>? autofillHints;
  if (inputType == 'Email') {
    autofillHints = [AutofillHints.email];
  } else if (inputType == 'Password') {
    autofillHints = [AutofillHints.password];
  } else if (inputType == 'Phone') {
    autofillHints = [AutofillHints.telephoneNumber];
  }

  // Determine content padding based on selection
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

  return Center(
    child: Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 400),
      child:
          inputType == 'Password'
              ? AppTextField.password(
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
              )
              : AppTextField(
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
                minLines:
                    inputType == 'Multiline'
                        ? minLines.toInt()
                        : null,
              ),
    ),
  );
}

@widgetbook.UseCase(name: 'Common Field Types', type: AppTextField)
Widget commonFieldTypes(BuildContext context) {
  final fieldType = context.knobs.list<String>(
    label: 'Field Type',
    options: const [
      'Text',
      'Email',
      'Password',
      'Phone',
      'Number',
      'Multiline',
    ],
    initialOption: 'Text',
  );

  final showError = context.knobs.boolean(
    label: 'Show Error',
    initialValue: false,
  );

  // Content Padding knob
  final paddingType = context.knobs.list<String>(
    label: 'Content Padding',
    options: const ['None', 'Compact', 'Standard', 'Comfortable'],
    initialOption: 'Standard',
  );

  // Determine content padding based on selection
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
  }

  Widget buildTextField() {
    switch (fieldType) {
      case 'Email':
        return AppTextField(
          label: 'Email Address',
          hintText: 'example@domain.com',
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          errorText:
              showError ? 'Please enter a valid email address' : null,
          contentPadding: contentPadding,
        );
      case 'Password':
        return AppTextField.password(
          label: 'Password',
          hintText: 'Enter your password',
          errorText:
              showError
                  ? 'Password must be at least 8 characters'
                  : null,
          autofillHints: const [AutofillHints.password],
          hintTextBelowTextField:
              'Password must contain at least 8 characters',
          contentPadding: contentPadding,
        );
      case 'Phone':
        return AppTextField(
          label: 'Phone Number',
          hintText: '(123) 456-7890',
          keyboardType: TextInputType.phone,
          autofillHints: const [AutofillHints.telephoneNumber],
          errorText:
              showError ? 'Please enter a valid phone number' : null,
          contentPadding: contentPadding,
        );
      case 'Number':
        return AppTextField(
          label: 'Amount',
          hintText: '0.00',
          keyboardType: TextInputType.number,
          errorText: showError ? 'Please enter a valid amount' : null,
          contentPadding: contentPadding,
        );
      case 'Multiline':
        return AppTextField(
          label: 'Description',
          hintText: 'Enter your description here...',
          minLines: 3,
          keyboardType: TextInputType.multiline,
          errorText: showError ? 'Description cannot be empty' : null,
          contentPadding: contentPadding,
        );
      case 'Text':
      default:
        return AppTextField(
          label: 'Full Name',
          hintText: 'John Doe',
          errorText: showError ? 'Full name is required' : null,
          contentPadding: contentPadding,
        );
    }
  }

  return Center(
    child: Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 400),
      child: buildTextField(),
    ),
  );
}

@widgetbook.UseCase(name: 'Form Example', type: AppTextField)
Widget formExample(BuildContext context) {
  final showErrors = context.knobs.boolean(
    label: 'Show Form Validation Errors',
    initialValue: false,
  );

  // Content Padding knob
  final paddingType = context.knobs.list<String>(
    label: 'Content Padding',
    options: const ['None', 'Compact', 'Standard', 'Comfortable'],
    initialOption: 'Standard',
  );

  // Determine content padding based on selection
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
  }

  return Center(
    child: Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            label: 'Full Name',
            hintText: 'John Doe',
            textInputAction: TextInputAction.next,
            errorText: showErrors ? 'Name is required' : null,
            contentPadding: contentPadding,
          ),
          VSpace.medium16(),
          AppTextField(
            label: 'Email Address',
            hintText: 'example@domain.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            errorText:
                showErrors ? 'Enter a valid email address' : null,
            contentPadding: contentPadding,
          ),
          VSpace.medium16(),
          AppTextField.password(
            label: 'Password',
            hintText: 'Enter your password',
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            errorText:
                showErrors
                    ? 'Password must be at least 8 characters'
                    : null,
            contentPadding: contentPadding,
          ),
          VSpace.large24(),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Submit',
              onPressed: () {},
              isExpanded: true,
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Styling Variations', type: AppTextField)
Widget stylingVariations(BuildContext context) {
  final styleName = context.knobs.list<String>(
    label: 'Style Variation',
    options: const [
      'Default',
      'Custom Background',
      'Custom Padding',
      'With Helper Text',
    ],
    initialOption: 'Default',
  );

  // Additional padding controls for all variations
  final customizePadding = context.knobs.boolean(
    label: 'Customize Padding',
    initialValue: styleName == 'Custom Padding',
  );

  // Custom padding values using string inputs
  final horizontalPaddingStr = context.knobs.string(
    label: 'Horizontal Padding',
    initialValue: '16',
    description: 'Enter a value between 0 and 48',
  );

  final verticalPaddingStr = context.knobs.string(
    label: 'Vertical Padding',
    initialValue: '12',
    description: 'Enter a value between 0 and 32',
  );

  // Parse the string inputs to doubles with fallbacks
  double horizontalPadding = 16;
  try {
    horizontalPadding = double.parse(horizontalPaddingStr);
  } catch (e) {
    // Keep default if parsing fails
  }

  double verticalPadding = 12;
  try {
    verticalPadding = double.parse(verticalPaddingStr);
  } catch (e) {
    // Keep default if parsing fails
  }

  final label = 'Search';
  final hintText = 'Search for something...';

  // Determine content padding based on user selection
  EdgeInsets? contentPadding;
  if (customizePadding) {
    contentPadding = EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    );
  } else if (styleName == 'Custom Padding') {
    contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    );
  }

  switch (styleName) {
    case 'Custom Background':
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: AppTextField(
            label: label,
            hintText: hintText,
            backgroundColor: Colors.blue.shade50,
            contentPadding: contentPadding,
          ),
        ),
      );
    case 'Custom Padding':
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: AppTextField(
            label: label,
            hintText: hintText,
            contentPadding: contentPadding,
          ),
        ),
      );
    case 'With Helper Text':
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: AppTextField(
            label: label,
            hintText: hintText,
            hintTextBelowTextField:
                'Enter keywords to find what you\'re looking for',
            contentPadding: contentPadding,
          ),
        ),
      );
    case 'Default':
    default:
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: AppTextField(
            label: label,
            hintText: hintText,
            contentPadding: contentPadding,
          ),
        ),
      );
  }
}

@widgetbook.UseCase(name: 'Input States', type: AppTextField)
Widget inputStates(BuildContext context) {
  final stateType = context.knobs.list<String>(
    label: 'Input State',
    options: const ['Initial', 'Filled', 'Error', 'Disabled'],
    initialOption: 'Initial',
  );

  // Content Padding knob
  final paddingType = context.knobs.list<String>(
    label: 'Content Padding',
    options: const [
      'None',
      'Compact',
      'Standard',
      'Comfortable',
      'Custom',
    ],
    initialOption: 'Standard',
  );

  // Custom padding values using string inputs
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

  // Parse the string inputs to doubles with fallbacks
  double horizontalPadding = 16;
  try {
    horizontalPadding = double.parse(horizontalPaddingStr);
  } catch (e) {
    // Keep default if parsing fails
  }

  double verticalPadding = 16;
  try {
    verticalPadding = double.parse(verticalPaddingStr);
  } catch (e) {
    // Keep default if parsing fails
  }

  // Determine content padding based on selection
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

  Widget buildState() {
    switch (stateType) {
      case 'Filled':
        return AppTextField(
          label: 'Email',
          initialValue: 'user@example.com',
          hintText: 'Enter your email',
          contentPadding: contentPadding,
        );
      case 'Error':
        return AppTextField(
          label: 'Email',
          initialValue: 'invalid-email',
          hintText: 'Enter your email',
          errorText: 'Please enter a valid email address',
          contentPadding: contentPadding,
        );
      case 'Disabled':
        // Note: TextFormField doesn't have a direct "disabled" state
        // You might need to add a "enabled" property to AppTextField
        // This is a visual approximation
        return Opacity(
          opacity: 0.6,
          child: IgnorePointer(
            child: AppTextField(
              label: 'Email',
              initialValue: 'user@example.com',
              hintText: 'Enter your email',
              backgroundColor: Colors.grey.shade200,
              contentPadding: contentPadding,
            ),
          ),
        );
      case 'Initial':
      default:
        return AppTextField(
          label: 'Email',
          hintText: 'Enter your email',
          contentPadding: contentPadding,
        );
    }
  }

  return Center(
    child: Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 400),
      child: buildState(),
    ),
  );
}
