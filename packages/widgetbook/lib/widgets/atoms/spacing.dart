import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(name: 'Interactive VSpace', type: VSpace)
Widget interactiveVSpace(BuildContext context) {
  final knobs = context.knobs;

  // Knobs to adjust the vertical spacing dynamically
  final size = knobs.list<double>(
    label: 'Vertical Spacing',
    options: [
      Insets.xxsmall4,
      Insets.xsmall8,
      Insets.small12,
      Insets.medium16,
      Insets.large24,
      Insets.xlarge32,
      Insets.xxlarge40,
      Insets.xxxlarge66,
      Insets.xxxxlarge80,
    ],
    labelBuilder: (sizeValue) {
      if (sizeValue == Insets.xxsmall4) return 'XXSmall (4)';
      if (sizeValue == Insets.xsmall8) return 'XSmall (8)';
      if (sizeValue == Insets.small12) return 'Small (12)';
      if (sizeValue == Insets.medium16) return 'Medium (16)';
      if (sizeValue == Insets.large24) return 'Large (24)';
      if (sizeValue == Insets.xlarge32) return 'XLarge (32)';
      if (sizeValue == Insets.xxlarge40) return 'XXLarge (40)';
      if (sizeValue == Insets.xxxlarge66) return 'XXXLarge (66)';
      return 'XXXXLarge (80)';
    },
  );

  return AppScaffold(
    appBar: AppBar(title: const Text('Interactive VSpace')),
    body: Column(
      children: [
        Flexible(
          child: const Text('This text is above the VSpace widget'),
        ),
        VSpace(size), // Dynamically set vertical spacing
        Flexible(
          child: const Text('This text is below the VSpace widget'),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Interactive HSpace', type: HSpace)
Widget interactiveHSpace(BuildContext context) {
  final knobs = context.knobs;

  // Knobs to adjust the horizontal spacing dynamically
  final size = knobs.list<double>(
    label: 'Horizontal Spacing',
    options: [
      Insets.xxsmall4,
      Insets.xsmall8,
      Insets.small12,
      Insets.medium16,
      Insets.medium20,
      Insets.large24,
      Insets.xlarge32,
    ],
    labelBuilder: (sizeValue) {
      if (sizeValue == Insets.xxsmall4) return 'XXSmall (4)';
      if (sizeValue == Insets.xsmall8) return 'XSmall (8)';
      if (sizeValue == Insets.small12) return 'Small (12)';
      if (sizeValue == Insets.medium16) return 'Medium (16)';
      if (sizeValue == Insets.medium20) return 'Medium (20)';
      if (sizeValue == Insets.large24) return 'Large (24)';
      return 'XLarge (32)';
    },
  );

  return AppScaffold(
    appBar: AppBar(title: const Text('Interactive HSpace')),
    body: Row(
      children: [
        Flexible(
          child: const Text(
            'This text is to the left of the HSpace widget',
          ),
        ),
        HSpace(size), // Dynamically set horizontal spacing
        Flexible(
          child: const Text(
            'This text is to the right of the HSpace widget',
          ),
        ),
      ],
    ),
  );
}
