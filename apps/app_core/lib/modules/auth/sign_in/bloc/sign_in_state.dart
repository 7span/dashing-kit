part of 'sign_in_bloc.dart';

final class SignInState extends Equatable {
  const SignInState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const EmailValidator.pure(),
    this.password = const PasswordValidator.pure(),
    this.isValid = false,
    this.obscureText = true,
    this.errorMessage = '',
    this.responseModel,
  });

  final FormzSubmissionStatus status;
  final EmailValidator email;
  final PasswordValidator password;
  final bool isValid;
  final bool obscureText;
  final String errorMessage;
  final AuthResponseModel? responseModel;

  @override
  List<Object?> get props => [
    status,
    email,
    password,
    isValid,
    obscureText,
    errorMessage,
    responseModel,
  ];

  SignInState copyWith({
    FormzSubmissionStatus? status,
    EmailValidator? email,
    PasswordValidator? password,
    bool? isValid,
    bool? obscureText,
    AuthResponseModel? responseModel,
    String? errorMessage,
  }) {
    return SignInState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      obscureText: obscureText ?? this.obscureText,
      errorMessage: errorMessage ?? this.errorMessage,
      responseModel: responseModel ?? this.responseModel,
    );
  }
}
