import 'package:json_annotation/json_annotation.dart';

part 'coin_info.g.dart';

@JsonSerializable()
class CoinInfo {
  final String coinID;
  final double sourceCurrencyBalance;
  final double destinationCurrencyBalance;
  final String destinationCurrency;

  final bool hasTokens;
  final String laser;
  final double exchangeRate;

  @JsonKey(name: 'sourceCurrency')
  final String currency;

  CoinInfo(
      this.coinID,
      this.sourceCurrencyBalance,
      this.destinationCurrencyBalance,
      this.hasTokens,
      this.laser,
      this.currency,
      this.exchangeRate,
      this.destinationCurrency);

  factory CoinInfo.fromJson(Map<String, dynamic> json) =>
      _$CoinInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CoinInfoToJson(this);

  @override
  String toString() {
    return 'CoinInfo{coinID: $coinID, sourceCurrencyBalance: $sourceCurrencyBalance, destinationCurrencyBalance: $destinationCurrencyBalance, hasTokens: $hasTokens, laser: $laser, exchangeRate: $exchangeRate, currency: $currency}';
  }
}
