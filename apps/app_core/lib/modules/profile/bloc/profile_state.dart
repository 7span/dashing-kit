part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.apiStatus = ApiStatus.initial,
    this.errorMessage = '',
    this.userModel,
    this.shouldLogout = false,
  });

  final ApiStatus apiStatus;
  final String errorMessage;
  final UserModel? userModel;
  final bool shouldLogout;

  @override
  List<Object?> get props => [
    apiStatus,
    errorMessage,
    userModel,
    shouldLogout,
  ];

  ProfileState copyWith({
    ApiStatus? apiStatus,
    String? errorMessage,
    UserModel? userModel,
    bool? shouldLogout,
  }) {
    return ProfileState(
      apiStatus: apiStatus ?? this.apiStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      userModel: userModel ?? this.userModel,
      shouldLogout: shouldLogout ?? this.shouldLogout,
    );
  }
}
