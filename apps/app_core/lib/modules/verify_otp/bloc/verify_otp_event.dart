part of 'verify_otp_bloc.dart';

abstract class VerifyOTPEvent {}

class VerifyOTPChanged extends VerifyOTPEvent {
  VerifyOTPChanged(this.otp);
  final String otp;
}

class EmailAddressChanged extends VerifyOTPEvent {
  EmailAddressChanged(this.email);
  final String email;
}

class VerifyButtonPressed extends VerifyOTPEvent {}

class ResendEmailEvent extends VerifyOTPEvent {}
