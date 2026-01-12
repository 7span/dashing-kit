import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(name: 'Interactive', type: CustomAppBar)
Widget interactiveCustomAppBar(BuildContext context) {
  final knobs = context.knobs;

  final title = knobs.string(label: 'Title', initialValue: 'My App');

  final titleColor = knobs.object.dropdown<Color>(
    label: 'Title Color',
    options: [Colors.black, Colors.white, Colors.blue],
    labelBuilder: (color) {
      if (color == Colors.black) return 'Black';
      if (color == Colors.white) return 'White';
      return 'Blue';
    },
  );

  final backgroundColor = knobs.object.dropdown<Color>(
    label: 'Background Color',
    options: [Colors.white, Colors.grey, Colors.transparent],
    labelBuilder: (color) {
      if (color == Colors.white) return 'White';
      if (color == Colors.grey) return 'Grey';
      return 'Transparent';
    },
  );

  final showLeading = knobs.boolean(
    label: 'Show Leading Icon',
    initialValue: true,
  );

  final centerTitle = knobs.boolean(
    label: 'Center Title',
    initialValue: false,
  );

  final scrolledElevation = knobs.double.slider(
    label: 'Elevation',
    initialValue: 0,
    min: 0,
    max: 10,
  );

  return AppScaffold(
    appBar: CustomAppBar(
      title: title,
      titleColor: titleColor,
      backgroundColor: backgroundColor,
      centerTitle: centerTitle,
      scrolledUnderElevation: scrolledElevation,
      leading:
          showLeading
              ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
              )
              : null,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {},
        ),
      ],
    ),
    body: const Center(child: Text('AppBar Preview')),
  );
}
