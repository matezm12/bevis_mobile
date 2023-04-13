import 'package:bevis/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RedBevisButton extends StatelessWidget {
  RedBevisButton({
    @required this.onPressed,
    @required this.title,
    this.isLoading = false,
    this.spinkitColor = Colors.white,
  });

  final VoidCallback onPressed;
  final String title;
  final bool isLoading;
  final Color spinkitColor;

  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor:
            MaterialStateProperty.all<Color>(ColorConstants.colorAppRed),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
          ),
        ),
      ),
      child: isLoading
          ? SpinKitCircle(
              color: spinkitColor,
              size: 30.0,
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
      onPressed: onPressed,
    );
  }
}
