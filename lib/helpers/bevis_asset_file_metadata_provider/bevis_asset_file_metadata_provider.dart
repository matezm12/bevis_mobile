import 'package:bevis/helpers/bevis_asset_file_metadata_provider/models/bevis_asset_file_metadata.dart';
import 'package:bevis/helpers/bevis_asset_file_metadata_provider/states/bevis_asset_metadata_provider_states.dart';
import 'package:bevis/helpers/device_info_provider/device_info_provider.dart';
import 'package:bevis/helpers/document_id_provider/document_id_provider.dart';
import 'package:bevis/helpers/file_size_info_provider.dart/file_size_info_provider.dart';
import 'package:bevis/helpers/geocoder/geocoder.dart';
import 'package:bevis/helpers/gps_location_provider/gps_location_provider.dart';
import 'package:bevis/helpers/image_resolution_provider/image_resolution_provider.dart';
import 'package:bevis/helpers/image_resolution_provider/models/image_resolution.dart';
import 'package:bevis/helpers/ip_provider/ip_provider.dart';
import 'package:bevis/helpers/operating_system_info_provider/operating_system_info_provider.dart';
import 'package:bevis/helpers/pdf_meta_info_provider.dart/pdf_meta_info_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';

class BevisAssetFileMetadataProvider {
  BevisAssetFileMetadataProvider({
    @required IpProvider ipProvider,
    @required GpsLocationProvider locationProvider,
    @required DocumentIdProvider documentIdProvider,
    @required PdfMetaInfoProvider pdfMetaInfoProvider,
    @required ImageResolutionProvider imageResolutionProvider,
    @required Geocoder geocoder,
    @required DeviceInfoProvider deviceInfoProvider,
    @required OperatingSystemInfoProvider operatingSystemInfoProvider,
    @required FileSizeInfoProvider fileSizeInfoProvider,
  })  : _ipProvider = ipProvider,
        _locationProvider = locationProvider,
        _documentIdProvider = documentIdProvider,
        _pdfMetaInfoProvider = pdfMetaInfoProvider,
        _imageResolutionProvider = imageResolutionProvider,
        _geocoder = geocoder,
        _deviceInfoProvider = deviceInfoProvider,
        _operatingSystemInfoProvider = operatingSystemInfoProvider,
        _fileSizeInfoProvider = fileSizeInfoProvider;

  final IpProvider _ipProvider;
  final GpsLocationProvider _locationProvider;
  final DocumentIdProvider _documentIdProvider;
  final PdfMetaInfoProvider _pdfMetaInfoProvider;
  final ImageResolutionProvider _imageResolutionProvider;
  final Geocoder _geocoder;
  final DeviceInfoProvider _deviceInfoProvider;
  final OperatingSystemInfoProvider _operatingSystemInfoProvider;
  final FileSizeInfoProvider _fileSizeInfoProvider;

  final _metadataProviderCurrentStateSubject =
      BehaviorSubject<BevisAssetMetadataProviderStates>();

  Stream<BevisAssetMetadataProviderStates>
      get metadataProviderCurrentStateStream =>
          _metadataProviderCurrentStateSubject.stream;

  Future<BevisAssetFileMetadata> getBevisAssetMetadata(
      List<int> fileData, String fileMimeType) async {
    _metadataProviderCurrentStateSubject
        .add(BevisAssetMetadataProviderStates.gettingIpAddress);

    final ipAddress = await _ipProvider.getIpAddress();

    _metadataProviderCurrentStateSubject
        .add(BevisAssetMetadataProviderStates.gettingLocation);

    final location = await _locationProvider.getUserLocation();

    _metadataProviderCurrentStateSubject
        .add(BevisAssetMetadataProviderStates.gettingDeviceInformation);

    var numberOfPages;
    ImageResolution imageResolution;

    try {
      if (fileMimeType.contains('pdf')) {
        numberOfPages =
            await _pdfMetaInfoProvider.getNumberOfPages(pdfData: fileData);
      } else if (fileMimeType.contains("image")) {
        imageResolution =
            await _imageResolutionProvider.getResolutionForImage(fileData);
      }
    } on Exception catch (_) {}

    _metadataProviderCurrentStateSubject
        .add(BevisAssetMetadataProviderStates.gettingAddress);

    final address =
        await _geocoder.placemarkFromCoordinates(location.lat, location.lng);

    _metadataProviderCurrentStateSubject
        .add(BevisAssetMetadataProviderStates.gettingDeviceInformation);

    final deviceInfo = await _deviceInfoProvider?.getDeviceInfo();
    final operatingSystem =
        await _operatingSystemInfoProvider.getOperatingSystemName();
    final fileSize =
        await _fileSizeInfoProvider.getHumanReadableFileSizeString(fileData);
    final documentId = await _documentIdProvider.getDocumentId(fileData);

    return BevisAssetFileMetadata(
      documentId: documentId,
      fileType: fileMimeType,
      resolution: imageResolution,
      date: DateTime.now(),
      fileSize: fileSize,
      deviceID: deviceInfo?.deviceId,
      brand: deviceInfo?.brand,
      model: deviceInfo?.model,
      operatingSystem: operatingSystem,
      stateName: address?.state,
      cityName: address?.city,
      ipAddress: ipAddress,
      country: address?.country,
      gps: location,
      numberOfPages: numberOfPages,
    );
  }
}
