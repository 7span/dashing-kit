import 'dart:async';

import 'package:app_core/core/presentation/widgets/no_internet_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  factory ConnectivityService() => _instance;

  ConnectivityService._internal();

  static final ConnectivityService _instance =
      ConnectivityService._internal();

  final _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();
  bool _isDialogVisible = false;
  OverlayEntry? _overlayEntry;

  final GlobalKey<OverlayState> overlayKey =
      GlobalKey<OverlayState>();

  Stream<bool> get connectionStream => _controller.stream;

  void initialize() {
    _connectivity.onConnectivityChanged.listen((result) {
      final isConnected = result.first != ConnectivityResult.none;
      _controller.add(isConnected);

      if (!isConnected) {
        _showNoInternetOverlay();
      } else {
        _removeNoInternetOverlay();
      }
    });
  }

  void _showNoInternetOverlay() {
    if (_isDialogVisible || overlayKey.currentState == null) {
      return;
    }

    _isDialogVisible = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => const NoInternetWidget(),
    );

    overlayKey.currentState!.insert(_overlayEntry!);
  }

  void _removeNoInternetOverlay() {
    if (!_isDialogVisible || _overlayEntry == null) {
      return;
    }

    _overlayEntry!.remove();
    _overlayEntry = null;
    _isDialogVisible = false;
  }

  void dispose() {
    _removeNoInternetOverlay();
    _controller.close();
  }
}
