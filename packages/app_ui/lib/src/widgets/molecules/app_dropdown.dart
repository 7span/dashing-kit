// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app_ui/app_ui.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// This widget is used to implement single, multiple or dependent dropdown throuhghout the whole
/// App. This widget includes a parameters called [items] in which we have to pass the custom model.
/// The custom model is located at the end of this widget in case anyone wants to add any parameters to it
class AppDropDownWidget extends StatelessWidget {
  const AppDropDownWidget({
    required this.label,
    required this.items,
    this.validator,
    this.onChanged,
    this.backgroundColor,
    this.initialItem,
    this.borderRadius,
    super.key,
  });
  final String label;
  final List<AppDropDownModel> items;
  final String? Function(AppDropDownModel?)? validator;
  final dynamic Function(AppDropDownModel)? onChanged;
  final AppDropDownModel? initialItem;
  final Color? backgroundColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeleton.shade(child: AppText.xsSemiBold(text: label)),
        VSpace.xsmall8(),
        CustomDropdown<AppDropDownModel>(
          closedHeaderPadding: const EdgeInsets.all(Insets.small12),
          validator: validator,
          initialItem: initialItem,
          onChanged: onChanged,
          items: items,
          excludeSelected: false,
          decoration: CustomDropdownDecoration(
            closedFillColor: backgroundColor ?? context.colorScheme.grey100,
            expandedFillColor: backgroundColor ?? context.colorScheme.grey50,
            closedBorderRadius: BorderRadius.circular(borderRadius ?? AppBorderRadius.xsmall4),
            expandedBorderRadius: BorderRadius.circular(borderRadius ?? AppBorderRadius.xsmall4),
            closedSuffixIcon: Skeleton.ignore(
              child: Icon(
                Icons.keyboard_arrow_down,
                color: context.colorScheme.grey400,
              ),
            ),
          ),
          hintBuilder: (context, hint) {
            return AppText.s(
              text: 'Select',
              color: context.colorScheme.grey400,
            );
          },
          headerBuilder: (context, selectedItem) {
            return AppText.s(
              text: selectedItem.name,
              color: selectedItem.color,
            );
          },
          listItemBuilder: (context, item, isSelected, onItemSelect) {
            return AppText.s(
              text: item.name,
              color: item.color,
            );
          },
        ),
      ],
    );
  }
}

/// To Test the Dropdown, replace this _list
// ignore: unused_element
final List<AppDropDownModel> _list = [
  const AppDropDownModel(color: Colors.green, name: 'New Lead'),
  const AppDropDownModel(color: Colors.blue, name: 'UI/UX Designer'),
];

class AppDropDownModel extends Equatable {
  const AppDropDownModel({
    required this.name,
    this.color = Colors.black,
    this.id,
    this.data,
    this.isSelected = false,
  });
  final int? id;
  final Object? data;
  final String name;
  final bool isSelected;
  final Color color;

  @override
  List<Object?> get props {
    return [
      id,
      data,
      name,
      isSelected,
      color,
    ];
  }

  @override
  bool get stringify => true;
}
