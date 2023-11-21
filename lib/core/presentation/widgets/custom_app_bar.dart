import 'package:flutter/material.dart';

import 'package:bloc_boilerplate/app/helpers/extensions/extensions.dart';
import 'package:bloc_boilerplate/app/theme/app_text_style.dart';
import 'package:bloc_boilerplate/app/theme/spacing.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleColor,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.leading,
    this.automaticallyImplyLeading = false,
    this.scrolledUnderElevation = 0,
    this.showTitle = true,
  });

  final String? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double scrolledUnderElevation;
  final bool showTitle;

  @override
  Widget build(BuildContext context) => AppBar(
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: showTitle
            ? Padding(
                padding: const EdgeInsets.only(left: Insets.xsmall),
                child: Text(
                  title ?? 'Boilerplate',
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: titleColor ?? context.colorScheme.primary,
                    fontWeight: AppFontWeight.medium,
                  ),
                ),
              )
            : null,
        actions: actions,
        scrolledUnderElevation: scrolledUnderElevation,
        backgroundColor: backgroundColor ?? context.colorScheme.background,
        centerTitle: centerTitle,
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
