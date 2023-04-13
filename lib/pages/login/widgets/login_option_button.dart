import 'package:bevis/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginOptionButton extends StatelessWidget {
  LoginOptionButton({
    @required this.title,
    @required this.isLoading,
    @required this.onPressed,
    this.spinkitColor = Colors.white,
    this.titleTextColor = ColorConstants.buttonSignUpBorder,
    this.backgroundColor = Colors.white,
    this.borderColor = ColorConstants.buttonSignUpBorder,
  });

  final String title;
  final Color backgroundColor;
  final Color borderColor;
  final Color titleTextColor;
  final bool isLoading;
  final Color spinkitColor;
  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(
              color: borderColor,
            ),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(6),
          bottom: ScreenUtil().setHeight(6),
        ),
        width: ScreenUtil().setWidth(221),
        alignment: Alignment.center,
        child: isLoading
            ? SpinKitCircle(
                color: spinkitColor,
                size: 30.0,
              )
            : Text(
                title,
                style: TextStyle(
                  color: titleTextColor,
                  fontSize: ScreenUtil().setHeight(16),
                ),
              ),
      ),
    );
  }
}
