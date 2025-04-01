// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

enum ProfileActionStatus {
  profileEdited,
  logoutDone,
  accountDeleted,
  none,
}

class ProfileState extends Equatable {
  const ProfileState({
    this.apiStatus = ApiStatus.initial,
    this.profileActionStatus = ProfileActionStatus.none,
    this.errorMessage = '',
    this.userModel,
    this.isPermissionDenied = false,
    this.imageFile,
    this.name = const NameValidator.pure(),
    this.isValid = false,
  });

  final ApiStatus apiStatus;
  final ProfileActionStatus profileActionStatus;
  final String errorMessage;
  final UserModel? userModel;
  final bool? isPermissionDenied;
  final File? imageFile;
  final NameValidator name;
  final bool isValid;

  @override
  List<Object?> get props => [
    apiStatus,
    profileActionStatus,
    errorMessage,
    userModel,
    isPermissionDenied,
    imageFile,
    name,
    isValid,
  ];

  ProfileState copyWith({
    ApiStatus? apiStatus,
    ProfileActionStatus? profileActionStatus,
    String? errorMessage,
    UserModel? userModel,
    bool? isPermissionDenied,
    File? imageFile,
    NameValidator? name,
    bool? isValid,
  }) {
    return ProfileState(
      apiStatus: apiStatus ?? this.apiStatus,
      profileActionStatus:
          profileActionStatus ?? this.profileActionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      userModel: userModel ?? this.userModel,
      isPermissionDenied:
          isPermissionDenied ?? this.isPermissionDenied,
      imageFile: imageFile ?? this.imageFile,
      name: name ?? this.name,
      isValid: isValid ?? this.isValid,
    );
  }
}
