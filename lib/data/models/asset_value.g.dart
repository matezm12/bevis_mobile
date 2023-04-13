// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetValue _$AssetValueFromJson(Map<String, dynamic> json) {
  return AssetValue(
    fieldName: json['fieldName'] as String,
    fieldValue: json['fieldValue'] as String,
    fieldTitle: json['fieldTitle'] as String,
    links: (json['links'] as List)?.map((e) => e as String)?.toList(),
    zone: json['zone'] as int,
    descriptive: json['descriptive'] as bool,
  );
}

Map<String, dynamic> _$AssetValueToJson(AssetValue instance) =>
    <String, dynamic>{
      'fieldName': instance.fieldName,
      'descriptive': instance.descriptive,
      'fieldValue': instance.fieldValue,
      'fieldTitle': instance.fieldTitle,
      'zone': instance.zone,
      'links': instance.links,
    };
