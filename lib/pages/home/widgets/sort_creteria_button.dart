import 'package:bevis/utils/color_constants.dart';
import 'package:flutter/material.dart';

class SortCriteriaButton extends StatelessWidget {
  SortCriteriaButton({
    @required this.isActive,
    @required this.title,
    @required this.onPressed,
  });

  final bool isActive;
  final String title;
  final VoidCallback onPressed;

  static const Color _activeColor = ColorConstants.textColor;
  static const Color _inactiveColor = ColorConstants.fadeTextColor;

  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? _activeColor : _inactiveColor,
          ),
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 8),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            isActive ? _activeColor : _inactiveColor,
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(
                color: isActive ? _activeColor : _inactiveColor,
              ),
            ),
          ),
        ),
      ),
      // child: RaisedButton(
      //   padding: EdgeInsets.only(left: 0, right: 0),
      //   onPressed: onPressed,
      //   color: Colors.white,
      //   disabledColor: Colors.white,
      //   shape:

      // ),
    );
  }
}
