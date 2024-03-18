import 'package:flutter/material.dart';

const borderRadius4 = 4.0;

/// This class is used for providing the [Padding] inside the Flutter App.
/// Usage:
/// ```dart
/// padding: EdgeInsects.all(Insets.medium)
/// ```
final class AppBorderRadius {
  const AppBorderRadius._();

  static const double scale = 1;

  // Regular paddings
  static const double zero = 0;
  static const double xsmall4 = scale * 4;
  static const double small8 = scale * 8;
  static const double medium16 = scale * 16;
  static const double big44 = scale * 44;
}
