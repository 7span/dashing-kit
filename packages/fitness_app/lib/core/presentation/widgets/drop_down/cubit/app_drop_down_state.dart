// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_drop_down_cubit.dart';

sealed class AppDropDownState extends Equatable {
  const AppDropDownState();

  @override
  List<Object> get props => [];
}

class AppDropDownInitial extends AppDropDownState {}

class AppDropDownError extends AppDropDownState {}

class AppDropDownOnChanged extends AppDropDownState {
  const AppDropDownOnChanged(this.value);

  final AppDropdownModel value;
}

class AppDropdownLoaded extends AppDropDownState {
  final List<AppDropdownModel> dropdownList;
  const AppDropdownLoaded({required this.dropdownList});
}
