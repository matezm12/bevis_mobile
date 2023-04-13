// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_master.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetMaster _$AssetMasterFromJson(Map<String, dynamic> json) {
  return AssetMaster(
    assetId: json['assetId'] as String,
    publicKey: json['publicKey'] as String,
    genDate: json['genDate'] as String,
  );
}

Map<String, dynamic> _$AssetMasterToJson(AssetMaster instance) =>
    <String, dynamic>{
      'assetId': instance.assetId,
      'publicKey': instance.publicKey,
      'genDate': instance.genDate,
    };
