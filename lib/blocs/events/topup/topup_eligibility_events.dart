import 'package:flutter/material.dart';

abstract class TopupEligibilityEvent {}

class CheckAssetEligibility extends TopupEligibilityEvent {
  final String publicKey;
  final String countryCode;

  CheckAssetEligibility({@required this.publicKey, @required this.countryCode});
}

class HideActivationPopUp extends TopupEligibilityEvent {
  final String publicKey;

  HideActivationPopUp({@required this.publicKey});
}
