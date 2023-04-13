import 'package:bevis/helpers/operating_system_info_provider/operating_system_info_provider.dart';
import 'dart:io';

class DartIOOpeatingSystemInfoProvider implements OperatingSystemInfoProvider {
  @override
  Future<String> getOperatingSystemName() async {
    return Platform.operatingSystem;
  }
}