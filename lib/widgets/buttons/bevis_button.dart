import 'package:bevis/utils/color_constants.dart';
import 'package:flutter/material.dart';

class BevisButton extends StatelessWidget {
  BevisButton({
    @required this.onPressed,
    @required this.child,
    this.padding,
  });

  final VoidCallback onPressed;
  final Widget child;
  final EdgeInsets padding;

  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(padding),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        elevation: MaterialStateProperty.all<double>(0),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(
              color: Colors.black12,
            ),
          ),
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return Color(0xFFE3E7E9);
            }

            return ColorConstants.textColor;
          },
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
