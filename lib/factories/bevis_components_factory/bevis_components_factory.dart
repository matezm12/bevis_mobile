import 'package:bevis/helpers/app_version_provider.dart/app_version_provider.dart';
import 'package:bevis/helpers/asset_file_encoder/asset_file_encoder.dart';
import 'package:bevis/helpers/bevis_asset_file_metadata_provider/bevis_asset_file_metadata_provider.dart';
import 'package:bevis/helpers/device_info_provider/device_info_provider.dart';
import 'package:bevis/helpers/document_id_provider/document_id_provider.dart';
import 'package:bevis/helpers/file_picker/file_picker.dart';
import 'package:bevis/helpers/file_size_info_provider.dart/file_size_info_provider.dart';
import 'package:bevis/helpers/geocoder/geocoder.dart';
import 'package:bevis/helpers/gps_location_provider/gps_location_provider.dart';
import 'package:bevis/helpers/image_compressor/image_compressor.dart';
import 'package:bevis/helpers/image_resolution_provider/image_resolution_provider.dart';
import 'package:bevis/helpers/ip_provider/ip_provider.dart';
import 'package:bevis/helpers/media_picker/media_picker.dart';
import 'package:bevis/helpers/operating_system_info_provider/operating_system_info_provider.dart';
import 'package:bevis/helpers/pdf_meta_info_provider.dart/pdf_meta_info_provider.dart';

export 'package:bevis/helpers/app_version_provider.dart/app_version_provider.dart';
export 'package:bevis/helpers/asset_file_encoder/asset_file_encoder.dart';
export 'package:bevis/helpers/bevis_asset_file_metadata_provider/bevis_asset_file_metadata_provider.dart';
export 'package:bevis/helpers/device_info_provider/device_info_provider.dart';
export 'package:bevis/helpers/document_id_provider/document_id_provider.dart';
export 'package:bevis/helpers/file_picker/file_picker.dart';
export 'package:bevis/helpers/file_size_info_provider.dart/file_size_info_provider.dart';
export 'package:bevis/helpers/geocoder/geocoder.dart';
export 'package:bevis/helpers/gps_location_provider/gps_location_provider.dart';
export 'package:bevis/helpers/image_compressor/image_compressor.dart';
export 'package:bevis/helpers/image_resolution_provider/image_resolution_provider.dart';
export 'package:bevis/helpers/ip_provider/ip_provider.dart';
export 'package:bevis/helpers/operating_system_info_provider/operating_system_info_provider.dart';
export 'package:bevis/helpers/pdf_meta_info_provider.dart/pdf_meta_info_provider.dart';

abstract class BevisComponentsFactory {
  AppVersionProvider createAppVersionProvider();
  BevisAssetFileMetadataProvider createAssetFileMetadataProvider();
  DeviceInfoProvider createDeviceInfoProvider();
  DocumentIdProvider createDocumentIdProvider();
  FilePicker createFilePicker();
  MediaPicker createMediaPicker();
  FileSizeInfoProvider createFileSizeInfoProvider();
  Geocoder createGeocoder();
  GpsLocationProvider createLocationProvider();
  ImageCompressor createImageCompressor();
  ImageResolutionProvider createImageResolutionProvider();
  IpProvider createIpProvider();
  OperatingSystemInfoProvider createOperatingSystemInfoProvider();
  PdfMetaInfoProvider createPdfMetaInfoProvider();
  AssetFileEncoder createAssetFileEncoder();
}