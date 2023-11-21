import 'package:fitness_app/core/presentation/widgets/drop_down/app_dropdown.dart';
import 'package:fitness_app/core/presentation/widgets/drop_down/cubit/app_drop_down_cubit.dart';
import 'package:flutter/material.dart';

class TestDropdown extends StatefulWidget {
  const TestDropdown({super.key});

  @override
  State<TestDropdown> createState() => _TestDropdownState();
}

class _TestDropdownState extends State<TestDropdown> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomDropDown(
          onChanged: (value) {},
          dropdownRepository: CityDropdown(),
        ),
      ),
    );
  }
}
