// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) {
  return Token(
    json['address'] as String,
    (json['balance'] as num)?.toDouble(),
    json['currency'] as String,
  );
}

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'address': instance.address,
      'balance': instance.balance,
      'currency': instance.currency,
    };
