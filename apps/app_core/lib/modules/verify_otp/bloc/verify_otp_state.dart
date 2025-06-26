part of 'verify_otp_bloc.dart';

final class VerifyOTPState extends Equatable {
  const VerifyOTPState({
    this.statusForResendOTP = ApiStatus.initial,
    this.statusForVerifyOTP = ApiStatus.initial,
    this.email = const EmailValidator.pure(),
    this.isValid = false,
    this.errorMessage = '',
    this.otp = '',
    this.otpIsValid = false,
  });

  VerifyOTPState copyWith({
    EmailValidator? email,
    bool? otpIsValid,
    bool? isValid,
    ApiStatus? statusForResendOTP,
    ApiStatus? statusForVerifyOTP,
    String? errorMessage,
    String? otp,
  }) {
    return VerifyOTPState(
      email: email ?? this.email,
      otpIsValid: otpIsValid ?? this.otpIsValid,
      isValid: isValid ?? this.isValid,
      statusForResendOTP: statusForResendOTP ?? this.statusForResendOTP,
      statusForVerifyOTP: statusForVerifyOTP ?? this.statusForVerifyOTP,
      errorMessage: errorMessage ?? this.errorMessage,
      otp: otp ?? this.otp,
    );
  }

  final ApiStatus statusForResendOTP;
  final ApiStatus statusForVerifyOTP;
  final EmailValidator email;
  final bool otpIsValid;
  final bool isValid;
  final String errorMessage;
  final String otp;

  @override
  List<Object> get props => [statusForResendOTP, email, otp, otpIsValid, isValid, errorMessage, statusForVerifyOTP];
}
