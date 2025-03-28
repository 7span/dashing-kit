import 'package:formz/formz.dart';

/// Use case :  final RequiredFieldValidator<DateTime?> dateValue;
/// For more understanding refer this [blog](https://medium.com/@avniprajapati21101/ultimate-guide-on-form-validation-using-formz-in-flutter-part-1-5a938385b509)

/// Generic Validator Error Enum
enum RequiredFieldValidatorError { required }

/// Generic Validator
class RequiredFieldValidator<T>
    extends FormzInput<T?, RequiredFieldValidatorError> {
  const RequiredFieldValidator.pure() : super.pure(null);

  const RequiredFieldValidator.dirty([super.value]) : super.dirty();

  @override
  RequiredFieldValidatorError? validator(T? value) {
    if ((value != null) && (value is String)) {
      return value.trim().isEmpty ? RequiredFieldValidatorError.required : null;
    } else if (value != null) {
      return null;
    } else {
      return RequiredFieldValidatorError.required;
    }
  }
}
