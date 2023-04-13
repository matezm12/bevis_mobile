import 'package:bevis/helpers/device_info_provider/device_info_provider.dart';
import 'package:device_info/device_info.dart';

DeviceInfo mapIosDeviceInfo(IosDeviceInfo iosDeviceInfo) {
  return DeviceInfo(
    brand: 'Apple',
    model: iosDeviceInfo.localizedModel,
    deviceId: iosDeviceInfo.identifierForVendor,
  );
}
