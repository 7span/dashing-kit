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
  VerifyOTPBloc(this.authenticationRepository) : super(const VerifyOTPState()) {
    on<SetEmailEvent>(_onSetEmail);
    on<VerifyButtonPressed>(_onVerifyButtonPressed);
    on<VerifyOTPChanged>(_onVerifyOTPChanged);
    on<ResendEmailEvent>(_onResendEmail);
    on<StartTimerEvent>((event, emit) {
      emit(state.copyWith(isTimerRunning: true));
    });
    on<TimerFinishedEvent>((event, emit) {
      emit(state.copyWith(isTimerRunning: false));
    });
  }

  final AuthRepository authenticationRepository;

  void _onSetEmail(SetEmailEvent event, Emitter<VerifyOTPState> emit) {
    emit(state.copyWith(email: event.email));
  }

  Future<Unit> _onVerifyButtonPressed(VerifyButtonPressed event, Emitter<VerifyOTPState> emit) async {
    emit(state.copyWith(verifyOtpStatus: ApiStatus.loading, resendOtpStatus: ApiStatus.initial));
    // Static OTP check for now
    if (state.otp.value == '222222') {
      emit(state.copyWith(
        verifyOtpStatus: ApiStatus.loaded,
        resendOtpStatus: ApiStatus.initial,
        errorMessage: 'OTP verified successfully!',
      ));
    } else {
      emit(state.copyWith(
        verifyOtpStatus: ApiStatus.error,
        resendOtpStatus: ApiStatus.initial,
        errorMessage: 'Invalid OTP',
      ));
    }
    return unit;
  }

  final int _otpLength = 6;
  Future<Unit> _onVerifyOTPChanged(VerifyOTPChanged event, Emitter<VerifyOTPState> emit) async {
    final otp = LengthValidator.dirty(_otpLength, event.otp);
    emit(state.copyWith(otp: otp, verifyOtpStatus: ApiStatus.initial, resendOtpStatus: ApiStatus.initial));
    return unit;
  }

  Future<Unit> _onResendEmail(ResendEmailEvent event, Emitter<VerifyOTPState> emit) async {
    emit(
      state.copyWith(
        verifyOtpStatus: ApiStatus.initial,
        resendOtpStatus: ApiStatus.loading,
        otp: LengthValidator.pure(_otpLength),
      ),
    );
    final response =
        await authenticationRepository.forgotPassword(AuthRequestModel.forgotPassword(email: state.email)).run();

    response.fold(
      (failure) {
        emit(state.copyWith(resendOtpStatus: ApiStatus.error, verifyOtpStatus: ApiStatus.initial, errorMessage: failure.message));
      },
      (success) {
        emit(state.copyWith(verifyOtpStatus: ApiStatus.initial, resendOtpStatus: ApiStatus.loaded));
        add(const StartTimerEvent());
      },
    );
    return unit;
  }
}
