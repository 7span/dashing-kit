part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({this.isLoggedOut = false});

  final bool isLoggedOut;

  ProfileState copyWith({bool? isLoggedOut}) {
    return ProfileState(isLoggedOut: isLoggedOut ?? this.isLoggedOut);
  }

  @override
  List<Object?> get props => [isLoggedOut];
}
