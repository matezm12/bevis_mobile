library device_info_provider;

import 'package:flutter/foundation.dart';

part 'models/device_info.dart';

abstract class DeviceInfoProvider {
  Future<DeviceInfo> getDeviceInfo();
}