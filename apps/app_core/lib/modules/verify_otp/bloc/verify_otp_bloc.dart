import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:app_core/core/domain/validators/length_validator.dart';
import 'package:app_core/modules/auth/model/auth_request_model.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/modules/verify_otp/bloc/verify_otp_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

part 'verify_otp_event.dart';

class VerifyOTPBloc extends Bloc<VerifyOTPEvent, VerifyOTPState> {
  VerifyOTPBloc(this.authenticationRepository, this.emailAddress) : super(const VerifyOTPState()) {
    on<VerifyButtonPressed>(_onVerifyButtonPressed);
    on<VerifyOTPChanged>(_onVerifyOTPChanged);
    on<ResendEmailEvent>(_onResendEmail);
  }

  final AuthRepository authenticationRepository;
  final String emailAddress;

  Future<Unit> _onVerifyButtonPressed(VerifyButtonPressed event, Emitter<VerifyOTPState> emit) async {
    emit(state.copyWith(statusForVerifyOTP: ApiStatus.loading, statusForResendOTP: ApiStatus.initial));
    final verifyOTPEither =
        await authenticationRepository.verifyOTP(AuthRequestModel.verifyOTP(email: emailAddress, token: state.otp.value)).run();

    verifyOTPEither.fold(
      (failure) {
        emit(
          state.copyWith(
            statusForVerifyOTP: ApiStatus.error,
            statusForResendOTP: ApiStatus.initial,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(state.copyWith(statusForVerifyOTP: ApiStatus.loaded, statusForResendOTP: ApiStatus.initial));
      },
    );
    return unit;
  }

  static const int _otpLength = 6;
  Future<Unit> _onVerifyOTPChanged(VerifyOTPChanged event, Emitter<VerifyOTPState> emit) async {
    final otp = LengthValidator.dirty(_otpLength, event.otp);
    emit(state.copyWith(otp: otp, statusForVerifyOTP: ApiStatus.initial, statusForResendOTP: ApiStatus.initial));
    return unit;
  }

  Future<Unit> _onResendEmail(ResendEmailEvent event, Emitter<VerifyOTPState> emit) async {
    emit(
      state.copyWith(
        statusForVerifyOTP: ApiStatus.initial,
        statusForResendOTP: ApiStatus.loading,
        otp: const LengthValidator.pure(_otpLength),
      ),
    );
    final response = await authenticationRepository.forgotPassword(AuthRequestModel.forgotPassword(email: emailAddress)).run();

    response.fold(
      (failure) {
        emit(
          state.copyWith(
            statusForResendOTP: ApiStatus.error,
            statusForVerifyOTP: ApiStatus.initial,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(state.copyWith(statusForVerifyOTP: ApiStatus.initial, statusForResendOTP: ApiStatus.loaded));
      },
    );
    return unit;
  }
}
