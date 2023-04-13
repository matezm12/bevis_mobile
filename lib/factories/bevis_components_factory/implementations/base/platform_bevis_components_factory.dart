import 'package:bevis/factories/bevis_components_factory/bevis_components_factory.dart';
import 'package:bevis/helpers/app_version_provider.dart/implementations/package_info_plus_app_version_provider.dart';
import 'package:bevis/helpers/bevis_asset_file_metadata_provider/bevis_asset_file_metadata_provider.dart';
import 'package:bevis/helpers/document_id_provider/implementations/sha256_hash_document_id_provider.dart';
import 'package:bevis/helpers/file_picker/implementations/file_picker_imp.dart';
import 'package:bevis/helpers/file_size_info_provider.dart/implementations/filesize_plugin_file_size_info_provider.dart';
import 'package:bevis/helpers/gps_location_provider/implementations/location_plugin_gps_location_provider.dart';
import 'package:bevis/helpers/image_compressor/implementation/image_compressor_imp.dart';
import 'package:bevis/helpers/image_resolution_provider/implementations/image_resolution_provider_imp.dart';
import 'package:bevis/helpers/ip_provider/implementations/ipify_dio_ip_provider.dart';
import 'package:bevis/helpers/media_picker/implementations/image_picker_media_picker.dart';
import 'package:bevis/helpers/media_picker/media_picker.dart';
import 'package:bevis/helpers/operating_system_info_provider/implementations/dart_io_operating_system_info_provider.dart';
import 'package:bevis/helpers/pdf_meta_info_provider.dart/implementations/pdf_render_pdf_meta_info_provider.dart';

abstract class PlatformBevisComponentsFactory
    implements BevisComponentsFactory {
  @override
  AppVersionProvider createAppVersionProvider() {
    return PackageInfoPlusAppVersionProvider();
  }

  @override
  BevisAssetFileMetadataProvider createAssetFileMetadataProvider() {
    return BevisAssetFileMetadataProvider(
      ipProvider: createIpProvider(),
      locationProvider: createLocationProvider(),
      documentIdProvider: createDocumentIdProvider(),
      pdfMetaInfoProvider: createPdfMetaInfoProvider(),
      imageResolutionProvider: createImageResolutionProvider(),
      geocoder: createGeocoder(),
      deviceInfoProvider: createDeviceInfoProvider(),
      operatingSystemInfoProvider: createOperatingSystemInfoProvider(),
      fileSizeInfoProvider: createFileSizeInfoProvider(),
    );
  }

  @override
  DocumentIdProvider createDocumentIdProvider() {
    return SHA256HashDocumentIdProvider();
  }

  @override
  FilePicker createFilePicker() {
    return FilePickerImp();
  }

  @override
  MediaPicker createMediaPicker() {
    return ImagePickerMediaPicker();
  }

  @override
  FileSizeInfoProvider createFileSizeInfoProvider() {
    return FilesizePluginFileSizeInfoProvider();
  }

  @override
  GpsLocationProvider createLocationProvider() {
    return LocationPluginGpsLocationProvider();
  }

  @override
  ImageCompressor createImageCompressor() {
    return ImageCompressorImp();
  }

  @override
  ImageResolutionProvider createImageResolutionProvider() {
    return ImageResolutionProviderImp();
  }

  @override
  IpProvider createIpProvider() {
    return IpfyDioIpProvider();
  }

  @override
  OperatingSystemInfoProvider createOperatingSystemInfoProvider() {
    return DartIOOpeatingSystemInfoProvider();
  }

  @override
  PdfMetaInfoProvider createPdfMetaInfoProvider() {
    return PdfRenderPdfMetaInfoProvider();
  }
}
