import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppProfileImage extends StatelessWidget {
  const AppProfileImage({required this.onTap, this.imageUrl, super.key});

  final VoidCallback onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Insets.large24),
      child: InkWell(
        onTap: onTap,
        child: AppNetworkImage(
          imageUrl: imageUrl,
          imageHeight: 40,
          imageWidth: 40,
          borderRadius: AppBorderRadius.medium16,
        ),
      ),
    );
  }
}
