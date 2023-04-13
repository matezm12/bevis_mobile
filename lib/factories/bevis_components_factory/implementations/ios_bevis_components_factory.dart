import 'package:bevis/factories/bevis_components_factory/bevis_components_factory.dart';
import 'package:bevis/factories/bevis_components_factory/implementations/base/mobile_bevis_components_factory.dart';
import 'package:bevis/helpers/device_info_provider/implementations/ios/ios_device_info_provider.dart';

class IosBevisComponentsFactory extends MobileBevisComponentsFactory {
  @override
  DeviceInfoProvider createDeviceInfoProvider() {
    return IosDeviceInfoProvider();
  }
}