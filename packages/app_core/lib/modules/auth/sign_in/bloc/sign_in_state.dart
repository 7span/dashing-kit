// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_in_bloc.dart';

final class SignInState extends Equatable {
  const SignInState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const EmailValidator.pure(),
    this.password = const PasswordValidator.pure(),
    this.isValid = false,
    this.obscureText = true,
  });

  SignInState copyWith({
    EmailValidator? email,
    EmailValidator? forgotPasswordEmail,
    PasswordValidator? password,
    bool? isValid,
    bool? obscureText,
    FormzSubmissionStatus? status,
    int? forgotPasswordBottomSheetPage,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      obscureText: obscureText ?? this.obscureText,
    );
  }

  final FormzSubmissionStatus status;
  final EmailValidator email;
  final PasswordValidator password;
  final bool isValid;
  final bool obscureText;

  @override
  List<Object> get props => [status, email, password, isValid, obscureText];
}
