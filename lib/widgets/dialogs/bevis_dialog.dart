import 'package:flutter/material.dart';

class BevisDialog extends StatelessWidget {
  BevisDialog({
    this.title,
    this.actions,
    this.dialogBody,
  });

  final String title;
  final Widget dialogBody;
  final List<Widget> actions;

  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      insetPadding: EdgeInsets.all(24),
      title: title != null
          ? Text(
              title,
              style: Theme.of(context).dialogTheme.titleTextStyle,
            )
          : null,
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          dialogBody ?? Container(),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: actions.length > 1
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: actions,
          )
        ],
      ),
    );
  }
}
