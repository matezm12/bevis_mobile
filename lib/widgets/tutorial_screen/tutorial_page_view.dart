import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TutorialPageView extends StatelessWidget {
  final Widget image;
  final String text;
  final Widget customContent;
  final String background;

  TutorialPageView(
      {this.image, this.text = '', this.customContent, this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image:
              DecorationImage(fit: BoxFit.fill, image: AssetImage(background))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(114)),
              child: image),

          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(50)),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: ScreenUtil().setHeight(16), color: Colors.white),
            ),
          ),
//          customContent ?? Text("sss"),
        ],
      ),
    );
  }
}
