import 'package:api_client/api_client.dart';
import 'package:app_core/core/domain/validators/confirm_password_validator.dart';
import 'package:app_core/core/domain/validators/password_validator.dart';
import 'package:app_core/modules/profile/repository/profile_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._profileRepository)
    : super(const ChangePasswordState());

  final IProfileRepository _profileRepository;

  void onPasswordChange(String password) {
    final passwordValue = PasswordValidator.dirty(password);
    emit(
      state.copyWith(
        password: passwordValue,
        confirmPassword: state.confirmPassword,
        isValid: Formz.validate([passwordValue, state.confirmPassword]),
      ),
    );
  }

  void onConfirmPasswordChange({
    required String password,
    required String confirmPassword,
  }) {
    final confirmPasswordValue = ConfirmPasswordValidator.dirty(
      password: password,
      value: confirmPassword,
    );
    emit(
      state.copyWith(
        confirmPassword: confirmPasswordValue,
        isValid: Formz.validate([state.password, confirmPasswordValue]),
      ),
    );
  }

  Future<void> onSubmitPassword() async {
    final password = PasswordValidator.dirty(state.password.value);
    final confirmPassword = ConfirmPasswordValidator.dirty(
      password: state.password.value,
      value: state.confirmPassword.value,
    );

    emit(
      state.copyWith(
        password: password,
        confirmPassword: confirmPassword,
        isValid: Formz.validate([password, confirmPassword]),
      ),
    );

    if (state.isValid) {
      emit(state.copyWith(apiStatus: ApiStatus.loading));
      final result =
          await _profileRepository
              .changePassword(newPassword: state.password.value)
              .run();
      result.fold(
        (failure) => emit(state.copyWith(apiStatus: ApiStatus.error)),
        (success) => emit(state.copyWith(apiStatus: ApiStatus.loaded)),
      );
    }
  }
}
