import 'package:api_client/api_client.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:app_notification_service/notification_service.dart';
import 'package:fpdart/fpdart.dart';

class LogoutService {
  Task<Unit> logout() {
    return getIt<IHiveService>()
        .clearData()
        .flatMap((e) => HiveApiService.instance.clearTokens())
        .map((e) => logoutNotification());
  }

  Unit logoutNotification() {
    getIt<NotificationServiceInterface>().logout();
    return unit;
  }
}
