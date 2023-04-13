import 'package:bevis/widgets/dialogs/bevis_info_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showInfoDialog(BuildContext context, {String message, String title}) {
  showDialog(
    context: context,
    builder: (context) {
      return BevisInfoDialog(
        title: title,
        message: message,
      );
    },
  );
}
