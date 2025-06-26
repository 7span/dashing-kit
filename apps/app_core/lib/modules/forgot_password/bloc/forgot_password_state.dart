part of 'forgot_password_bloc.dart';

final class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const EmailValidator.pure(),
    this.isValid = false,
    this.errorMessage = '',
  });

  ForgotPasswordState copyWith({
    EmailValidator? email,
    bool? isValid,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  final FormzSubmissionStatus status;
  final EmailValidator email;
  final bool isValid;
  final String errorMessage;

  @override
  List<Object> get props => [status, email, isValid];
}
