import 'package:bevis/factories/bevis_components_factory/bevis_components_factory.dart';

class WebOperatingSystemInfoProvider implements OperatingSystemInfoProvider {
  @override
  Future<String> getOperatingSystemName() async {
    return 'N/A';
  }
}