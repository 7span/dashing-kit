import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_notification_service/notification_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/material.dart';

class OneSignalService implements NotificationServiceInterface {
  /// Singleton instance
  static final OneSignalService _instance = OneSignalService._internal();
  factory OneSignalService() => _instance;
  OneSignalService._internal();

  bool _isInitialized = false;
  String? _appId;

  /// This will return us the device specific id that can be used in login and sign up API
  @override
  Future<String> getNotificationSubscriptionId() async {
    final playerID = OneSignal.User.pushSubscription.id;
    return playerID ?? '';
  }

  /// Initialize Onesignal and set the log level for debugging purpose
  @override
  Future<void> init(String appId, {bool shouldLog = true}) async {
    if (_isInitialized) return;

    _appId = appId;
    await OneSignal.consentRequired(true);
    await OneSignal.consentGiven(false); // Default to false until user grants consent

    if (Platform.isIOS) {
      await OneSignal.Location.setShared(false);
    }

    OneSignal.initialize(appId);

    if (shouldLog) {
      await OneSignal.Debug.setLogLevel(OSLogLevel.fatal);
    }

    _isInitialized = true;
    listenForNotification(); // Setup listeners even before permission granted
  }

  @override
  Future<void> setData(NotificationUserModel model) async {
    // Pass in email provided by customer
    await OneSignal.User.addEmail(model.email);
    final externalId = model.userId;
    await OneSignal.login(externalId);
  }

  /// Show a consent dialog before requesting notification permission
  Future<bool> showConsentDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enable Notifications'),
          content: const Text(
              'We would like to send you notifications for important updates, alerts, and messages. '
                  'Would you like to enable notifications?'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Not Now'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// Request notification permission with consent dialog
  Future<bool> requestNotificationPermissionWithConsent(BuildContext context) async {
    try {
      // First check if permission is already granted
      if (OneSignal.Notifications.permission) {
        log('Permission already granted');
        return true;
      }

      // Show consent dialog
      final userConsent = await showConsentDialog(context);
      if (!userConsent) {
        log('User declined consent dialog');
        return false;
      }

      // User gave consent, now grant consent in OneSignal
      await OneSignal.consentGiven(true);

      // Request actual permission
      final isGranted = await OneSignal.Notifications.requestPermission(true);
      log('Permission request result: $isGranted');
      return isGranted;
    } catch (e) {
      log('Permission request error: $e');
      return false;
    }
  }

  @override
  Future<bool> requestNotificationPermission() async {
    try {
      // This method should be called after consent is given
      if (!OneSignal.Notifications.permission) {
        final isGranted = await OneSignal.Notifications.requestPermission(true);
        log('Permission request: $isGranted');
        return isGranted;
      } else {
        log('Permission already granted');
        return true;
      }
    } catch (e) {
      log('Permission request error: $e');
      return false;
    }
  }

  @override
  void listenForNotification() {
    OneSignal.Notifications.addClickListener(
          (event) {
        final data = event.notification.additionalData;
        final notificationEventModel = NotificationObserverEvent(
          title: event.notification.title,
          body: event.notification.body,
          data: data,
        );
        notificationObserverStream.sink.add(notificationEventModel);
      },
    );
  }

  @override
  Stream<NotificationObserverEvent> get listenForNotifications => notificationObserverStream.stream;

  @override
  void dispose() {
    notificationObserverStream.close();
  }

  @override
  Future<void> logout() async {
    await OneSignal.logout();
  }

  /// This stream is used for listening notifications from the app side
  @override
  StreamController<NotificationObserverEvent> notificationObserverStream = StreamController.broadcast();
}