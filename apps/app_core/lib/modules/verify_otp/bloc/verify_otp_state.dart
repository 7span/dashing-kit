import 'package:api_client/api_client.dart';
import 'package:app_core/core/domain/validators/email_validator.dart';
import 'package:app_core/core/domain/validators/length_validator.dart';
import 'package:equatable/equatable.dart';

final class VerifyOTPState extends Equatable {
  const VerifyOTPState({
    this.statusForResendOTP = ApiStatus.initial,
    this.statusForVerifyOTP = ApiStatus.initial,
    this.email = const EmailValidator.pure(),
    this.errorMessage = '',
    this.otp = const LengthValidator.pure(6),
  });

  VerifyOTPState copyWith({
    EmailValidator? email,
    LengthValidator? otp,
    ApiStatus? statusForResendOTP,
    ApiStatus? statusForVerifyOTP,
    String? errorMessage,
  }) {
    return VerifyOTPState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      statusForResendOTP: statusForResendOTP ?? this.statusForResendOTP,
      statusForVerifyOTP: statusForVerifyOTP ?? this.statusForVerifyOTP,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  final ApiStatus statusForResendOTP;
  final ApiStatus statusForVerifyOTP;
  final EmailValidator email;
  final LengthValidator otp;
  final String errorMessage;

  bool get isValid => otp.isValid;

  @override
  List<Object> get props => [statusForResendOTP, email, otp, errorMessage, statusForVerifyOTP];
}
