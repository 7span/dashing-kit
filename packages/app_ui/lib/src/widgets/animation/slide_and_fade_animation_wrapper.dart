import 'dart:async';

import 'package:flutter/material.dart';

enum SlideFrom { top, bottom, left, right }

class SlideAndFadeAnimationWrapper extends StatefulWidget {
  const SlideAndFadeAnimationWrapper({
    required this.child,
    super.key,
    this.delay = 700,
    this.isLoading = false,
    this.curve,
    this.offset,
    this.slideFrom = SlideFrom.bottom,
    this.keepAlive = false,
  });
  final Widget child;
  final int delay;
  final SlideFrom? slideFrom;
  final Curve? curve;
  final Offset? offset;
  final bool isLoading;
  final bool keepAlive;

  @override
  SlideAndFadeAnimationWrapperState createState() => SlideAndFadeAnimationWrapperState();
}

class SlideAndFadeAnimationWrapperState extends State<SlideAndFadeAnimationWrapper>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    final curve =
        CurvedAnimation(curve: widget.curve ?? Curves.decelerate, parent: _animController);

    final offset = widget.offset ?? getAnimationOffset();
    _animOffset = Tween<Offset>(begin: offset, end: Offset.zero).animate(curve);

    // ignore: unnecessary_null_comparison
    if (widget.delay == null) {
      _animController.forward();
    } else {
      _timer = Timer(Duration(milliseconds: widget.delay), () {
        _animController.forward();
      });
    }
  }

  Offset getAnimationOffset() {
    switch (widget.slideFrom) {
      case SlideFrom.bottom:
        return const Offset(0, 1);
      case SlideFrom.left:
        return const Offset(1, 0);
      case SlideFrom.right:
        return const Offset(-1, 0);
      case SlideFrom.top:
        return const Offset(0, -1);
      case null:
        return const Offset(0, -1);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.isLoading
        ? widget.child
        : FadeTransition(
            opacity: _animController,
            child: SlideTransition(
              position: _animOffset,
              child: widget.child,
            ),
          );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

/*
from left -->  begin: Offset(1.0, 0.0)
from right -->  begin: Offset(-1.0, 0.0)
from top -->  begin: Offset(0.0, -1.0)
from bottom -->  begin: Offset(0.0, 1.0)
*/
