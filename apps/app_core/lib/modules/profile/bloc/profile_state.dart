part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.apiStatus = ApiStatus.initial,
    this.editProfileStatus = ApiStatus.initial,
    this.errorMessage = '',
    this.userModel,
    this.shouldLogout = false,
    this.name = const NameValidator.pure(),
    this.isValid = false,
  });

  final ApiStatus apiStatus;
  final ApiStatus editProfileStatus;
  final String errorMessage;
  final UserModel? userModel;
  final bool shouldLogout;
  final NameValidator name;
  final bool isValid;

  @override
  List<Object?> get props => [
    apiStatus,
    editProfileStatus,
    errorMessage,
    userModel,
    shouldLogout,
    name,
    isValid,
  ];

  ProfileState copyWith({
    ApiStatus? apiStatus,
    ApiStatus? editProfileStatus,
    String? errorMessage,
    UserModel? userModel,
    bool? shouldLogout,
    NameValidator? name,
    bool? isValid,
  }) {
    return ProfileState(
      apiStatus: apiStatus ?? this.apiStatus,
      editProfileStatus: apiStatus ?? this.apiStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      userModel: userModel ?? this.userModel,
      shouldLogout: shouldLogout ?? this.shouldLogout,
      name: name ?? this.name,
      isValid: isValid ?? this.isValid,
    );
  }
}
