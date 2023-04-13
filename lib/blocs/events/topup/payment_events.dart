import 'package:flutter/material.dart';

abstract class PaymentEvent {}

class GetAvailablePaymentMethods extends PaymentEvent {
  final String countryCode;
  final String publicKey;

  GetAvailablePaymentMethods({@required this.countryCode, @required this.publicKey});
}

class GetPaymentMethodDetails extends PaymentEvent {
  final int id;

  GetPaymentMethodDetails({@required this.id});
}