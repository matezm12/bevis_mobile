// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinInfo _$CoinInfoFromJson(Map<String, dynamic> json) {
  return CoinInfo(
      json['coinID'] as String,
      (json['sourceCurrencyBalance'] as num)?.toDouble(),
      (json['destinationCurrencyBalance'] as num)?.toDouble(),
      json['hasTokens'] as bool,
      json['laser'] as String,
      json['sourceCurrency'] as String,
      (json['exchangeRate'] as num)?.toDouble(),
      json['destinationCurrency']);
}

Map<String, dynamic> _$CoinInfoToJson(CoinInfo instance) => <String, dynamic>{
      'coinID': instance.coinID,
      'sourceCurrencyBalance': instance.sourceCurrencyBalance,
      'destinationCurrencyBalance': instance.destinationCurrencyBalance,
      'hasTokens': instance.hasTokens,
      'laser': instance.laser,
      'exchangeRate': instance.exchangeRate,
      'sourceCurrency': instance.currency,
    };
