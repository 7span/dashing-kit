import 'package:api_client/api_client.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/core/data/models/user_model.dart';
import 'package:app_core/core/data/services/google_auth_helper.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:app_core/core/domain/validators/name_validator.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/modules/profile/repository/profile_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._authenticationRepository,
    this._profileRepository,
  ) : super(const ProfileState());

  final IAuthRepository _authenticationRepository;
  final IProfileRepository _profileRepository;

  Future<void> logout() async {
    try {
      await GoogleAuthHelper.signOut();
      final logoutEither =
          await _authenticationRepository.logout().run();
      logoutEither.fold(
        (l) => emit(
          state.copyWith(
            apiStatus: ApiStatus.error,
            errorMessage: 'Could not logout',
          ),
        ),
        (r) => emit(state.copyWith(shouldLogout: true)),
      );
    } catch (e) {
      emit(
        state.copyWith(
          apiStatus: ApiStatus.error,
          errorMessage: 'Could not logout',
        ),
      );
    }
  }

  Future<void> fetchProfileDetailsFromHive() async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    getIt<IHiveService>().getUserData().fold(
      (l) => emit(
        state.copyWith(
          apiStatus: ApiStatus.error,
          errorMessage: 'Could not find profile information',
        ),
      ),
      (r) => emit(
        state.copyWith(
          apiStatus: ApiStatus.loaded,
          userModel: r.first,
        ),
      ),
    );
  }

  Future<void> makeProfileDetailApi() async {
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
      (result) {
        if (kDebugMode) {
          print('UserModel Meow : ${result.name}');
        }
        emit(
          state.copyWith(
            apiStatus: ApiStatus.loaded,
            userModel: result,
          ),
        );
      },
    );
  }

  void onNameChange(String? name) {
    final nameValue = NameValidator.dirty(name ?? '');
    emit(
      state.copyWith(
        name: nameValue,
        isValid: Formz.validate([nameValue]),
      ),
    );
  }

  Future<void> onEditTap() async {
    final nameValue = NameValidator.dirty(state.name.value);
    emit(
      state.copyWith(
        name: nameValue,
        isValid: Formz.validate([nameValue]),
      ),
    );
    if (state.isValid) {
      emit(state.copyWith(editProfileStatus: ApiStatus.loading));
      final makeEditProfileApi =
          await _profileRepository
              .editProfile(name: state.name.value)
              .run();
      makeEditProfileApi.fold(
        (l) => emit(
          state.copyWith(
            errorMessage: 'Could not update profile',
            apiStatus: ApiStatus.error,
          ),
        ),
        (r) =>
            emit(state.copyWith(editProfileStatus: ApiStatus.loaded)),
      );
    }
  }
}
