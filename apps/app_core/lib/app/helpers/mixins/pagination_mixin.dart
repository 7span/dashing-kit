import 'package:flutter/material.dart';

/// This mixin is used for implementing pagination functionality inside any Flutter App.
/// This mixin manages the lifecycle of a [ScrollController] so that the user don't
/// have to dispose it manually.
///
/// Furthermore, this mixin provides functions that can run on scrolling to the bottom
/// or scrolling to the top.
/// [Doc Link](https://cavin-7span.github.io/Dash-Docs/docs/tutorial-basics/implementing-a-feature)
mixin PaginationService<T extends StatefulWidget> on State<T> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(listener);
  }

  /// If the user has scrolled halfway, then call this function
  /// If you want to call this function only when user has scrolled to bottom,
  /// then use this condition:
  /// ```dart
  /// if (scrollController.position.atEdge) {
  ///    _checkIfCanLoadMore();
  ///  }
  /// ```
  void listener() {
    if (scrollController.offset > scrollController.position.maxScrollExtent - 50) {
      _checkIfCanLoadMore();
    }
  }

  bool _canFetchBottom = true;

  bool _canFetchTop = true;

  Future<void> _checkIfCanLoadMore() async {
    if (scrollController.position.pixels == 0) {
      if (!_canFetchTop) return;
      _canFetchTop = false;
      onTopScroll();
      _canFetchTop = true;
    } else {
      if (!_canFetchBottom) return;
      _canFetchBottom = false;
      onEndScroll();
      _canFetchBottom = true;
    }
  }

  /// This method is called when the scroll is at the bottom, You can add events
  /// to your bloc for loading more items
  void onEndScroll();

  /// this method is called when the scroll is at the top
  void onTopScroll() {}

  @override
  void dispose() {
    scrollController.removeListener(listener);
    super.dispose();
  }
}
