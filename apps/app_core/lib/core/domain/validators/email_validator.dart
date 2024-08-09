import 'package:formz/formz.dart';

enum EmailValidationError { invalid }

final class EmailValidator extends FormzInput<String, EmailValidationError> {
  const EmailValidator.pure([super.value = '']) : super.pure();
  const EmailValidator.dirty([super.value = '']) : super.dirty();

  static final _emailRegex =
      RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');

  @override
  EmailValidationError? validator(String? value) {
    return _emailRegex.hasMatch(value ?? '') ? null : EmailValidationError.invalid;
  }
}
