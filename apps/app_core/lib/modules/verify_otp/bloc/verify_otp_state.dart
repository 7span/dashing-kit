import 'package:api_client/api_client.dart';
import 'package:app_core/core/domain/validators/email_validator.dart';
import 'package:app_core/core/domain/validators/length_validator.dart';
import 'package:equatable/equatable.dart';

final class VerifyOTPState extends Equatable {
  const VerifyOTPState({
    this.resendOtpStatus = ApiStatus.initial,
    this.verifyOtpStatus = ApiStatus.initial,
    this.email = const EmailValidator.pure(),
    this.errorMessage = '',
    this.otp = const LengthValidator.pure(6),
  });

  VerifyOTPState copyWith({
    EmailValidator? email,
    LengthValidator? otp,
    ApiStatus? resendOtpStatus,
    ApiStatus? verifyOtpStatus,
    String? errorMessage,
  }) {
    return VerifyOTPState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      resendOtpStatus: resendOtpStatus ?? this.resendOtpStatus,
      verifyOtpStatus: verifyOtpStatus ?? this.verifyOtpStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  final ApiStatus resendOtpStatus;
  final ApiStatus verifyOtpStatus;
  final EmailValidator email;
  final LengthValidator otp;
  final String errorMessage;

  bool get isValid => otp.isValid && email.isValid;

  @override
  List<Object> get props => [resendOtpStatus, email, otp, errorMessage, verifyOtpStatus];
}
