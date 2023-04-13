import 'package:bevis/factories/bevis_components_factory/implementations/base/platform_bevis_components_factory.dart';
import 'package:bevis/helpers/asset_file_encoder/asset_file_encoder.dart';
import 'package:bevis/helpers/asset_file_encoder/implementations/zip_asset_file_encoder.dart';
import 'package:bevis/helpers/geocoder/geocoder.dart';
import 'package:bevis/helpers/geocoder/implementations/mobile_geocoder/mobile_geocoder.dart';

abstract class MobileBevisComponentsFactory
    extends PlatformBevisComponentsFactory {
  @override
  Geocoder createGeocoder() {
    return MobileGeocoder();
  }

  AssetFileEncoder createAssetFileEncoder() {
    return ZipAssetFileEncoder();
  }
}
