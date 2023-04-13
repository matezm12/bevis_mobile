import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomMenuButton extends StatelessWidget {
  BottomMenuButton({
    @required this.onPressed,
    @required this.icon,
    @required this.backgroundColor,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final Color backgroundColor;

  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          backgroundColor,
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      ),
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(127),
        height: ScreenUtil().setHeight(34),
        child: icon,
      ),
    );
  }
}
