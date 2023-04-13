library ip_provider;

abstract class IpProvider {
  Future<String> getIpAddress();
}