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
        apiScheme: 'http', apiHost: '35.171.166.110', apiPort: 9090),
    showDebugBanner: false,
  );
  AppConfig.setInstance(config);
  final initialScreen =
      InitialScreenFactory.createInitialScreen(isLoggedIn: token != '');

  runApp(BevisApp(
    initialPage: initialScreen,
  ));
}
