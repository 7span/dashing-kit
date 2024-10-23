import 'dart:async';
import 'dart:developer';

import 'package:app_core/core/domain/validators/confirm_password_validator.dart';
import 'package:app_core/core/domain/validators/name_validator.dart';
import 'package:app_core/modules/auth/model/auth_request_model.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/core/domain/validators/login_validators.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({required IAuthRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const SignUpState()) {
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpNameChanged>(_onNameChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignUpSubmitted>(_onSubmitted);
  }

  final IAuthRepository _authenticationRepository;

  FutureOr<void> _onNameChanged(SignUpNameChanged event, Emitter<SignUpState> emit) {
    final name = NameValidator.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        isValid: Formz.validate([name, state.email,state.password, state.confirmPassword]),
      ),
    );
  }

  void _onEmailChanged(SignUpEmailChanged event, Emitter<SignUpState> emit) {
    final email = EmailValidator.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([state.name, email, state.password, state.confirmPassword]),
      ),
    );
  }

  void _onPasswordChanged(SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    final password = PasswordValidator.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.name, state.email, password,state.confirmPassword]),
      ),
    );
  }

  FutureOr<void> _onConfirmPasswordChanged(SignUpConfirmPasswordChanged event, Emitter<SignUpState> emit) {
    final confirmPassword = ConfirmPasswordValidator.dirty(password: event.password,value: event.confirmPassword);
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        isValid: Formz.validate([state.name, state.email, state.password,confirmPassword]),
      ),
    );
  }

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    final email = EmailValidator.dirty(state.email.value);
    final name = NameValidator.dirty(state.name.value);
    final password = PasswordValidator.dirty(state.password.value);
    final confirmPassword = ConfirmPasswordValidator.dirty(password: state.password.value,value: state.confirmPassword.value);
    emit(
      state.copyWith(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        isValid: Formz.validate([name, email, password,confirmPassword]),
      ),
    );
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      final loginEither = await _authenticationRepository
          .signup(
            AuthRequestModel(
              email: state.email.value.trim(),
              password: state.password.value.trim(),
              name: state.name.value.trim(),
              avatar: 'https://picsum.photos/1000',
            ),
          )
          .run();

      loginEither.fold(
        (failure) {
          log('failure: $failure');
          emit(state.copyWith(status: FormzSubmissionStatus.failure));
        },
        (success) {
          emit(state.copyWith(status: FormzSubmissionStatus.success));
        },
      );
    }
  }
}
