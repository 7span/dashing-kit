// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_in_bloc.dart';

final class SignInState extends Equatable {
  const SignInState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const EmailValidator.pure(),
    this.password = const PasswordValidator.pure(),
    this.isValid = false,
    this.obscureText = true,
    this.apiStatus = ApiStatus.initial,
    this.errorMessage = '',
  });

  final FormzSubmissionStatus status;
  final EmailValidator email;
  final PasswordValidator password;
  final bool isValid;
  final bool obscureText;
  final ApiStatus apiStatus;
  final String errorMessage;
  @override
  List<Object> get props => [
        status,
        email,
        password,
        isValid,
        obscureText,
        apiStatus,
        errorMessage,
      ];

  SignInState copyWith({
    FormzSubmissionStatus? status,
    EmailValidator? email,
    PasswordValidator? password,
    bool? isValid,
    bool? obscureText,
    ApiStatus? apiStatus,
    String? errorMessage,
  }) {
    return SignInState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      obscureText: obscureText ?? this.obscureText,
      apiStatus: apiStatus ?? this.apiStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
