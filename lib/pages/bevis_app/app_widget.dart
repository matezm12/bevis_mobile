import 'package:bevis/app/app_config.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/utils/helpers/navigation/global_navigator.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppWidget extends StatelessWidget {
  AppWidget({@required this.initialPage});

  final Widget initialPage;

  @override
  Widget build(BuildContext context) {
    final AppConfig config = AppConfig.getInstance();

    return MaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        fontFamily: 'segoeui',
        primaryColor: Colors.white,
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: Color(0xFF5C6E76),
            fontSize: 16,
          ),
          overline: TextStyle(
            color: Color(0xFF5C6E76),
          ),
          bodyText2: TextStyle(
            color: Color(0XFF808F97),
          ),
        ),
        primaryIconTheme: IconThemeData(
          color: Color(0xFF5C6E76),
        ),
        accentColor: Colors.black,
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          titleTextStyle: TextStyle(
            fontSize: 14,
            color: ColorConstants.textColor,
          ),
          contentTextStyle: TextStyle(
            fontSize: 12,
            color: Color(0xFF808F97),
          ),
        ),
      ),
      debugShowCheckedModeBanner: config.showDebugBanner,
      navigatorKey: GlobalNavigator.shared().navigatorKey,
      home: Builder(
        builder: (context) {
          ScreenUtil.init(
            BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height),
            designSize: Size(375, 723),
          );

          return initialPage;
        },
      ),
    );
  }
}
