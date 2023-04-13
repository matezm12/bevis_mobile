import 'package:json_annotation/json_annotation.dart';

part 'asset_value.g.dart';

@JsonSerializable()
class AssetValue {
  final String fieldName;
  final bool descriptive;
  final String fieldValue;
  final String fieldTitle;

  final int zone;
  final List<String> links;

  AssetValue({
    this.fieldName,
    this.fieldValue,
    this.fieldTitle,
    this.links,
    this.zone,
    this.descriptive = false,
  });

  factory AssetValue.fromJson(Map<String, dynamic> json) =>
      _$AssetValueFromJson(json);
  Map<String, dynamic> toJson() => _$AssetValueToJson(this);

  @override
  String toString() {
    return 'AssetValue{fieldName: $fieldName, descriptive: $descriptive, fieldValue: $fieldValue, fieldTitle: $fieldTitle, zone: $zone, links: $links}';
  }
}
