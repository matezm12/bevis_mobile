import 'package:bevis/helpers/geocoder/geocoder.dart';
import 'package:google_geocoding/google_geocoding.dart';

class WebGeocoder implements Geocoder {
  @override
  Future<Placemark> placemarkFromCoordinates(
      double latitude, double longitude) async {
    var googleGeocoding =
        GoogleGeocoding("AIzaSyBru87XMLZ8fnvQtw1I7LdFjoNIbq4sjM4");
    var reverseGeocoding = await googleGeocoding.geocoding.getReverse(
      LatLon(
        latitude,
        longitude,
      ),
    );

    return Placemark(
      city: 'N/A',
      country: 'N/A',
      state: 'N/A',
    );
  }
}
