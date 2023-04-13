import 'package:bevis/pages/bevis_app/app.dart';
import 'package:bevis/utils/helpers/factories/initial_screen_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_repository/network_repositories/network_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_config.dart';

bool isLogIn = false;
String token = "";
String email = "";
String password = "";
bool isEnableBiometri = false;
String socialType = "";
bool isGuestLogin = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var config = AppConfig(
    networkConfig: NetworkConfig(
      apiScheme: 'https',
      apiHost: 'api.bevis.sg',
      apiPort: 443,
    ),
    showDebugBanner: true,
  );

  // var config = AppConfig(
  //   networkConfig: NetworkConfig(
  //     apiScheme: 'http',
  //     apiHost:
  //         'bevisbackend-env-dev4.eba-i4vgyptx.us-east-1.elasticbeanstalk.com',
  //   ),
  //   showDebugBanner: true,
  // );

  AppConfig.setInstance(config);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  isEnableBiometri = sharedPreferences.getBool("bio") ?? false;
  email = sharedPreferences.getString("email") ?? "";
  password = sharedPreferences.getString("pass") ?? "";
  socialType = sharedPreferences.getString("social") ?? "";
  isLogIn = sharedPreferences.getBool("login") ?? false;
  token = sharedPreferences.getString("token") ?? "";
  final initialScreen = InitialScreenFactory.createInitialScreen(isLoggedIn: token != '');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    if (kIsWeb) {
      // initialiaze the facebook javascript SDK
      FacebookAuth.i.webInitialize(
        appId: "673802500095178", //<-- YOUR APP_ID
        cookie: true,
        xfbml: true,
        version: "v9.0",
      );
    }

    runApp(BevisApp(
      initialPage: initialScreen,
    ));
  });
}