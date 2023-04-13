import 'package:bevis/utils/alert_constants.dart';
import 'package:bevis/widgets/buttons/rounded_corner_button_with_border.dart';
import 'package:bevis/widgets/dialogs/bevis_dialog.dart';
import 'package:flutter/material.dart';

class BevisInfoDialog extends StatelessWidget {
  BevisInfoDialog({
    @required this.title,
    this.message,
    this.onOkPressed,
  });

  final String title;
  final String message;
  final VoidCallback onOkPressed;

  Widget build(BuildContext context) {
    return BevisDialog(
      title: title,
      dialogBody: message != null
          ? Text(
              message,
              style: Theme.of(context).dialogTheme.contentTextStyle,
            )
          : Container(),
      actions: [
        RoundedCornerButtonWithBorder(
          title: AlertConstants.OkButtonTitle,
          onPressed: onOkPressed ?? () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
