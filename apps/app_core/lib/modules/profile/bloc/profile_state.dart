// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.apiStatus = ApiStatus.initial,
    this.editProfileStatus = ApiStatus.initial,
    this.deleteApiStatus = ApiStatus.initial,
    this.logoutApiStatus = ApiStatus.initial,
    this.errorMessage = '',
    this.userModel,
    this.isPermissionDenied = false,
    this.imageFile,

    this.name = const NameValidator.pure(),
    this.isValid = false,
  });

  final ApiStatus apiStatus;
  final ApiStatus editProfileStatus;
  final ApiStatus logoutApiStatus;
  final ApiStatus deleteApiStatus;
  final String errorMessage;
  final UserModel? userModel;
  final bool? isPermissionDenied;
  final File? imageFile;

  final NameValidator name;
  final bool isValid;

  @override
  List<Object?> get props => [
    apiStatus,
    editProfileStatus,
    deleteApiStatus,
    logoutApiStatus,
    errorMessage,
    userModel,
    isPermissionDenied,
    imageFile,
    name,
    isValid,
  ];

  ProfileState copyWith({
    ApiStatus? apiStatus,
    ApiStatus? editProfileStatus,
    ApiStatus? logoutApiStatus,
    ApiStatus? deleteApiStatus,
    String? errorMessage,
    UserModel? userModel,
    bool? isPermissionDenied,
    File? imageFile,
    NameValidator? name,
    bool? isValid,
  }) {
    return ProfileState(
      apiStatus: apiStatus ?? this.apiStatus,
      editProfileStatus: editProfileStatus ?? this.editProfileStatus,
      logoutApiStatus: logoutApiStatus ?? this.logoutApiStatus,
      deleteApiStatus: deleteApiStatus ?? this.deleteApiStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      userModel: userModel ?? this.userModel,
      isPermissionDenied: isPermissionDenied ?? this.isPermissionDenied,
      imageFile: imageFile ?? this.imageFile,
      name: name ?? this.name,
      isValid: isValid ?? this.isValid,
    );
  }
}
