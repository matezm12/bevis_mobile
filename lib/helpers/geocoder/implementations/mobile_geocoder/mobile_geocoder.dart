import 'package:bevis/helpers/geocoder/geocoder.dart';
import 'package:bevis/helpers/geocoder/implementations/mobile_geocoder/mappers/placemark_mapper.dart';
import 'package:geocoding/geocoding.dart' as geo;

class MobileGeocoder implements Geocoder {
  @override
  Future<Placemark> placemarkFromCoordinates(
      double latitude, double longitude) async {
    List<geo.Placemark> placemarks =
        await geo.placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      return mapPlacemark(placemarks.first);
    }

    return null;
  }
}
