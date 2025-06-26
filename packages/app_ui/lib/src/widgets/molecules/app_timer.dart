import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppTimer extends StatefulWidget {
  const AppTimer({required this.seconds, super.key, this.onTick, this.onFinished, this.textStyle});
  final int seconds;
  final void Function(int secondsRemaining)? onTick;
  final VoidCallback? onFinished;
  final TextStyle? textStyle;

  @override
  State<AppTimer> createState() => _AppTimerState();
}

class _AppTimerState extends State<AppTimer> with TickerProviderStateMixin {
  late int _secondsRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.seconds;
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant AppTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seconds != widget.seconds) {
      _timer?.cancel();
      _secondsRemaining = widget.seconds;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
        if (widget.onTick != null) widget.onTick?.call(_secondsRemaining);
      } else {
        timer.cancel();
        if (widget.onFinished != null) widget.onFinished?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerText = '00:${_secondsRemaining.toString().padLeft(2, '0')}';
    return AppText(
      text: timerText,
      style: widget.textStyle ?? context.textTheme?.sSemiBold.copyWith(color: context.colorScheme.primary400),
    );
  }
}
