import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

enum DialogAction { positive, negative }

typedef OnAction = void Function(DialogAction action);
typedef OnCancel = void Function();

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    required this.content,
    super.key,
    this.title,
    this.positiveText,
    this.negativeText,
    this.showAction = true,
    this.onAction,
    this.allowClosing = true,
    this.onCancel,
    this.isReverseButton = true,
    this.isEnabled = true,
    this.buttonColor,
  });

  final String? title;
  final String? content;
  final String? positiveText;
  final String? negativeText;
  final bool showAction;
  final bool isEnabled;
  final OnAction? onAction;
  final OnCancel? onCancel;
  final bool allowClosing;
  final bool isReverseButton;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      surfaceTintColor: context.colorScheme.white,
      backgroundColor: context.colorScheme.white,
      alignment: Alignment.center,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title:
          title != null
              ? AppText(
                textAlign: TextAlign.center,
                text: title ?? '',
                fontSize: 20,
                color: context.colorScheme.black,
              )
              : null,
      titleTextStyle: context.textTheme?.title.copyWith(
        color: context.colorScheme.black,
      ),
      actionsPadding: const EdgeInsets.only(bottom: 20),
      titlePadding:
          title != null
              ? const EdgeInsets.only(left: 10, right: 10, top: 20)
              : EdgeInsets.zero,
      content: AppText(
        text: content ?? '',
        fontSize: 14,
        color: context.colorScheme.grey700,
        textAlign: TextAlign.center,
      ),

      contentPadding: EdgeInsets.only(
        left: Insets.small12,
        right: Insets.small12,
        top: title != null ? Insets.small12 : Insets.small12,
        bottom: Insets.small12,
      ),
      actions: [_getActions(context)],
    );
  }

  Widget _getActions(BuildContext context) {
    final actions = <Widget>[];
    if (positiveText?.isEmpty ?? true) {
      throw ArgumentError("positiveText can't be null");
    }
    actions
      ..add(HSpace.small12())
      ..add(
        Expanded(
          child: AppButton(
            text: positiveText ?? '',
            textStyle: context.textTheme?.title.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.colorScheme.background,
            ),
            onPressed: () {
              onAction?.call(DialogAction.positive);
            },
          ),
        ),
      );
    if (negativeText?.isNotEmpty ?? false) {
      actions
        ..add(HSpace.small12())
        ..add(
          Expanded(
            child: AppButton(
              buttonType: ButtonType.outlined,
              textStyle: context.textTheme?.title.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.colorScheme.black,
              ),
              textColor: context.colorScheme.primary400,
              text: negativeText ?? '',
              onPressed: () {
                onAction?.call(DialogAction.negative);
              },
            ),
          ),
        )
        ..add(HSpace.small12());
    }

    if (positiveText?.isEmpty ?? true) {
      throw ArgumentError("positiveText can't be null");
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: isReverseButton ? actions.reversed.toList() : actions,
    );
  }
}
