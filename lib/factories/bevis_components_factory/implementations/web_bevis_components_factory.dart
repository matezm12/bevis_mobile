import 'package:bevis/factories/bevis_components_factory/bevis_components_factory.dart';
import 'package:bevis/factories/bevis_components_factory/implementations/base/platform_bevis_components_factory.dart';
import 'package:bevis/helpers/geocoder/implementations/web_geocoder/web_geocoder.dart';
import 'package:bevis/helpers/media_picker/implementations/file_picker_media_picker.dart';
import 'package:bevis/helpers/media_picker/media_picker.dart';
import 'package:bevis/helpers/operating_system_info_provider/implementations/web_operating_system_info_provider.dart';

class WebBevisComponentsFactory extends PlatformBevisComponentsFactory {
  @override
  MediaPicker createMediaPicker() {
    return FilePickerMediaPicker(createFilePicker());
  }

  @override
  DeviceInfoProvider createDeviceInfoProvider() {
    return null;
  }

  @override
  Geocoder createGeocoder() {
    return WebGeocoder();
  }

  @override
  OperatingSystemInfoProvider createOperatingSystemInfoProvider() {
    return WebOperatingSystemInfoProvider();
  }

  @override
  AssetFileEncoder createAssetFileEncoder() {
    return null;
  }
}
