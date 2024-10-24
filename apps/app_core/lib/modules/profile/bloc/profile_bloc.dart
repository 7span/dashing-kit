import 'package:api_client/api_client.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required IAuthRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(ProfileState()) {
    on<Logout>(_logout);
  }

  final IAuthRepository _authenticationRepository;

  Future<void> _logout(
    Logout event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(apiStatus: ApiStatus.loading));
      await _authenticationRepository.logout();
      emit(state.copyWith(apiStatus: ApiStatus.loaded));
    } catch (e) {
      emit(state.copyWith(apiStatus: ApiStatus.error, errorMessage: 'Could not logout'));
    }
  }
}
