import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

import 'main.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        ViewportAddon([
          ViewportData(
            name: 'iPhone 13',
            width: 390,
            height: 844,
            pixelRatio: 3.0,
            platform: TargetPlatform.iOS,
          ),
        ]),

        TextScaleAddon(max: 2.0, min: 1.0, initialScale: 1.0),
      ],
      appBuilder: (context, child) {
        return MaterialApp(
          title: 'Flutter Launchpad Widgetbook',
          debugShowCheckedModeBanner: false,
          home: AppResponsiveTheme(
            colorMode: AppThemeColorMode.light,
            child: Scaffold(
              backgroundColor: context.colorScheme.grey300,
              body: child,
            ),
          ),
        );
      },
    );
  }
}
