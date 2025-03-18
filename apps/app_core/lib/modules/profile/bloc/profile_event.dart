part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

final class Logout extends ProfileEvent {
  const Logout();

  @override
  List<Object?> get props => [];
}
