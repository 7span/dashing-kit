import 'package:formz/formz.dart';

enum SixCharacterValidatorError { invalid }

final class LengthValidator extends FormzInput<String, SixCharacterValidatorError> {
  const LengthValidator({required this.length}) : super.pure('');

  const LengthValidator.pure(this.length, [super.value = '']) : super.pure();
  const LengthValidator.dirty(this.length, [super.value = '']) : super.dirty();

  final int length;
  @override
  SixCharacterValidatorError? validator(String? value) {
    return (value?.length ?? 0) >= length ? null : SixCharacterValidatorError.invalid;
  }
}
