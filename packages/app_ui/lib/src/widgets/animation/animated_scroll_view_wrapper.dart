import 'package:flutter/material.dart';

class AnimatedScrollViewWrapper extends StatefulWidget {
  const AnimatedScrollViewWrapper({
    required this.child,
    required this.isLoading,
    super.key,
  });

  final Widget child;
  final bool isLoading;

  @override
  State<AnimatedScrollViewWrapper> createState() => _AnimatedScrollViewWrapperState();
}

class _AnimatedScrollViewWrapperState extends State<AnimatedScrollViewWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? widget.child
        : ScaleTransition(
            scale: _scaleAnimation,
            child: widget.child,
          );
  }
}
