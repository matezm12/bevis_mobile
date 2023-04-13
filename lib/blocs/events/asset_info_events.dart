import 'package:bevis/data/models/asset.dart';
import 'package:flutter/widgets.dart';

abstract class AssetInfoEvent {}

class LoadAssetInfo extends AssetInfoEvent {
  final String publicKey;

  LoadAssetInfo(this.publicKey);
}

class AddAsset extends AssetInfoEvent {
  final Asset asset;
  AddAsset({@required this.asset});
}

class LoadExtendedAssetInfo extends AssetInfoEvent {
  final String publicKey;

  LoadExtendedAssetInfo(this.publicKey);
}

class CheckCoinActivationEligibility extends AssetInfoEvent {
  String publicKey;
  String countryCode;

  CheckCoinActivationEligibility(
      {@required this.publicKey, @required this.countryCode});
}

class HideCoinActivationPopUp extends AssetInfoEvent {
  final String publicKey;

  HideCoinActivationPopUp({@required this.publicKey});
}
