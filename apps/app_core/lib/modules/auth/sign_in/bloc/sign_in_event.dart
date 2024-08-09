part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

final class SignInEmailChanged extends SignInEvent {
  const SignInEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

final class SignInPasswordChanged extends SignInEvent {
  const SignInPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class SignInSubmitted extends SignInEvent {
  const SignInSubmitted();
}
