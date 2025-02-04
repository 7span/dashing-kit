import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<UserProfileLogoutEvent>(_onLogout);
  }

  Future<void> _onLogout(UserProfileLogoutEvent event, Emitter<ProfileState> emit) async {
    await getIt<IHiveService>().clearData().run();
    emit(state.copyWith(isLoggedOut: true));
  }
}
