part of 'verify_otp_bloc.dart';

sealed class VerifyOTPEvent extends Equatable {
  const VerifyOTPEvent();

  @override
  List<Object> get props => [];
}

final class VerifyOTPChanged extends VerifyOTPEvent {
  const VerifyOTPChanged(this.otp);
  final String otp;

  @override
  List<Object> get props => [otp];
}

final class EmailAddressChanged extends VerifyOTPEvent {
  const EmailAddressChanged(this.email);
  final String email;
  @override
  List<Object> get props => [email];
}

final class VerifyButtonPressed extends VerifyOTPEvent {
  const VerifyButtonPressed();
}

final class ResendEmailEvent extends VerifyOTPEvent {
  const ResendEmailEvent();
}

class SetEmailEvent extends VerifyOTPEvent {
  const SetEmailEvent(this.email);
  final String email;

  @override
  List<Object> get props => [email];
}
