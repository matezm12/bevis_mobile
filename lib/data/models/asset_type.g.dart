// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetType _$AssetTypeFromJson(Map<String, dynamic> json) {
  return AssetType(
    id: json['id'] as int,
    name: json['name'] as String,
    key: json['key'] as String,
    topupEnable: json['topupEnable'] as bool,
  );
}

Map<String, dynamic> _$AssetTypeToJson(AssetType instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'key': instance.key,
      'topupEnable': instance.topupEnable,
    };
