import 'package:bevis/helpers/device_info_provider/device_info_provider.dart';
import 'package:bevis/helpers/device_info_provider/implementations/ios/mappers/device_info_mapper.dart';
import 'package:device_info/device_info.dart';

class IosDeviceInfoProvider implements DeviceInfoProvider {
  @override
  Future<DeviceInfo> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;
    return mapIosDeviceInfo(iosInfo);
  }
}