import 'package:api_client/api_client.dart';
import 'package:app_core/core/data/services/google_auth_helper.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required IAuthRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository,
      super(const ProfileState()) {
    on<Logout>(_logout);
  }

  final IAuthRepository _authenticationRepository;

  Future<void> _logout(
    Logout event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(apiStatus: ApiStatus.loading));
      await GoogleAuthHelper.signOut();
      await _authenticationRepository.logout();
      emit(state.copyWith(apiStatus: ApiStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(
          apiStatus: ApiStatus.error,
          errorMessage: 'Could not logout',
        ),
      );
    }
  }
}
