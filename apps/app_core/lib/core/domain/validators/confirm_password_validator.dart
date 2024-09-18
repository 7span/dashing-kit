import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { invalid }

final class ConfirmPasswordValidator extends FormzInput<String, ConfirmPasswordValidationError> {
  // const ConfirmPasswordValidator({required this.password}) : super.pure('');

  const ConfirmPasswordValidator.pure({this.password = ''}) : super.pure('');

  const ConfirmPasswordValidator.dirty({required this.password, String value = ''})
      : super.dirty(value);

  final String password;

  @override
  ConfirmPasswordValidationError? validator(String value) {
    return value == password ? null : ConfirmPasswordValidationError.invalid;
  }
}
