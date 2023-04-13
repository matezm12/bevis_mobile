import 'package:bevis/helpers/ip_provider/ip_provider.dart';
import 'package:dio/dio.dart';

class IpfyDioIpProvider implements IpProvider {
  @override
  Future<String> getIpAddress() async {
    Response publicIP = await Dio().get("https://api.ipify.org");
    return publicIP.data.toString();
  }
}
