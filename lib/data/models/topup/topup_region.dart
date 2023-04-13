import 'package:json_annotation/json_annotation.dart';

part 'topup_region.g.dart';

@JsonSerializable()
class TopupRegion {
  final String name;
  final String countryCode;

  TopupRegion({this.name, this.countryCode});

  factory TopupRegion.fromJson(Map<String, dynamic> json) =>
      _$TopupRegionFromJson(json);

  Map<String, dynamic> toJson() => _$TopupRegionToJson(this);
}
