import 'package:bevis/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectFileOption extends StatelessWidget {
  const SelectFileOption({
    @required this.icon,
    @required this.title,
    this.onPressed,
  });

  final Widget icon;
  final String title;
  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 104,
              height: 104,
              padding: const EdgeInsets.all(28),
              child: Container(
                child: icon,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: ColorConstants.borderColor,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(3),
              ),
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  color: ColorConstants.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
