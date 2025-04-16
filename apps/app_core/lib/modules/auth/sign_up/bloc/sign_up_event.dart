part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

final class SignUpNameChanged extends SignUpEvent {
  const SignUpNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

final class SignUpEmailChanged extends SignUpEvent {
  const SignUpEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

final class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class SignUpConfirmPasswordChanged extends SignUpEvent {
  const SignUpConfirmPasswordChanged({required this.confirmPassword, required this.password});

  final String password;
  final String confirmPassword;

  @override
  List<Object> get props => [confirmPassword, password];
}

final class SignUpUserConsentChangedEvent extends SignUpEvent {
  const SignUpUserConsentChangedEvent({required this.userConsent});

  final bool userConsent;

  @override
  List<Object> get props => [userConsent];
}

final class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}
