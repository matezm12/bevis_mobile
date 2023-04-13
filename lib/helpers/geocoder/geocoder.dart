part 'models/placemark.dart';

abstract class Geocoder {
  Future<Placemark> placemarkFromCoordinates(double latitude, double longitude);
}
