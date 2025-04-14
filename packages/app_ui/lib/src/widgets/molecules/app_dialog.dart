import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    required this.title,
    required this.rightText,
    required this.onRightOptionTap,
    this.content,
    this.onLeftOptionTap,
    this.leftText,
    super.key,
  });

  final String? title;
  final String? content;
  final String? leftText;
  final String rightText;
  final VoidCallback? onLeftOptionTap;
  final VoidCallback onRightOptionTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      surfaceTintColor: context.colorScheme.white,
      backgroundColor: context.colorScheme.white,
      alignment: Alignment.center,
      insetPadding: const EdgeInsets.all(Insets.medium16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.small8)),
      ),
      title:
          title != null
              ? AppText.XL(
                text: title ?? '',
                color: context.colorScheme.black,
                textAlign: TextAlign.center,
              )
              : null,
      titleTextStyle: context.textTheme?.title.copyWith(
        color: context.colorScheme.black,
      ),
      actionsPadding: const EdgeInsets.only(bottom: Insets.medium20),
      titlePadding:
          title != null
              ? const EdgeInsets.only(
                left: Insets.xsmall8,
                right: Insets.xsmall8,
                top: Insets.medium20,
              )
              : EdgeInsets.zero,
      content: AppText.s(
        text: content ?? '',
        color: context.colorScheme.grey700,
        textAlign: TextAlign.center,
        maxLines: 4,
      ),

      contentPadding: EdgeInsets.only(
        left: Insets.small12,
        right: Insets.small12,
        top: title != null ? Insets.small12 : Insets.small12,
        bottom: Insets.small12,
      ),
      actions: [
        _ActionWidget(
          rightText: rightText,
          onRightOptionTap: onRightOptionTap,
          leftText: leftText,
          onLeftOptionTap: onLeftOptionTap,
        ),
      ],
    );
  }
}

class _ActionWidget extends StatelessWidget {
  const _ActionWidget({
    required this.rightText,
    required this.onRightOptionTap,
    this.leftText,
    this.onLeftOptionTap,
  });

  final String rightText;
  final VoidCallback onRightOptionTap;
  final String? leftText;
  final VoidCallback? onLeftOptionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Insets.small12,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        VSpace.small12(),
        Expanded(
          child: AppButton(
            text: rightText,
            textStyle: context.textTheme?.title.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.colorScheme.background,
            ),
            onPressed: onRightOptionTap,
          ),
        ),
        if (leftText?.isNotEmpty ?? false)
          Expanded(
            child: AppButton(
              buttonType: ButtonType.outlined,
              textStyle: context.textTheme?.title.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.colorScheme.black,
              ),
              textColor: context.colorScheme.primary400,
              text: leftText ?? '',
              onPressed: onLeftOptionTap,
            ),
          ),
        VSpace.small12(),
      ],
    );
  }
}
