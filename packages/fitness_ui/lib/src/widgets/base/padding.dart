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
  static const double xsmall = scale * 6;
  static const double small = scale * 12;
  static const double medium = scale * 16;
  static const double large = scale * 24;
  static const double xlarge = scale * 32;
  static const double infinity = double.infinity;
}

class AppPadding extends StatelessWidget {
  const AppPadding({
    super.key,
    this.padding = const EdgeInsets.all(Insets.small),
    this.child,
  });

  const AppPadding.small({
    super.key,
    this.child,
  }) : padding = EdgeInsets.zero;

  const AppPadding.semiSmall({
    super.key,
    this.child,
  }) : padding = const EdgeInsets.all(Insets.xsmall);

  const AppPadding.regular({
    super.key,
    this.child,
  }) : padding = const EdgeInsets.all(Insets.medium);

  const AppPadding.semiBig({
    super.key,
    this.child,
  }) : padding = const EdgeInsets.all(Insets.large);

  const AppPadding.big({
    super.key,
    this.child,
  }) : padding = const EdgeInsets.all(Insets.xlarge);

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
