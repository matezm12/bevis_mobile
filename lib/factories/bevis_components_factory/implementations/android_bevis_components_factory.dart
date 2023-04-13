import 'package:bevis/factories/bevis_components_factory/bevis_components_factory.dart';
import 'package:bevis/factories/bevis_components_factory/implementations/base/mobile_bevis_components_factory.dart';
import 'package:bevis/helpers/device_info_provider/implementations/android/android_device_info_provider.dart';

class AndroidBevisComponentsFactory extends MobileBevisComponentsFactory {
  @override
  DeviceInfoProvider createDeviceInfoProvider() {
    return AndroidDeviceInfoProvider();
  }
}