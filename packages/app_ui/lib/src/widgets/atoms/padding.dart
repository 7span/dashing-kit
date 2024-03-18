import 'package:flutter/material.dart';

/// This class is used for providing the [Padding] inside the Flutter App.
/// Usage:
/// ```dart
/// padding: EdgeInsects.all(Insets.medium)
/// ```
final class Insets {
  const Insets._();

  static const double scale = 1;

  // Regular paddings
  static const double zero = 0;
  static const double xxsmall4 = scale * 4;
  static const double xsmall8 = scale * 8;
  static const double small12 = scale * 12;
  static const double medium16 = scale * 16;
  static const double medium20 = scale * 20;
  static const double large24 = scale * 24;
  static const double xlarge32 = scale * 32;
  static const double xxlarge40 = scale * 40;
  static const double xxxlarge66 = scale * 66;
  static const double xxxxlarge80 = scale * 80;
  static const double infinity = double.infinity;
}

class AppPadding extends StatelessWidget {
  const AppPadding({
    super.key,
    this.padding = const EdgeInsets.all(Insets.small12),
    this.child,
  });

  const AppPadding.small({
    super.key,
    this.child,
  }) : padding = EdgeInsets.zero;

  const AppPadding.semiSmall({
    super.key,
    this.child,
  }) : padding = const EdgeInsets.all(Insets.xsmall8);

  const AppPadding.regular({
    super.key,
    this.child,
  }) : padding = const EdgeInsets.all(Insets.medium16);

  const AppPadding.semiBig({
    super.key,
    this.child,
  }) : padding = const EdgeInsets.all(Insets.large24);

  const AppPadding.big({
    super.key,
    this.child,
  }) : padding = const EdgeInsets.all(Insets.xlarge32);

  final EdgeInsets padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}
