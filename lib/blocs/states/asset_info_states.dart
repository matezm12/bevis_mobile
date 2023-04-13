import 'package:bevis/blocs/states/base_state.dart';
import 'package:bevis/data/models/asset.dart';
import 'package:bevis/data/models/currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';

class AssetInfoState extends BaseState {
  final Asset asset;
  final Currency selectedCurrency;

  AssetInfoState({this.asset, this.selectedCurrency, bool isLoading = false})
      : super(isLoading: isLoading);

  @override
  AssetInfoState copyWith(
      {bool isLoading, Asset asset, Currency selectedCurrency}) {
    return AssetInfoState(
        isLoading: isLoading ?? this.isLoading,
        asset: asset ?? this.asset,
        selectedCurrency: selectedCurrency ?? this.selectedCurrency);
  }
}

class FailedToLoadAssetInfo extends AssetInfoState {
  final NetworkError error;

  FailedToLoadAssetInfo(
      {@required this.error,
      @required bool isLoading,
      @required Asset asset,
      @required Currency selectedCurrency})
      : super(
            isLoading: isLoading,
            asset: asset,
            selectedCurrency: selectedCurrency);
}

class FailedToAddAsset extends AssetInfoState {
  final String errorMsg;
  FailedToAddAsset({
    @required this.errorMsg,
    @required Asset asset,
  }) : super(
          isLoading: false,
          asset: asset,
        );
}

class SuccessAddedAsset extends AssetInfoState {
  SuccessAddedAsset();
}
