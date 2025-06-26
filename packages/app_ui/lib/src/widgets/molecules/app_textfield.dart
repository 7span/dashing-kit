import 'package:app_ui/src/theme/utils/utils.dart';
import 'package:app_ui/src/widgets/atoms/atoms.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    super.key,
    this.textInputAction = TextInputAction.next,
    this.showLabel = true,
    this.hintText,
    this.readOnly,
    this.keyboardType,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.minLines,
    this.errorText,
    this.backgroundColor,
    this.contentPadding,
    this.autofillHints,
    this.hintTextBelowTextField,
  }) : isPasswordField = false,
       isObscureText = false;

  const AppTextField.password({
    required this.label,
    super.key,
    this.textInputAction = TextInputAction.next,
    this.showLabel = true,
    this.hintText,
    this.keyboardType,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.errorText,
    this.backgroundColor,
    this.minLines,
    this.focusNode,
    this.readOnly,
    this.autofillHints,
    this.hintTextBelowTextField,
    this.contentPadding,
  }) : isPasswordField = true,
       isObscureText = true;

  final String label;
  final String? initialValue;
  final String? hintText;
  final bool? readOnly;
  final String? errorText;
  final String? hintTextBelowTextField;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String text)? onChanged;
  final Color? backgroundColor;
  final bool isObscureText;
  final bool isPasswordField;
  final bool showLabel;
  final List<String>? autofillHints;
  final FocusNode? focusNode;
  final int? minLines;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool isObscureText = false;

  @override
  void initState() {
    super.initState();
    isObscureText = widget.isObscureText;
  }

  void toggleObscureText() {
    setState(() {
      isObscureText = !isObscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[AppText.xsSemiBold(text: widget.label), VSpace.xsmall8()],
        TextFormField(
          initialValue: widget.initialValue,
          cursorColor: context.colorScheme.black,
          style: context.textTheme?.paragraph1.copyWith(color: context.colorScheme.black),
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          obscureText: isObscureText,
          onChanged: widget.onChanged,
          readOnly: widget.readOnly ?? false,
          autofillHints: widget.autofillHints,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.backgroundColor ?? context.colorScheme.grey100,
            hintText: widget.hintText,
            contentPadding: widget.contentPadding ?? const EdgeInsets.only(left: Insets.small12),
            errorMaxLines: 2,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Insets.xsmall8),
              borderSide: BorderSide(color: context.colorScheme.primary400),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(Insets.xsmall8), borderSide: BorderSide.none),
            errorText: widget.errorText,
            suffixIcon:
                widget.isPasswordField
                    ? IconButton(
                      splashColor: context.colorScheme.primary50,
                      onPressed: toggleObscureText,
                      icon: Icon(isObscureText ? Icons.visibility_off : Icons.visibility, color: context.colorScheme.grey700),
                    )
                    : null,
          ),
          minLines: widget.minLines,
          maxLines: widget.minLines ?? 0 + 1,
        ),
        if (widget.hintTextBelowTextField != null) ...[VSpace.xsmall8(), AppText.xsRegular(text: widget.hintTextBelowTextField)],
      ],
    );
  }
}
