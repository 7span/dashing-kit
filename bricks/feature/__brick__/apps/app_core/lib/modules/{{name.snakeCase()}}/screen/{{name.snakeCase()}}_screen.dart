import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class {{name.pascalCase()}}Screen extends StatelessWidget {
  const {{name.pascalCase()}}Screen ({super.key});

   @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('{{name.pascalCase()}}')),
      body: const Center(child: Text('{{name.pascalCase()}} Screen')),
    );
  }
}
