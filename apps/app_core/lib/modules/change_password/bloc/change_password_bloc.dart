import 'package:api_client/api_client.dart';
import 'package:app_core/core/domain/validators/confirm_password_validator.dart';
import 'package:app_core/core/domain/validators/login_validators.dart';
import 'package:app_core/modules/change_password/bloc/change_password_event.dart';
import 'package:app_core/modules/change_password/bloc/change_password_state.dart';
import 'package:app_core/modules/change_password/repository/change_password_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc({required this.repository})
    : super(const ChangePasswordState()) {
    on<OnPasswordChangeEvent>(_onPasswordChangeEvent);
    on<OnConfirmPasswordChangeEvent>(_onConfirmPasswordChangeEvent);
    on<OnSubmitPasswordEvent>(_onSubmitPasswordEvent);
  }

  final IChangePasswordRepository repository;

  void _onPasswordChangeEvent(
    OnPasswordChangeEvent event,
    Emitter<ChangePasswordState> emit,
  ) {
    final password = PasswordValidator.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        confirmPassword: state.confirmPassword,
        isValid: Formz.validate([password, state.confirmPassword]),
      ),
    );
  }

  void _onConfirmPasswordChangeEvent(
    OnConfirmPasswordChangeEvent event,
    Emitter<ChangePasswordState> emit,
  ) {
    final confirmPassword = ConfirmPasswordValidator.dirty(
      password: event.password,
      value: event.confirmPassword,
    );
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        isValid: Formz.validate([state.password, confirmPassword]),
      ),
    );
  }

  Future<void> _onSubmitPasswordEvent(
    OnSubmitPasswordEvent event,
    Emitter<ChangePasswordState> emit,
  ) async {
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
          await repository
              .changePassword(newPassword: state.password.value)
              .run();
      result.fold(
        (failure) => emit(state.copyWith(apiStatus: ApiStatus.error)),
        (success) => emit(state.copyWith(apiStatus: ApiStatus.loaded)),
      );
    }
  }
}
