import 'package:flutter/cupertino.dart';

abstract class TopupOverviewEvent {}

class CreateOrder extends TopupOverviewEvent {
  final double amount;
  final String fiatCurrency;
  final String publicKey;
  final int paymentMethodId;

  CreateOrder(
      {@required this.amount,
      @required this.fiatCurrency,
      @required this.publicKey,
      @required this.paymentMethodId});
}
