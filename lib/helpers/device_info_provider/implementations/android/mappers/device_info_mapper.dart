import 'package:bevis/helpers/device_info_provider/device_info_provider.dart';
import 'package:device_info/device_info.dart';

DeviceInfo mapAndroidDeviceInfo(AndroidDeviceInfo androidInfo) {
  return DeviceInfo(
    brand: androidInfo.brand,
    deviceId: androidInfo.androidId,
    model: androidInfo.model,
  );
}
