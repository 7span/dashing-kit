part of 'change_password_cubit.dart';

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
