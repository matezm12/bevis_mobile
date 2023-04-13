import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'topup_order.g.dart';

@JsonSerializable(createToJson: false)
class TopupOrder {
  int orderId;
  String fiatCurrency;
  double amount;
  String cryptoCurrency;
  double creditAmount;
  bool promoCode;
  int applicationFeeInPercents;
  double applicationFee;
  double fixedFee;

  @JsonKey(name: 'expirationDate')
  String expirationDateStr;

  @JsonKey(name: 'fiatRealAmount')
  double fiatFinalAmount;

  double marketPrice;

  TopupOrder(
      {this.orderId,
      this.fiatCurrency,
      this.amount,
      this.cryptoCurrency,
      this.creditAmount,
      this.promoCode,
      this.applicationFee,
      this.applicationFeeInPercents,
      this.fiatFinalAmount, this.expirationDateStr, this.marketPrice});

  factory TopupOrder.fromJson(Map<String, dynamic> json) => _$TopupOrderFromJson(json);

  String getExpirationDateFormattedString() {
    final expirationDate = DateTime.parse(expirationDateStr).toLocal();
    var formatter = new DateFormat('d MMM yyyy HH:mm');
    final formatted = formatter.format(expirationDate);
    return formatted;
  }
}
