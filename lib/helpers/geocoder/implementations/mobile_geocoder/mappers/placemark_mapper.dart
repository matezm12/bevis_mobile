import 'package:bevis/helpers/geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart' as geo;

Placemark mapPlacemark(geo.Placemark placemark) {
  return Placemark(
    country: placemark.country,
    city: placemark.subAdministrativeArea,
    state: placemark.administrativeArea,
  );
}
