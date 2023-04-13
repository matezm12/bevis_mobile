// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topup_region.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopupRegion _$TopupRegionFromJson(Map<String, dynamic> json) {
  return TopupRegion(
    name: json['name'] as String,
    countryCode: json['countryCode'] as String,
  );
}

Map<String, dynamic> _$TopupRegionToJson(TopupRegion instance) =>
    <String, dynamic>{
      'name': instance.name,
      'countryCode': instance.countryCode,
    };
