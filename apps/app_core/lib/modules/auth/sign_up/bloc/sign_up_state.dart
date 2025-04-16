// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_up_bloc.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    this.status = FormzSubmissionStatus.initial,

    /// Used for reqres.in mock api (eve.holt@reqres.in)
    this.email = const EmailValidator.pure('eve.holt@reqres.in'),
    this.name = const NameValidator.pure(),
    this.password = const PasswordValidator.pure(),
    this.confirmPassword = const ConfirmPasswordValidator.pure(),
    this.isValid = false,
    this.obscureText = true,
    this.isUserConsent = false,
  });

  SignUpState copyWith({
    EmailValidator? email,
    NameValidator? name,
    EmailValidator? forgotPasswordEmail,
    PasswordValidator? password,
    ConfirmPasswordValidator? confirmPassword,
    bool? isValid,
    bool? obscureText,
    FormzSubmissionStatus? status,
    int? forgotPasswordBottomSheetPage,
    bool? isUserConsent,
  }) {
    return SignUpState(
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      obscureText: obscureText ?? this.obscureText,
      isUserConsent: isUserConsent ?? this.isUserConsent,
    );
  }

  final FormzSubmissionStatus status;
  final EmailValidator email;
  final NameValidator name;
  final PasswordValidator password;
  final ConfirmPasswordValidator confirmPassword;
  final bool isValid;
  final bool obscureText;
  final bool isUserConsent;

  @override
  List<Object> get props => [
    status,
    name,
    email,
    password,
    confirmPassword,
    isValid,
    obscureText,
    isUserConsent,
  ];
}
