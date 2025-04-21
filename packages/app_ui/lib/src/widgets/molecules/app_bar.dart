import 'package:app_ui/src/theme/utils/utils.dart';
import 'package:app_ui/src/widgets/atoms/atoms.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleColor,
    this.actions,
    this.backgroundColor,
    this.leading,
    this.centerTitle,
    this.bottom,
    this.automaticallyImplyLeading = false,
    this.scrolledUnderElevation = 0,
  });

  final String? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double scrolledUnderElevation;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    final titleWidget = AppText.base(text: title, color: titleColor);

    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      bottom: bottom,
      title: titleWidget,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      titleSpacing: 0,
      scrolledUnderElevation: scrolledUnderElevation,
      backgroundColor: backgroundColor ?? context.colorScheme.white,
    );
  }

  /// Height is set to 64 constant because we've to match values same as the Figma
  @override
  Size get preferredSize => const Size.fromHeight(64);
}
