library location_provider;

import 'package:flutter/foundation.dart';

part 'models/location.dart';
part 'exceptions/gps_location_provider_exceptions.dart';

abstract class GpsLocationProvider {
  Future<Location> getUserLocation();
}