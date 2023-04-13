import 'package:json_annotation/json_annotation.dart';

part 'asset_master.g.dart';

@JsonSerializable()
class AssetMaster {
  final String assetId;
  final String publicKey;
  final String genDate;

  AssetMaster({this.assetId, this.publicKey, this.genDate});

  factory AssetMaster.fromJson(Map<String, dynamic> json) =>
      _$AssetMasterFromJson(json);
  Map<String, dynamic> toJson() => _$AssetMasterToJson(this);

  @override
  String toString() {
    return 'AssetMaster{assetId: $assetId, publicKey: $publicKey, genDate: $genDate}';
  }
}
