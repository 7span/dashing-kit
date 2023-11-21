// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: join_return_with_assignment

import 'package:bloc/bloc.dart';
import 'package:bloc_boilerplate/app/helpers/extensions/extensions.dart';
import 'package:bloc_boilerplate/core/presentation/widgets/drop_down/model/dropdown_model.dart';
import 'package:equatable/equatable.dart';

part 'app_drop_down_state.dart';

class AppDropDownCubit extends Cubit<AppDropDownState> {
  AppDropDownCubit({required this.repository}) : super(AppDropDownInitial()) {
    getDropdownList();
  }
  final CustomDropdownRepository repository;

  List<AppDropdownModel> dropdownList = [];
  AppDropdownModel? selectedDropdownValue;

  Future<List> getDropdownList() async {
    await Future.delayed(2.seconds);
    if (dropdownList.isNotEmpty) {
      return dropdownList;
    }
    try {
      dropdownList = await repository.getDropdownList();
      selectedDropdownValue = dropdownList.first;
      emit(AppDropdownLoaded(dropdownList: dropdownList));
    } catch (e) {
      emit(AppDropDownError());
    }
    return dropdownList;
  }

  Future<void> onValueChanged(AppDropdownModel? value) async {
    try {
      if (value != null) {
        selectedDropdownValue = value;
        emit(AppDropDownOnChanged(value));
      }
    } catch (error) {
      emit(AppDropDownError());
    }
  }
}

// ignore: one_member_abstracts
abstract interface class CustomDropdownRepository {
  Future<List<AppDropdownModel>> getDropdownList();
}

class CityDropdown implements CustomDropdownRepository {
  @override
  Future<List<AppDropdownModel>> getDropdownList() async {
    return [
      AppDropdownModel(id: '1', name: 'Gujarat'),
      AppDropdownModel(id: '2', name: 'Asam'),
      AppDropdownModel(id: '3', name: 'Bihar'),
    ];
  }
}
