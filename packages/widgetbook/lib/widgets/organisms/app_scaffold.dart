import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(
  name: 'Interactive AppScaffold',
  type: AppScaffold,
)
Widget interactiveAppScaffold(BuildContext context) {
  final knobs = context.knobs;

  // Knobs to dynamically adjust the properties of AppScaffold
  final appBar =
      knobs.boolean(label: 'Has AppBar', initialValue: true)
          ? AppBar(title: const Text('App Scaffold'))
          : null;

  final backgroundColor = knobs.list<Color>(
    label: 'Background Color',
    options: [
      Colors.blueGrey,
      Colors.teal,
      Colors.green,
      Colors.orange,
      Colors.pink,
    ],
    initialOption: Colors.blueGrey,
    labelBuilder: (color) => color.toString(),
  );

  final bottomNavigationBar =
      knobs.boolean(
            label: 'Has Bottom Navigation',
            initialValue: true,
          )
          ? BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          )
          : null;

  final floatingActionButton =
      knobs.boolean(
            label: 'Has Floating Action Button',
            initialValue: true,
          )
          ? FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          )
          : null;

  final body =
      knobs.boolean(label: 'Has Body Content', initialValue: true)
          ? Center(child: Text('This is the body of the AppScaffold'))
          : null;

  return AppScaffold(
    appBar: appBar,
    backgroundColor: backgroundColor,
    body: body,
    bottomNavigationBar: bottomNavigationBar,
    floatingActionButton: floatingActionButton,
  );
}
