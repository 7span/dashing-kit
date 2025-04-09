import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  const AppCircularProgressIndicator({
    super.key,
    this.color,
    this.strokeWidth,
  });

  final Color? color;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    final appColor = context.colorScheme;
    return CircularProgressIndicator.adaptive(
      strokeWidth: strokeWidth ?? 3,
      valueColor: AlwaysStoppedAnimation<Color>(
        color ?? appColor.primary900,
      ),
    );
  }
}
