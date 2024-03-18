import 'package:app_ui/app_ui.dart';
import 'package:formz/formz.dart';

enum DropdownValidationError { invalid }

final class DropdownValidator extends FormzInput<AppDropDownModel, DropdownValidationError> {
  const DropdownValidator.pure([super.value = const AppDropDownModel(name: '')]) : super.pure();
  const DropdownValidator.dirty([super.value = const AppDropDownModel(name: '')]) : super.dirty();

  @override
  DropdownValidationError? validator(AppDropDownModel? value) {
    return value?.id != null ? null : DropdownValidationError.invalid;
  }
}
