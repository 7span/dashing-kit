import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(
  name: 'Interactive EmptyScreen with All Variations',
  type: EmptyScreen,
)
Widget interactiveEmptyScreenAllVariations(BuildContext context) {
  // Title knob
  final useTitle = context.knobs.boolean(
    label: 'Show Title',
    initialValue: true,
  );

  final title = context.knobs.string(
    label: 'Title Text',
    initialValue: 'No items found',
  );

  // Subtitle knob
  final useSubtitle = context.knobs.boolean(
    label: 'Show Subtitle',
    initialValue: true,
  );

  final subtitle = context.knobs.string(
    label: 'Subtitle Text',
    initialValue:
        'Try creating a new item or change your search criteria',
  );

  // Button controls
  final showButton = context.knobs.boolean(
    label: 'Show Button',
    initialValue: true,
  );

  final buttonTitle = context.knobs.string(
    label: 'Button Title',
    initialValue: 'Create New',
  );

  final showButtonIcon = context.knobs.boolean(
    label: 'Show Button Icon',
    initialValue: true,
  );

  // Documentation link
  final useDocLink = context.knobs.boolean(
    label: 'Show Documentation Link',
    initialValue: false,
  );

  final docLink = context.knobs.string(
    label: 'Documentation URL',
    initialValue: 'https://example.com/docs',
  );

  // Custom icon
  final iconType = context.knobs.object.dropdown<String>(
    label: 'Icon Type',
    options: const [
      'Default',
      'Not Found',
      'Error',
      'Custom',
      'None',
    ],
    initialOption: 'Default',
  );

  // Horizontal padding
  final hPaddingStr = context.knobs.string(
    label: 'Horizontal Padding',
    initialValue: '16',
    description: 'Enter a value between 0 and 64',
  );

  // Parse the string input to double with fallback
  double hPadding = 16;
  try {
    hPadding = double.parse(hPaddingStr);
  } catch (e) {
    // Keep default if parsing fails
  }

  // Determine the icon based on selection
  Widget? iconWidget;
  switch (iconType) {
    case 'Not Found':
      iconWidget = Icon(
        Icons.search_off,
        size: 64,
        color: Colors.grey,
      );
      break;
    case 'Error':
      iconWidget = Icon(
        Icons.error_outline,
        size: 64,
        color: Colors.red,
      );
      break;
    case 'Custom':
      iconWidget = Icon(
        Icons.image_not_supported_outlined,
        size: 64,
        color: Colors.orange,
      );
      break;
    case 'None':
      iconWidget = const SizedBox();
      break;
    case 'Default':
    default:
      iconWidget =
          null; // Will use the default Assets.images.emptyBox.svg()
      break;
  }

  // Layout options
  final layoutType = context.knobs.object.dropdown<String>(
    label: 'Layout Type',
    options: const [
      'Standard',
      'Compact',
      'With Padding',
      'Title Only',
      'Icon Only',
    ],
    initialOption: 'Standard',
  );

  // Return the final AppScaffold with EmptyScreen
  switch (layoutType) {
    case 'Compact':
      return AppScaffold(
        body: EmptyScreen(
          title: useTitle ? title : null,
          subTitle: useSubtitle ? subtitle : null,
          buttonTitle: buttonTitle,
          showButton: showButton,
          showIcon: false,
          icon: iconWidget,
          documentationLink: useDocLink ? docLink : null,
          hPadding: hPadding,
          onTap: () {},
        ),
      );
    case 'With Padding':
      return AppScaffold(
        body: EmptyScreen(
          title: useTitle ? title : null,
          subTitle: useSubtitle ? subtitle : null,
          buttonTitle: buttonTitle,
          showButton: showButton,
          showIcon: showButtonIcon,
          icon: iconWidget,
          documentationLink: useDocLink ? docLink : null,
          hPadding: 32, // Fixed padding
          onTap: () {},
        ),
      );
    case 'Title Only':
      return AppScaffold(
        body: EmptyScreen(
          title: useTitle ? title : null,
          showButton: false,
          showIcon: false,
        ),
      );
    case 'Icon Only':
      return AppScaffold(
        body: EmptyScreen(
          showButton: false,
          showIcon: true,
          icon: iconWidget,
        ),
      );
    case 'Standard':
    default:
      return AppScaffold(
        body: EmptyScreen(
          title: useTitle ? title : null,
          subTitle: useSubtitle ? subtitle : null,
          buttonTitle: buttonTitle,
          showButton: showButton,
          showIcon: showButtonIcon,
          icon: iconWidget,
          documentationLink: useDocLink ? docLink : null,
          hPadding: hPadding,
          onTap: () {},
        ),
      );
  }
}
