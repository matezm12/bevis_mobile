import 'package:bevis/helpers/gps_location_provider/gps_location_provider.dart';
import 'package:bevis/helpers/image_resolution_provider/models/image_resolution.dart';
import 'package:flutter/material.dart';

class BevisAssetFileMetadata {
  const BevisAssetFileMetadata({
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
    this.numberOfPages = 1,
  });

  final String documentId;
  final String fileType;
  final ImageResolution resolution;
  final DateTime date;
  final String fileSize;
  final String ipAddress;
  final String country;
  final Location gps;
  final String deviceID;
  final String brand;
  final String model;
  final String operatingSystem;
  final String stateName;
  final String cityName;
  final int numberOfPages;
}
