import 'package:app_core/core/domain/validators/confirm_password_validator.dart';
import 'package:app_core/core/domain/validators/password_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

final class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.password = const PasswordValidator.pure(),
    this.confirmPassword = const ConfirmPasswordValidator.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
  });

  ChangePasswordState copyWith({
    FormzSubmissionStatus? status,
    bool? isValid,
    PasswordValidator? password,
    ConfirmPasswordValidator? confirmPassword,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  final FormzSubmissionStatus status;
  final bool isValid;
  final PasswordValidator password;
  final ConfirmPasswordValidator confirmPassword;

  @override
  List<Object> get props => [status, password, confirmPassword, isValid];
}
