import 'package:bevis/data/models/asset_file.dart';
import 'package:bevis/helpers/bevis_asset_file_metadata_provider/models/bevis_asset_file_metadata.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class BevisUploadAssets {
  BevisUploadAssets({
    @required this.documentId,
    @required this.fileType,
    @required this.resolution,
    @required this.date,
    @required this.fileSize,
    @required this.deviceID,
    @required this.brand,
    @required this.model,
    @required this.operatingSystem,
    @required this.stateName,
    @required this.cityName,
    @required this.ipAddress,
    @required this.country,
    @required this.gps,
    @required this.pickedFile,
    this.assetId,
    this.numberOfPages,
  });

  factory BevisUploadAssets.from({
    @required BevisAssetFileMetadata metadata,
    @required AssetFile pickedFile,
    String assetId,
  }) {
    final gps = metadata.gps;
    final imageResolution = metadata.resolution;

    String locationStr = 'N/A';
    String resolutionString;

    if (gps != null) {
      locationStr = gps.lat.toString() + "," + gps.lng.toString();
    }

    if (imageResolution != null) {
      resolutionString = imageResolution.width.toString() +
          "x" +
          imageResolution.height.toString();
    }

    final formattedDateStr =
        DateFormat(DateFormat.YEAR_MONTH_DAY).format(metadata.date);

    return BevisUploadAssets(
      assetId: assetId,
      pickedFile: pickedFile,
      documentId: metadata.documentId,
      fileType: metadata.fileType,
      resolution: resolutionString,
      date: formattedDateStr,
      fileSize: metadata.fileSize,
      deviceID: metadata.deviceID ?? 'N/A',
      brand: metadata.brand ?? 'N/A',
      model: metadata.model ?? 'N/A',
      operatingSystem: metadata.operatingSystem,
      stateName: metadata.stateName ?? 'N/A',
      cityName: metadata.cityName ?? 'N/A',
      ipAddress: metadata.ipAddress,
      country: metadata.country ?? 'N/A',
      gps: locationStr,
    );
  }

  final String assetId;
  final String documentId;
  final String fileType;
  final String resolution;
  final String date;
  final String fileSize;
  final String ipAddress;
  final String country;
  final String gps;
  final String deviceID;
  final String brand;
  final String model;
  final String operatingSystem;
  final String stateName;
  final String cityName;
  final bool isEncrypted = false;
  final String numberOfPages;
  final AssetFile pickedFile;
}
