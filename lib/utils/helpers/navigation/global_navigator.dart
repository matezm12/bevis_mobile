import 'dart:io';

import 'package:bevis/main.dart';
import 'package:bevis/pages/login/login_page.dart';
import 'package:bevis/utils/notifications/notification_center.dart';
import 'package:bevis/widgets/dialogs/bevis_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:bevis/utils/notifications/notification_events.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalNavigator {
  static final GlobalNavigator _singleton = new GlobalNavigator._internal();
  final navigatorKey = new GlobalKey<NavigatorState>();

  static GlobalNavigator shared() {
    return _singleton;
  }

  GlobalNavigator._internal() {
    NotificationCenter.shared()
        .eventBus
        .on<GlobalEvent>()
        .listen((event) async {
      if (event is AppUpgradeRequired) {
        showDialog(
          context: navigatorKey.currentState.overlay.context,
          barrierDismissible: false,
          builder: (context) {
            return BevisInfoDialog(
              title: 'App upgrage required',
              message: 'Please upgrade your app to the newest version',
              onOkPressed: () async {
                navigatorKey.currentState.pop();
                final url = Platform.isIOS
                    ? 'https://itunes.apple.com/app/id1473827189'
                    : 'https://play.google.com/store/apps/details?id=com.rearden_metals.bevis&hl=en';
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
            );
          },
        );
      }
      if (event is SessionExpired) {
        isLogIn = false;
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setBool("login", false);

        Navigator.pushReplacement(
            navigatorKey.currentState.overlay.context,
            PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                duration: Duration(milliseconds: 300),
                alignment: Alignment.center,
                child: LoginPage()));
        showDialog(
          context: navigatorKey.currentState.overlay.context,
          builder: (context) {
            return BevisInfoDialog(
              title: 'Session Expired',
              message: 'Please log in again!',
            );
          },
        );
      }
    });
  }

  factory GlobalNavigator() {
    return _singleton;
  }
}
