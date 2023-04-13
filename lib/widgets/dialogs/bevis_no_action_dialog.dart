import 'package:bevis/widgets/activity_indicators/bevis_activity_indicator.dart';
import 'package:bevis/widgets/dialogs/bevis_dialog.dart';
import 'package:flutter/material.dart';

class BevisNoActionDialog extends StatelessWidget {
  BevisNoActionDialog({@required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return BevisDialog(
      dialogBody: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: BevisActivityIndicator(),
          ),
          Text(
            message,
            style: Theme.of(context).dialogTheme.contentTextStyle,
          ),
        ],
      ),
      actions: [],
    );
  }
}
