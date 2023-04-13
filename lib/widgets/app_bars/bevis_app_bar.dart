import 'package:flutter/material.dart';

class BevisAppBar extends PreferredSize {
  BevisAppBar({
    @required this.title,
    @required this.subtitle,
    this.leading,
    this.height = 64,
    this.actions,
  });

  final double height;
  final String title;
  final String subtitle;
  final List<Widget> actions;
  final Widget leading;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final titleWidget = Text(
      title,
    );
    final subtitleWidget = subtitle != null
        ? Text(
            subtitle ?? '',
            style: Theme.of(context).primaryTextTheme.overline,
          )
        : null;

    final appBarTitleWidgets = [titleWidget, subtitleWidget];
    appBarTitleWidgets.removeWhere((element) => element == null);

    return AppBar(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: appBarTitleWidgets,
      ),
      actions: actions,
      centerTitle: true,
      leading: leading,
    );
  }
}
