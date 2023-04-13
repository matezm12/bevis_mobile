part of '../geocoder.dart';

class Placemark {
  Placemark({
    this.country,
    this.city,
    this.state,
  });

  final String country;
  final String city;
  final String state;
}
