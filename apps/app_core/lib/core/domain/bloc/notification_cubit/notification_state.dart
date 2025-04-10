part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  const NotificationState({
    this.notificationPermissionStatus = PermissionStatus.denied,
    this.apiStatus = ApiStatus.initial,
  });

  final PermissionStatus notificationPermissionStatus;
  final ApiStatus apiStatus;

  @override
  List<Object?> get props => [notificationPermissionStatus, apiStatus];

  NotificationState copyWith({
    PermissionStatus? notificationPermissionStatus,
    ApiStatus? apiStatus,
  }) {
    return NotificationState(
      notificationPermissionStatus:
          notificationPermissionStatus ?? this.notificationPermissionStatus,
      apiStatus: apiStatus ?? this.apiStatus,
    );
  }
}
