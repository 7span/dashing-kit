import 'dart:async';

import 'package:app_core/core/data/services/force_update_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ForceUpdateWidget extends StatefulWidget {
  const ForceUpdateWidget({
    required this.child,
    required this.navigatorKey,
    required this.forceUpdateClient,
    required this.showForceUpdateAlert,
    required this.showStoreListing,
    this.onException,
    super.key,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  final ForceUpdateClient forceUpdateClient;

  final Future<bool?> Function(
    BuildContext context, {
    bool allowCancel,
  })
  showForceUpdateAlert;
  final Future<void> Function(Uri storeUrl) showStoreListing;
  final void Function(Object error, StackTrace? stackTrace)?
  onException;

  @override
  State<ForceUpdateWidget> createState() => _ForceUpdateWidgetState();
}

class _ForceUpdateWidgetState extends State<ForceUpdateWidget>
    with WidgetsBindingObserver {
  var _isAlertVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_checkIfAppUpdateIsNeeded());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_checkIfAppUpdateIsNeeded());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkIfAppUpdateIsNeeded() async {
    if (_isAlertVisible) {
      return;
    }
    try {
      final storeUrl = await widget.forceUpdateClient.storeUrl();
      if (storeUrl == null) {
        return;
      }
      final updateRequired =
          await widget.forceUpdateClient.isAppUpdateRequired();

      final allowCancel =
          await widget.forceUpdateClient.isAllowCancelEnabled();

      if (updateRequired) {
        return await _triggerForceUpdate(
          Uri.parse(storeUrl),
          allowCancel,
        );
      }
    } catch (e, st) {
      final handler = widget.onException;
      if (handler != null) {
        handler.call(e, st);
      } else {
        rethrow;
      }
    }
  }

  Future<void> _triggerForceUpdate(
    Uri storeUrl,
    bool allowCancel,
  ) async {
    final ctx = widget.navigatorKey.currentContext ?? context;
    _isAlertVisible = true;
    final success = await widget.showForceUpdateAlert(
      ctx,
      allowCancel: allowCancel,
    );
    _isAlertVisible = false;
    if (success ?? false) {
      // * open app store page
      await widget.showStoreListing(storeUrl);
    } else if (success == false) {
      // * user clicked on the cancel button
    } else if (success == null && !allowCancel) {
      // * user clicked on the Android back button: show alert again
      return _triggerForceUpdate(storeUrl, allowCancel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
