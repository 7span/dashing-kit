import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(
  name: 'Interactive Consent',
  type: UserConsentWidget,
)
Widget userConsentInteractiveUseCase(BuildContext context) {
  bool isChecked = false;

  final messageBeforeLinks = context.knobs.string(
    label: 'Message Before Links',
    initialValue: 'I agree to the ',
  );

  final termsText = context.knobs.string(
    label: 'Terms Text',
    initialValue: 'Terms & Conditions',
  );

  final andText = context.knobs.string(
    label: 'And Text',
    initialValue: 'and',
  );

  final privacyText = context.knobs.string(
    label: 'Privacy Text',
    initialValue: 'Privacy Policy',
  );

  return AppScaffold(
    backgroundColor: context.colorScheme.grey300,
    body: StatefulBuilder(
      builder: (context, setState) {
        return Center(
          child: UserConsentWidget(
            value: isChecked,
            onCheckBoxValueChanged:
                (newVal) =>
                    setState(() => isChecked = newVal ?? false),
            onTermsAndConditionTap: () => debugPrint('Terms tapped'),
            onPrivacyPolicyTap: () => debugPrint('Privacy tapped'),
            messageBeforeLinks: messageBeforeLinks,
            andText: andText,
            termsText: termsText,
            privacyText: privacyText,
          ),
        );
      },
    ),
  );
}
