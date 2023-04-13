import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

@JsonSerializable()
class Currency {
  String shortName;
  String longName;

  Currency({this.shortName, this.longName});

  factory Currency.fromJson(Map<String, dynamic> json) => _$CurrencyFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyToJson(this);

  static get defaultCurrency => Currency(shortName: 'USD', longName: 'United States DOllar');

  @override
  String toString() {
    return '$longName ($shortName)';
  }

  String formattedCurrencySign() {
    switch(shortName.toLowerCase()) {
      case 'usd':
      return '\$';
      case 'eur':
      return '€';
      default:
      return shortName;
    }
  }
}