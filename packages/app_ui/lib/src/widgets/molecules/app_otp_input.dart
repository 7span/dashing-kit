import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class AppOtpInput extends StatelessWidget {
  const AppOtpInput({required this.onChanged, this.length = 6, this.errorText, super.key});

  final void Function(String) onChanged;
  final int length;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: length,
      separatorBuilder: (index) => HSpace.xxsmall4(),
      errorText: errorText,
      onChanged: onChanged,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}
