import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

final class PasswordValidator extends FormzInput<String, PasswordValidationError> {
  const PasswordValidator.pure([super.value = '']) : super.pure();
  const PasswordValidator.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String? value) {
    return (value?.length ?? 0) >= 3 ? null : PasswordValidationError.invalid;
  }
}
