import 'dart:async';

import 'package:app_notification_service/src/notification_interface.dart';
import 'package:app_notification_service/src/notification_observer_event.dart';
import 'package:app_notification_service/src/user_model.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService implements NotificationServiceInterface {
  /// This will return us the device specific id that can be used in login and sign up API
  @override
  Future<String> getNotificationSubscriptionId() async {
    final playerID = OneSignal.User.pushSubscription.id;
    return playerID!;
  }

  /// Initialize Onesignal and set the log level for debugging purpose
  @override
  Future<void> init(String? appId, {bool shouldLog = true}) async {
    /// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push
    /// notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.initialize(appId!);

    if (shouldLog) {
      await OneSignal.Debug.setLogLevel(OSLogLevel.fatal);
    }
  }

  @override
  Future<void> setData(NotificationUserModel model) async {
    // Pass in email provided by customer
    await OneSignal.User.addEmail(model.email!);
    final externalId = model.userId!; // You will supply the external id to the OneSignal SDK
    await OneSignal.login(externalId);
  }

  @override
  Future<bool> requestNotificationPermission() async {
    if (OneSignal.Notifications.permission) {
      final isGranted = await OneSignal.Notifications.requestPermission(true);
      listenForNotification();
      return isGranted;
    } else {
      return false;
    }
  }

  @override
  void listenForNotification() {
    OneSignal.Notifications.addForegroundWillDisplayListener(
      (event) {
        final redirectionUrl = event.notification.additionalData?['redirection_url'] as String?;
        final notificationEventModel = NotificationObserverEvent(
          title: event.notification.title,
          body: event.notification.body,
          redirectionUrl: redirectionUrl,
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

  /// This stream is used for listening notifications from the app side
  @override
  StreamController<NotificationObserverEvent> notificationObserverStream = StreamController();
}
