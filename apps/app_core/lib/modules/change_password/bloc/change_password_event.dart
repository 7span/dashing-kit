import 'package:equatable/equatable.dart';

sealed class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class OnPasswordChangeEvent extends ChangePasswordEvent {
  const OnPasswordChangeEvent(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class OnConfirmPasswordChangeEvent extends ChangePasswordEvent {
  const OnConfirmPasswordChangeEvent({
    required this.password,
    required this.confirmPassword,
  });

  final String password;
  final String confirmPassword;

  @override
  List<Object> get props => [password, confirmPassword];
}

final class OnSubmitPasswordEvent extends ChangePasswordEvent {
  const OnSubmitPasswordEvent();
}
