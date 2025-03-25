import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:app_core/core/data/models/user_model.dart';
import 'package:app_core/core/data/services/google_auth_helper.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/modules/profile/repository/profile_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required IAuthRepository authenticationRepository,
    required IProfileRepository profileRepository,
  }) : _authenticationRepository = authenticationRepository,
       _profileRepository = profileRepository,
       super(const ProfileState()) {
    on<Logout>(_logout);
    on<FetchProfileDetails>(_fetchProfileDetails);
  }

  final IAuthRepository _authenticationRepository;
  final IProfileRepository _profileRepository;

  Future<void> _logout(
    Logout event,
    Emitter<ProfileState> emit,
  ) async {
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

  Future<void> _fetchProfileDetails(
    FetchProfileDetails event,
    Emitter<ProfileState> emit,
  ) async {
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
      (r) => emit(
        state.copyWith(apiStatus: ApiStatus.loaded, userModel: r),
      ),
    );
  }
}
