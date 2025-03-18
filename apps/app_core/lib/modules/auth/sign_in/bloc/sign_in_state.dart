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
    this.responseModel,
  });

  final FormzSubmissionStatus status;
  final EmailValidator email;
  final PasswordValidator password;
  final bool isValid;
  final bool obscureText;
  final ApiStatus apiStatus;
  final String errorMessage;
  final AuthResponseModel? responseModel;

  @override
  List<Object?> get props => [
    status,
    email,
    password,
    isValid,
    obscureText,
    apiStatus,
    errorMessage,
    responseModel,
  ];

  SignInState copyWith({
    FormzSubmissionStatus? status,
    EmailValidator? email,
    PasswordValidator? password,
    bool? isValid,
    bool? obscureText,
    ApiStatus? apiStatus,
    AuthResponseModel? responseModel,
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
      responseModel: responseModel ?? this.responseModel,
    );
  }
}
