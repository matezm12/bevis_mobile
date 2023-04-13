import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  String address;
  double balance;
  String currency;

  Token(this.address, this.balance, this.currency);

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);

  String formattedBalance() {
    return balance.toStringAsFixed(8);
  }
}