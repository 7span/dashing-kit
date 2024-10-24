import 'dart:async';
import 'dart:developer';

import 'package:api_client/api_client.dart';
import 'package:app_core/app/enum.dart';
import 'package:app_core/core/data/services/network_helper.service.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/core/domain/validators/login_validators.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({required IAuthRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const SignInState()) {
    on<SignInEmailChanged>(_onEmailChanged);
    on<SignInPasswordChanged>(_onPasswordChanged);
    on<SignInSubmitted>(_onSubmitted);
    on<SignInWithGoogleTaped>(_onSignInWithGoogleTaped);
  }
  final IAuthRepository _authenticationRepository;

  void _onEmailChanged(SignInEmailChanged event, Emitter<SignInState> emit) {
    final email = EmailValidator.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void _onPasswordChanged(SignInPasswordChanged event, Emitter<SignInState> emit) {
    final password = PasswordValidator.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  Future<void> _onSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    final email = EmailValidator.dirty(state.email.value);
    final password = PasswordValidator.dirty(state.password.value);
    emit(
      state.copyWith(
        email: email,
        password: password,
        isValid: Formz.validate([email, password]),
      ),
    );
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      final loginEither = await _authenticationRepository
          .login(
            state.email.value.trim(),
            state.password.value.trim(),
          )
          .run();

      loginEither.fold(
        (failure) {
          log('failure: $failure');
          emit(state.copyWith(status: FormzSubmissionStatus.failure));
        },
        (success) => emit(state.copyWith(status: FormzSubmissionStatus.success)),
      );
    }
  }

  Future<void> _onSignInWithGoogleTaped(
    SignInWithGoogleTaped event,
    Emitter<SignInState> emit,
  ) async {
    try {
      emit(state.copyWith(apiStatus: ApiStatus.loading));
      if (NetWorkInfoService.instance.isConnected == ConnectionStatus.online) {
        final isSignInSuccess = await _authenticationRepository.signInWithGoogle();
        if (isSignInSuccess) {
          emit(state.copyWith(apiStatus: ApiStatus.loaded));
        } else {
          emit(
            state.copyWith(
              apiStatus: ApiStatus.error,
              errorMessage: 'Could not sign in with Google',
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            apiStatus: ApiStatus.error,
            errorMessage: 'Please check your internet connection',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          apiStatus: ApiStatus.error,
          errorMessage: 'Something went wrong! please try again later',
        ),
      );
    }
  }
}
