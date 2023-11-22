import 'package:fitness_ui/src/widgets/base/padding.dart';
import 'package:flutter/material.dart';

/// This class is used for implementing vertical spacing inside your Flutter App.
/// Thus instead of writing:
/// ```dart
/// const SizedBox(height: 8)
/// ```
///
/// You can write:
/// ```dart
/// VSpace.xsmall()
/// ```
///
/// This will ensure that whenever user wants to change the spacing throughout the app,
/// they will be able to do by modifying just this class
final class VSpace extends StatelessWidget {
  const VSpace(this.size, {super.key});

  factory VSpace.xsmall() => const VSpace(Insets.xsmall);
  factory VSpace.small() => const VSpace(Insets.small);
  factory VSpace.medium() => const VSpace(Insets.medium);
  factory VSpace.large() => const VSpace(Insets.large);
  factory VSpace.xlarge() => const VSpace(Insets.xlarge);

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(height: size);
}

/// This class is used for implementing horizontal spacing inside your Flutter App.
/// Thus instead of writing:
/// ```dart
/// const SizedBox(width: 8)
/// ```
///
/// You can write:
/// ```dart
/// HSpace.xsmall()
/// ```
///
/// This will ensure that whenever user wants to change the spacing throughout the app,
/// they will be able to do by modifying just this class

final class HSpace extends StatelessWidget {
  const HSpace(this.size, {super.key});

  factory HSpace.xsmall() => const HSpace(Insets.xsmall);
  factory HSpace.small() => const HSpace(Insets.small);
  factory HSpace.medium() => const HSpace(Insets.medium);
  factory HSpace.large() => const HSpace(Insets.large);
  factory HSpace.xlarge() => const HSpace(Insets.xlarge);

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(width: size);
}
