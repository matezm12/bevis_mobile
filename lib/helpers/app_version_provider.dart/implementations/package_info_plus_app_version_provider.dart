import 'package:bevis/helpers/app_version_provider.dart/app_version_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoPlusAppVersionProvider implements AppVersionProvider {
  @override
  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
