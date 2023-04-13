import 'dart:async';

import 'package:bevis/app/app_config.dart';
import 'package:bevis/main.dart';
import 'package:bevis/pages/bevis_app/app.dart';
import 'package:bevis/utils/helpers/factories/initial_screen_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_repository/network_repositories/network_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var config = AppConfig(
    networkConfig: NetworkConfig(
      apiScheme: 'https',
      apiHost: 'api.bevis.sg',
      apiPort: 443,
    ),
    showDebugBanner: false,
  );

  AppConfig.setInstance(config);

  final initialScreen = InitialScreenFactory.createInitialScreen(isLoggedIn: token != '');

  runZonedGuarded(() {
    runApp(BevisApp(
      initialPage: initialScreen,
    ));
  }, (error, stack) {});
}
