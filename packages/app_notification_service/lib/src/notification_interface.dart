import 'dart:async';

import 'package:app_notification_service/src/notification_observer_event.dart';
import 'package:app_notification_service/src/user_model.dart';

abstract interface class NotificationServiceInterface {
  late final StreamController<NotificationObserverEvent> notificationObserverStream;

  Stream<NotificationObserverEvent> get listenForNotifications;

  Future<void> init(String? appId);

  Future<void> setData(NotificationUserModel model);

  Future<String> getNotificationSubscriptionId();

  Future<bool> requestNotificationPermission();

  void listenForNotification();

  void dispose();
}
