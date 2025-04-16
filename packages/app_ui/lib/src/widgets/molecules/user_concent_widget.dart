import 'package:app_ui/app_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UserConsentWidget extends StatelessWidget {
  const UserConsentWidget({
    required this.onTermsAndConditionTap,
    required this.onPrivacyPolicyTap,
    required this.onCheckBoxValueChanged,
    required this.value,
    required this.messageBeforeLinks,
    required this.andText,
    required this.termsText,
    required this.privacyText,
    super.key,
  });

  final GestureTapCallback onTermsAndConditionTap;
  final GestureTapCallback onPrivacyPolicyTap;
  final ValueChanged<bool?>? onCheckBoxValueChanged;
  final bool value;

  final String messageBeforeLinks;
  final String andText;
  final String termsText;
  final String privacyText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCheckBoxValueChanged?.call(!value),
      child: Row(
        children: [
          Checkbox(
            visualDensity: VisualDensity.compact,
            value: value,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            tristate: true,
            onChanged: onCheckBoxValueChanged,
          ),
          HSpace.xxsmall4(),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: messageBeforeLinks, style: context.textTheme?.S),
                  TextSpan(
                    text: termsText,
                    recognizer: TapGestureRecognizer()..onTap = onTermsAndConditionTap,
                    style: context.textTheme?.S.copyWith(color: context.colorScheme.primary500),
                  ),
                  TextSpan(text: ' $andText ', style: context.textTheme?.S),
                  TextSpan(
                    text: privacyText,
                    recognizer: TapGestureRecognizer()..onTap = onPrivacyPolicyTap,
                    style: context.textTheme?.S.copyWith(color: context.colorScheme.primary500),
                  ),
                  TextSpan(
                    text: '.', // Optional ending period
                    style: context.textTheme?.S,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
