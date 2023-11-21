import 'package:fitness_app/app/helpers/extensions/extensions.dart';
import 'package:fitness_app/app/theme/app_theme.dart';
import 'package:fitness_app/app/theme/spacing.dart';
import 'package:fitness_app/core/presentation/widgets/drop_down/cubit/app_drop_down_cubit.dart';
import 'package:fitness_app/core/presentation/widgets/drop_down/model/dropdown_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    required this.onChanged,
    required this.dropdownRepository,
    super.key,
    this.iconData,
    this.labelText,
    this.hint,
    this.value,
    this.contentPadding,
    this.dropDownWidth,
    this.isExpanded = true,
    this.errorText,
    this.selectedItemBuilder,
    this.radius,
  });

  final IconData? iconData;
  final void Function(AppDropdownModel? value)? onChanged;
  final String? hint;
  final AppDropdownModel? value;
  final EdgeInsets? contentPadding;
  final double? dropDownWidth;
  final double? radius;
  final bool? isExpanded;
  final String? errorText;
  final String? labelText;
  final CustomDropdownRepository dropdownRepository;
  final DropdownButtonBuilder? selectedItemBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppDropDownCubit>(
      create: (context) => AppDropDownCubit(repository: dropdownRepository),
      child: BlocBuilder<AppDropDownCubit, AppDropDownState>(
        builder: (context, state) {
          switch (state) {
            case AppDropDownInitial():
              return const Center(child: CircularProgressIndicator());
            case AppDropDownError():
              return const Center(child: Text('Error'));
            case AppDropDownOnChanged():
            case AppDropdownLoaded():
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (labelText != null)
                    Text(
                      labelText!,
                      style: context.textTheme.labelMedium?.copyWith(
                        fontSize: 15,
                      ),
                    ),
                  VSpace.small(),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      borderRadius: BorderRadius.circular(radius ?? AppTheme.defaultRadius),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                    child: DropdownButton<AppDropdownModel>(
                      // style: context.textTheme.labelMedium?.copyWith(
                      //   fontWeight: AppFontWeight.medium,
                      //   fontSize: 16,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      hint: Text(
                        hint ?? '',
                        style: context.textTheme.labelMedium?.copyWith(
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      isExpanded: true,
                      value: context.read<AppDropDownCubit>().selectedDropdownValue,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: context.colorScheme.secondary,
                      ),
                      elevation: 16,
                      underline: Container(),
                      onChanged: (AppDropdownModel? item) {
                        // prevents keyboard from popping up after value is selected!
                        FocusScope.of(context).requestFocus(FocusNode());
                        context.read<AppDropDownCubit>().onValueChanged(item);
                        onChanged?.call(item);
                      },
                      items: context
                          .read<AppDropDownCubit>()
                          .dropdownList
                          .map(
                            (AppDropdownModel e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e.name,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  if (errorText?.isNotEmpty ?? false)
                    Container(
                      margin: const EdgeInsets.only(
                        top: 2,
                      ),
                      child: Text(
                        errorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                      ),
                    )
                  else
                    Container(),
                ],
              );
          }
        },
      ),
    );
  }
}
