import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    this.buttonTitle,
    this.onTap,
    this.hPadding = 0,
    super.key,
    this.title,
    this.documentationLink,
    this.subTitle,
    this.icon,
    this.showButton = true,
    this.showIcon = true,
  });

  final String? title;
  final String? documentationLink;
  final VoidCallback? onTap;
  final String? buttonTitle;
  final String? subTitle;
  final double hPadding;
  final bool showButton;
  final bool showIcon;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? Assets.images.emptyBox.svg(),
            if (title != null)
              AppText.xsSemiBold(
                text: title,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            VSpace.xxsmall4(),
            if (subTitle != null)
              SizedBox(
                width: 300,
                child: AppText.xsSemiBold(
                  text: subTitle,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                ),
              ),
            if (showButton) ...[
              VSpace.medium16(),
              AppButton(
                isExpanded: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: Insets.xlarge32,
                ),
                icon:
                    showIcon
                        ? Icon(Icons.add, color: context.colorScheme.white)
                        : const SizedBox(),
                text: buttonTitle,
                onPressed: onTap,
              ),
            ],
            if (documentationLink != null) ...[
              VSpace.xsmall8(),
              AnimatedGestureDetector(
                onTap: () async {
                  await launchUrl(Uri.parse(documentationLink!));
                },
                child: AppText.xsSemiBold(
                  text: 'Know more',
                  color: context.colorScheme.primary50,
                  isUnderLine: true,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
