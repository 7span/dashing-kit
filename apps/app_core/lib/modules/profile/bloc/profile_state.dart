part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.apiStatus = ApiStatus.initial,
    this.errorMessage = '',
  });

  final ApiStatus apiStatus;
  final String errorMessage;

  ProfileState copyWith({
    ApiStatus? apiStatus,
    String? errorMessage,
  }) {
    return ProfileState(
      apiStatus: apiStatus ?? this.apiStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [apiStatus, errorMessage];
}
