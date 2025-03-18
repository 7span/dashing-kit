import 'package:app_translations/app_translations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Material(
        color: context.colorScheme.black.withAlpha(60),
        child: Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(Insets.medium20),
            decoration: BoxDecoration(
              color: context.colorScheme.white,
              borderRadius: BorderRadius.circular(Insets.small12),
            ),
            child: Container(
              padding: const EdgeInsets.all(Insets.large24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.noInternetConnection.svg(
                    width: 175,
                    height: 175,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.primary600,
                      BlendMode.srcIn,
                    ),
                  ),
                  VSpace.xsmall8(),
                  AppText.xsSemiBold(
                    text: context.t.no_internet_connection,
                    fontSize: 20,
                  ),
                  VSpace.xsmall8(),
                  AppText.subTitle10(
                    text: context.t.no_internet_connection_text,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
