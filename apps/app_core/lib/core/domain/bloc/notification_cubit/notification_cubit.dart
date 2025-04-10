import 'package:api_client/api_client.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/modules/home/repository/home_repository.dart';
import 'package:app_notification_service/notification_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:app_core/app/helpers/extensions/extensions.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this._homeRepository) : super(const NotificationState());

  final IHomeRepository _homeRepository;

  final NotificationServiceInterface _notificationService =
      getIt<NotificationServiceInterface>();

  Future<void> checkNotificationPermissionStatus() async {
    final status = await Permission.notification.status;
    emit(state.copyWith(notificationPermissionStatus: status));
  }

  Future<void> checkAndSavePlayerID(BuildContext context) async {
    if (context.playerId.isNotEmpty) return;
    try {
      final playerId =
          await _notificationService.getNotificationSubscriptionId();
      if (playerId.isNotEmpty) {
        final setPlayerIDEither =
            await _homeRepository.setPlayerId(playerId).run();
        setPlayerIDEither.fold(
          (error) => emit(state.copyWith(apiStatus: ApiStatus.error)),
          (result) => emit(state.copyWith(apiStatus: ApiStatus.loaded)),
        );
      } else {
        emit(state.copyWith(apiStatus: ApiStatus.error));
      }
    } catch (e) {
      emit(state.copyWith(apiStatus: ApiStatus.error));
    }
  }
}
