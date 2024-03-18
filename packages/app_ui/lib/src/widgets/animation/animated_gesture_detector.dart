import 'package:flutter/material.dart';

/// This widget is used to implement scaling effect when a user taps on a widget. It
/// also has [onTap] parameter so that you can use this widget in replace of [InkWell] widget
class AnimatedGestureDetector extends StatefulWidget {
  const AnimatedGestureDetector({
    required this.onTap,
    required this.child,
    this.onLongPress,
    super.key,
  });

  final void Function()? onTap;
  final void Function()? onLongPress;
  final Widget child;

  @override
  State<AnimatedGestureDetector> createState() => _AnimatedScaleWrapper();
}

class _AnimatedScaleWrapper extends State<AnimatedGestureDetector>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      upperBound: 0.07,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _tapDown(TapDownDetails details) async {
    await _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTapCancel: () => _controller.reverse(from: _controller.value),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          _scale = 1 - _controller.value;
          return Transform.scale(
            scale: _scale,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
