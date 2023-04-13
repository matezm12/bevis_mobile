import 'package:bevis/blocs/events/asset_info_events.dart';
import 'package:bevis/blocs/states/asset_info_states.dart';
import 'package:bevis/data/models/asset.dart';
import 'package:bevis/data/repositories/database_repositories/asset_db_repository.dart';
import 'package:bevis/data/repositories/network_repositories/asset_network_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bevis/data/currency_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_repository/flutter_repository.dart';

class AssetInfoBloc extends Bloc<AssetInfoEvent, AssetInfoState> {
  AssetNetworkRepository _assetNetworkRepository;
  AssetDatabaseRepository _assetDatabaseRepository;

  Asset _asset;

  AssetInfoBloc(
      {@required AssetNetworkRepository networkRepo,
      @required AssetDatabaseRepository databaseRepo})
      : _assetNetworkRepository = networkRepo,
        _assetDatabaseRepository = databaseRepo,
        super(
          AssetInfoState(isLoading: true),
        );

  @override
  Stream<AssetInfoState> mapEventToState(
    AssetInfoEvent event,
  ) async* {
    if (event is LoadAssetInfo) {
      yield AssetInfoState(isLoading: true, asset: _asset);
      final pubKey = event.publicKey;
      final defCur = await CurrencyStorage.getDefaultCurrency();

      print("here before  load");

      final res = await _assetNetworkRepository.getAssetInfoByPublicKey(
          publicKey: pubKey, currency: defCur.shortName.toLowerCase());
      print("here before local success load");

      if (res.error == null) {
        _asset = res.resultValue;
        final dbRes =
            await _assetDatabaseRepository.getAssetByPublicKey(pubKey);
        _asset.isAdded = dbRes.resultValue != null;
        yield AssetInfoState(isLoading: false, asset: _asset);
        print("here success load");
      } else {
        var e = res.error as NetworkError;
        print("here + FAIL loaded" + e.errorMsg.toString());
        yield FailedToLoadAssetInfo(
            error: res.error,
            isLoading: false,
            asset: state.asset,
            selectedCurrency: defCur);
      }
    } else if (event is AddAsset) {
      try {
        var response = await _assetNetworkRepository.addAsset(
            assetId: event.asset.master.assetId);
        print("Response " + response.toString());
        yield SuccessAddedAsset();
      } on DioError catch (e) {
        print(" fail adding" + e.response.toString());
        yield FailedToAddAsset(
            errorMsg: e.response.data["message"], asset: event.asset);
      }
    }
  }
}
