import 'package:api_client/api_client.dart';
import 'package:app_core/core/domain/validators/confirm_password_validator.dart';
import 'package:app_core/core/domain/validators/password_validator.dart';
import 'package:equatable/equatable.dart';

final class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.password = const PasswordValidator.pure(),
    this.confirmPassword = const ConfirmPasswordValidator.pure(),
    this.isValid = false,
    this.apiStatus = ApiStatus.initial,
  });

  final ApiStatus apiStatus;
  final bool isValid;
  final PasswordValidator password;
  final ConfirmPasswordValidator confirmPassword;

  @override
  List<Object> get props => [apiStatus, password, confirmPassword, isValid];

  ChangePasswordState copyWith({
    ApiStatus? apiStatus,
    bool? isValid,
    PasswordValidator? password,
    ConfirmPasswordValidator? confirmPassword,
  }) {
    return ChangePasswordState(
      apiStatus: apiStatus ?? this.apiStatus,
      isValid: isValid ?? this.isValid,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
