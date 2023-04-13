import 'package:bevis/widgets/buttons/bevis_button.dart';
import 'package:flutter/material.dart';

class RoundedCornerButtonWithBorder extends StatelessWidget {
  RoundedCornerButtonWithBorder({
    @required this.onPressed,
    @required this.title,
  }) : assert(title != null);

  final VoidCallback onPressed;
  final String title;

  Widget build(BuildContext context) {
    return BevisButton(
      onPressed: onPressed,
      child: Text(
        title,
        // style: TextStyle(
        //   fontSize: 18,
        //   fontWeight: FontWeight.w400,
        // ),
      ),
    );
  }
}
