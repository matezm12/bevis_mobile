part of '../device_info_provider.dart';

class DeviceInfo {
  DeviceInfo({
    @required this.deviceId,
    @required this.brand,
    @required this.model,
  });

  final String deviceId;
  final String brand;
  final String model;
}
