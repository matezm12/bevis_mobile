import 'package:bevis/utils/alert_constants.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/dialogs/bevis_choice_dialog.dart';
import 'package:flutter/material.dart';

class BevisDialogWithDescription extends StatelessWidget {
  BevisDialogWithDescription({
    @required this.title,
    @required this.description,
    @required this.onOkPressed,
    this.onCancelPressed,
    this.okButtonTitle = AlertConstants.OkButtonTitle,
    this.cancelButtonTitle = AlertConstants.CancelButtonTitle,
  }) : assert(description != null);

  final String title;
  final String description;
  final String okButtonTitle;
  final String cancelButtonTitle;
  final VoidCallback onOkPressed;
  final VoidCallback onCancelPressed;

  Widget build(BuildContext context) {
    return BevisChoiceDialog(
      title: title,
      okButtonTitle: okButtonTitle,
      onOkPressed: onOkPressed,
      onCancelPressed: onCancelPressed,
      dialogBody: Text(
        description,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 12,
          color: ColorConstants.textColor,
        ),
      ),
    );
  }
}
