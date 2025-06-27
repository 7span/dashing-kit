import 'package:api_client/api_client.dart';
import 'package:app_core/core/domain/validators/email_validator.dart';
import 'package:app_core/core/domain/validators/length_validator.dart';
import 'package:equatable/equatable.dart';

final class VerifyOTPState extends Equatable {
  const VerifyOTPState({
    this.resendOtpStatus = ApiStatus.initial,
    this.verifyOtpStatus = ApiStatus.initial,
    this.email = '',
    this.errorMessage = '',
    this.otp = const LengthValidator.pure(6),
    this.isTimerRunning = true,
  });

  VerifyOTPState copyWith({
    String? email,
    LengthValidator? otp,
    ApiStatus? resendOtpStatus,
    ApiStatus? verifyOtpStatus,
    String? errorMessage,
    bool? isTimerRunning,
  }) {
    return VerifyOTPState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      resendOtpStatus: resendOtpStatus ?? this.resendOtpStatus,
      verifyOtpStatus: verifyOtpStatus ?? this.verifyOtpStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
    );
  }

  final ApiStatus resendOtpStatus;
  final ApiStatus verifyOtpStatus;
  final String email;
  final String errorMessage;
  final LengthValidator otp;
  final bool isTimerRunning;

  bool get isValid => otp.isValid;

  @override
  List<Object> get props => [resendOtpStatus, email, otp, errorMessage, verifyOtpStatus, isTimerRunning];
}
