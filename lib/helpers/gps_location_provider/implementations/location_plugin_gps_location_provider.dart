import 'package:bevis/helpers/gps_location_provider/gps_location_provider.dart';
import 'package:location/location.dart' as loc;

class LocationPluginGpsLocationProvider implements GpsLocationProvider {
  Set<loc.PermissionStatus> get _grantedPermissionStatuses =>
      {loc.PermissionStatus.granted, loc.PermissionStatus.grantedLimited};

  @override
  Future<Location> getUserLocation() async {
    try {
      final location = loc.Location();
      var _serviceEnabled = await location.serviceEnabled();

      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          throw LocationPermissionNotGranted();
        }
      }

      var _permissionStatus = await location.hasPermission();
      if (!_grantedPermissionStatuses.contains(_permissionStatus)) {
        _permissionStatus = await location.requestPermission();
      }

      if (!_grantedPermissionStatuses.contains(_permissionStatus)) {
        throw LocationPermissionNotGranted();
      }

      final userLocation = await location.getLocation();

      return Location(
        lat: userLocation.latitude,
        lng: userLocation.longitude,
      );
    } on Exception catch (_) {
      throw LocationPermissionNotGranted();
    }
  }
}
