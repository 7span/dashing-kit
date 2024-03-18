import 'package:app_ui/src/widgets/widgets.dart';
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

  factory VSpace.xxsmall4() => const VSpace(Insets.xxsmall4);
  factory VSpace.xsmall8() => const VSpace(Insets.xsmall8);
  factory VSpace.small12() => const VSpace(Insets.small12);
  factory VSpace.medium16() => const VSpace(Insets.medium16);
  factory VSpace.large24() => const VSpace(Insets.large24);
  factory VSpace.xlarge32() => const VSpace(Insets.xlarge32);
  factory VSpace.xxlarge40() => const VSpace(Insets.xxlarge40);
  factory VSpace.xxxlarge66() => const VSpace(Insets.xxxlarge66);
  factory VSpace.xxxxlarge80() => const VSpace(Insets.xxxxlarge80);

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

  factory HSpace.xxsmall4() => const HSpace(Insets.xxsmall4);
  factory HSpace.xsmall8() => const HSpace(Insets.xsmall8);
  factory HSpace.small12() => const HSpace(Insets.small12);
  factory HSpace.medium16() => const HSpace(Insets.medium16);
  factory HSpace.medium20() => const HSpace(Insets.medium20);
  factory HSpace.large24() => const HSpace(Insets.large24);
  factory HSpace.xlarge32() => const HSpace(Insets.xlarge32);

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(width: size);
}
