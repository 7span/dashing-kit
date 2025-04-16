import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:app_core/app/enum.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/app/helpers/permission/permission_helper.dart';
import 'package:app_core/core/data/models/user_model.dart';
import 'package:app_core/core/data/services/google_auth_helper.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:app_core/core/data/services/media.service.dart';
import 'package:app_core/core/domain/validators/name_validator.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/modules/profile/repository/profile_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:fpdart/fpdart.dart';
import 'package:permission_handler/permission_handler.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authenticationRepository, this._profileRepository)
    : super(const ProfileState());

  final IAuthRepository _authenticationRepository;
  final IProfileRepository _profileRepository;

  Future<void> logout() async {
    try {
      await GoogleAuthHelper.signOut();
    } catch (r) {
      emit(
        state.copyWith(
          apiStatus: ApiStatus.error,
          errorMessage: 'Could not logout',
        ),
      );
      return;
    }
    final logoutEither = await _authenticationRepository.logout().run();
    logoutEither.fold(
      (l) {
        emit(
          state.copyWith(
            apiStatus: ApiStatus.error,
            errorMessage: 'Could not logout',
            profileActionStatus: ProfileActionStatus.logoutDone,
          ),
        );
      },
      (r) => emit(
        state.copyWith(profileActionStatus: ProfileActionStatus.logoutDone),
      ),
    );
  }

  void fetchProfileDetailsFromHive() {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    getIt<IHiveService>().getUserData().fold(
      (l) => emit(
        state.copyWith(
          apiStatus: ApiStatus.error,
          errorMessage: 'Could not find profile information',
        ),
      ),
      (r) =>
          emit(state.copyWith(apiStatus: ApiStatus.loaded, userModel: r)),
    );
  }

  Future<void> fetchProfileDetail() async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    final fetchProfileEither =
        await _profileRepository.fetchProfileDetails().run();
    fetchProfileEither.fold(
      (l) => emit(
        state.copyWith(
          apiStatus: ApiStatus.error,
          errorMessage: 'Could not find profile information',
        ),
      ),
      (result) => emit(
        state.copyWith(
          apiStatus: ApiStatus.loaded,
          userModel: result,
          name: NameValidator.dirty(result.name),
        ),
      ),
    );
  }

  Future<void> deleteUserAccount() async {
    await GoogleAuthHelper.signOut();
    final logoutEither = await _profileRepository.deleteUser().run();
    logoutEither.fold(
      (l) => emit(
        state.copyWith(
          apiStatus: ApiStatus.error,
          errorMessage: 'Could not delete account',
          profileActionStatus: ProfileActionStatus.accountDeleted,
        ),
      ),
      (r) => emit(
        state.copyWith(profileActionStatus: ProfileActionStatus.accountDeleted),
      ),
    );
  }

  void onNameChange(String? name) {
    final nameValue = NameValidator.dirty(name ?? '');
    emit(state.copyWith(name: nameValue, isValid: Formz.validate([nameValue])));
  }

  Future<void> onAddImageTap() async {
    final permissionStatus = await Permission.mediaLibrary.status;
    if (permissionStatus == PermissionStatus.granted) {
      final image = await MediaService.instance.pickImage();
      if (image != null) {
        emit(state.copyWith(imageFile: image));
      }
    } else if (permissionStatus == PermissionStatus.denied) {
      await PermissionsHelper().requestPermission(MediaPermission.photo);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      emit(state.copyWith(isPermissionDenied: true));
    }
  }

  Future<void> onEditTap() async {
    final nameValue = NameValidator.dirty(state.name.value);
    emit(state.copyWith(name: nameValue, isValid: Formz.validate([nameValue])));

    if (!state.isValid) return;

    Future<Either<Failure, String?>> updateImage() async {
      return state.imageFile != null
          ? await _profileRepository.editProfileImage(state.imageFile!).run()
          : const Right(null);
    }

    final imageEither = await updateImage();
    imageEither.fold(
      (l) => emit(
        state.copyWith(
          errorMessage: 'Could not update profile image',
          apiStatus: ApiStatus.error,
        ),
      ),
      (imageURL) async {
        final profileEither =
            await _profileRepository
                .editProfile(
                  userModel: UserModel(
                    name: state.name.value,
                    email: (state.userModel?.email)!,
                    id: (state.userModel?.id)!,
                    profilePicUrl:
                        imageURL ?? (state.userModel?.profilePicUrl)!,
                  ),
                )
                .run();
        profileEither.fold(
          (l) => emit(
            state.copyWith(
              errorMessage: 'Could not update profile',
              apiStatus: ApiStatus.error,
            ),
          ),
          (r) {
            emit(
              state.copyWith(
                profileActionStatus: ProfileActionStatus.profileEdited,
              ),
            );
          },
        );
      },
    );
  }
}
