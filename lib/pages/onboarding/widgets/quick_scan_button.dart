import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/buttons/bevis_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class QuickScanButton extends StatelessWidget {
  QuickScanButton({@required this.onPressed});

  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return BevisButton(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 0,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/tutorial/scan_icon.svg',
            color: ColorConstants.textColor,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Just a Quick Scan',
            style: TextStyle(
              color: ColorConstants.textColor,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
