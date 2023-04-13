import 'dart:convert';

import 'package:bevis/data/models/asset_master.dart';
import 'package:bevis/data/models/asset_type.dart';
import 'package:bevis/data/models/asset_value.dart';
import 'package:bevis/data/models/coin_info.dart';
import 'package:bevis/data/models/product.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Asset {
  final AssetType assetType;
  final List<AssetValue> displayValues;
  final CoinInfo coinInfo;
  final AssetMaster master;
  final Product product;
  String description;

  bool isAdded;

  Asset({
    this.assetType,
    this.displayValues,
    this.coinInfo,
    this.master,
    this.product,
    this.description,
    this.isAdded = false,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
  Map<String, dynamic> toJson() => _$AssetToJson(this);

  Map<String, dynamic> toDbMap() {
    final json = toJson();
    return {'publicKey': this.master.publicKey, 'json': jsonEncode(json)};
  }

  factory Asset.fromDatabaseMap(Map<String, dynamic> dbMap) {
    final asset = Asset.fromJson(jsonDecode(dbMap['json']));
    asset.isAdded = true;
    return asset;
  }

  String formattedValueString() {
    return coinInfo?.destinationCurrencyBalance?.toStringAsFixed(2) ?? '';
  }

  @override
  String toString() {
    return 'Asset{assetType: $assetType, displayValues: $displayValues, coinInfo: $coinInfo, master: $master, product: $product, description: $description, isAdded: $isAdded}';
  }

  @override
  int get hashCode => this.master?.assetId ?? 0;

  @override
  bool operator ==(Object other) {
    print("here  in equal");
    return identical(this, other) ||
        other is Asset &&
            runtimeType == other.runtimeType &&
            master.assetId == other.master.assetId;
  }
}

Asset _$AssetFromJson(Map<String, dynamic> json) {
  return Asset(
    assetType: json['assetType'] == null
        ? null
        : AssetType.fromJson(json['assetType'] as Map<String, dynamic>),
    displayValues: (json['displayValues'] as List)
        ?.map((e) =>
            e == null ? null : AssetValue.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    coinInfo: json['coinInfo'] == null
        ? null
        : CoinInfo.fromJson(json['coinInfo'] as Map<String, dynamic>),
    master: json['master'] == null
        ? null
        : AssetMaster.fromJson(json['master'] as Map<String, dynamic>),
    product: json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
    description: json['description'] as String,
    isAdded: json['isAdded'] as bool,
  );
}

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'assetType': instance.assetType,
      'displayValues': instance.displayValues,
      'coinInfo': instance.coinInfo,
      'master': instance.master,
      'product': instance.product,
      'description': instance.description,
      'isAdded': instance.isAdded,
    };
