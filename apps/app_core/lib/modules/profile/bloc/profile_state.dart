// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.apiStatus = ApiStatus.initial,
    this.editProfileStatus = ApiStatus.initial,
    this.errorMessage = '',
    this.userModel,
    this.isPermissionDenied = false,
    this.imageFile,
    this.shouldLogout = false,
    this.name = const NameValidator.pure(),
    this.isValid = false,
  });

  final ApiStatus apiStatus;
  final ApiStatus editProfileStatus;
  final String errorMessage;
  final UserModel? userModel;
  final bool? isPermissionDenied;
  final File? imageFile;
  final bool shouldLogout;
  final NameValidator name;
  final bool isValid;

  @override
  List<Object?> get props => [
    apiStatus,
    editProfileStatus,
    errorMessage,
    userModel,
    isPermissionDenied,
    imageFile,
    shouldLogout,
    name,
    isValid,
  ];

  ProfileState copyWith({
    ApiStatus? apiStatus,
    ApiStatus? editProfileStatus,
    String? errorMessage,
    UserModel? userModel,
    bool? isPermissionDenied,
    File? imageFile,
    bool? shouldLogout,
    NameValidator? name,
    bool? isValid,
  }) {
    return ProfileState(
      apiStatus: apiStatus ?? this.apiStatus,
      editProfileStatus: editProfileStatus ?? this.editProfileStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      userModel: userModel ?? this.userModel,
      isPermissionDenied: isPermissionDenied ?? this.isPermissionDenied,
      imageFile: imageFile ?? this.imageFile,
      shouldLogout: shouldLogout ?? this.shouldLogout,
      name: name ?? this.name,
      isValid: isValid ?? this.isValid,
    );
  }
}
