import 'package:bevis/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomMenuElement extends StatelessWidget {
  BottomMenuElement({
    @required this.title,
    @required this.subtitle,
    @required this.menuButton,
  });

  final String title;
  final String subtitle;
  final Widget menuButton;

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: ColorConstants.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
          Text(
            subtitle,
            style: TextStyle(color: ColorConstants.textColor, fontSize: 12),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(6)),
            child: menuButton,
          )
        ],
      ),
    );
  }
}
