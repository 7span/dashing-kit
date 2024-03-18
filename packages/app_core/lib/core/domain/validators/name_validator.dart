import 'package:formz/formz.dart';

enum NameValidationError { invalid }

final class NameValidator extends FormzInput<String, NameValidationError> {
  const NameValidator.pure([super.value = '']) : super.pure();
  const NameValidator.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String? value) {
    return (value?.length ?? 0) >= 3 ? null : NameValidationError.invalid;
  }
}
