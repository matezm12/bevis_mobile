import 'package:bevis/utils/alert_constants.dart';
import 'package:bevis/widgets/buttons/rounded_corner_button_with_border.dart';
import 'package:bevis/widgets/dialogs/bevis_dialog.dart';
import 'package:flutter/material.dart';

class BevisChoiceDialog extends StatelessWidget {
  BevisChoiceDialog({
    @required this.title,
    @required this.onOkPressed,
    this.okButtonTitle = AlertConstants.OkButtonTitle,
    this.onCancelPressed,
    this.cancelButtonTitle = AlertConstants.CancelButtonTitle,
    this.dialogBody,
  }) : assert(title != null);

  final String title;
  final String okButtonTitle;
  final String cancelButtonTitle;
  final Widget dialogBody;
  final VoidCallback onOkPressed;
  final VoidCallback onCancelPressed;

  Widget build(BuildContext context) {
    return BevisDialog(
      title: title,
      dialogBody: dialogBody,
      actions: [
        RoundedCornerButtonWithBorder(
          title: okButtonTitle,
          onPressed: onOkPressed,
        ),
        RoundedCornerButtonWithBorder(
          title: cancelButtonTitle,
          onPressed: onCancelPressed ?? () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
