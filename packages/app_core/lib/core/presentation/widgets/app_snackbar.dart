import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum SnackbarType { success, failed }

void showAppSnackbar(
  BuildContext context,
  String text, {
  SnackbarType type = SnackbarType.success,
}) {
  showTopSnackBar(
    Overlay.of(context),
    type == SnackbarType.success
        ? CustomSnackBar.success(message: text)
        : CustomSnackBar.error(message: text),
  );
}
