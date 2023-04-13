import 'package:json_annotation/json_annotation.dart';

part 'asset_type.g.dart';

@JsonSerializable()
class AssetType {
  final int id;
  final String name;
  final String key;
  final bool topupEnable;

  AssetType({this.id, this.name, this.key, this.topupEnable});

  factory AssetType.fromJson(Map<String, dynamic> json) =>
      _$AssetTypeFromJson(json);
  Map<String, dynamic> toJson() => _$AssetTypeToJson(this);

  @override
  String toString() {
    return 'AssetType{id: $id, name: $name, key: $key, topupEnable: $topupEnable}';
  }
}
