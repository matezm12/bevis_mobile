// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topup_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopupOrder _$TopupOrderFromJson(Map<String, dynamic> json) {
  return TopupOrder(
    orderId: json['orderId'] as int,
    fiatCurrency: json['fiatCurrency'] as String,
    amount: (json['amount'] as num)?.toDouble(),
    cryptoCurrency: json['cryptoCurrency'] as String,
    creditAmount: (json['creditAmount'] as num)?.toDouble(),
    promoCode: json['promoCode'] as bool,
    applicationFee: (json['applicationFee'] as num)?.toDouble(),
    applicationFeeInPercents: json['applicationFeeInPercents'] as int,
    fiatFinalAmount: (json['fiatRealAmount'] as num)?.toDouble(),
    expirationDateStr: json['expirationDate'] as String,
    marketPrice: (json['marketPrice'] as num)?.toDouble(),
  )..fixedFee = (json['fixedFee'] as num)?.toDouble();
}
