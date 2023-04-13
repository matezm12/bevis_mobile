import 'package:bevis/helpers/device_info_provider/device_info_provider.dart';
import 'package:bevis/helpers/device_info_provider/implementations/android/mappers/device_info_mapper.dart';
import 'package:device_info/device_info.dart';

class AndroidDeviceInfoProvider implements DeviceInfoProvider {
  @override
  Future<DeviceInfo> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return mapAndroidDeviceInfo(androidInfo);
  }
}
