import 'package:flutter_repository/network_repositories/network_config.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class AppConfig {
  AppConfig({
    @required this.showDebugBanner,
    @required this.networkConfig,
  });

  static AppConfig _config;

  static void setInstance(AppConfig config) {
    _config = config;
  }

  static AppConfig getInstance() {
    return _config;
  }

  final bool showDebugBanner;
  final NetworkConfig networkConfig;
}
