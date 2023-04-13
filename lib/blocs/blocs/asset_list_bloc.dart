import 'package:bevis/blocs/events/asset_list_events.dart';
import 'package:bevis/blocs/states/asset_list_states.dart';
import 'package:bevis/data/models/asset.dart';
import 'package:bevis/data/models/bevis_asset.dart';
import 'package:bevis/data/models/currency.dart';
import 'package:bevis/data/repositories/database_repositories/asset_db_repository.dart';
import 'package:bevis/data/repositories/database_repositories/asset_sqlite_db_repository.dart';
import 'package:bevis/data/repositories/network_repositories/asset_network_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bevis/utils/notifications/notification_center.dart';
import 'package:bevis/utils/notifications/notification_events.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AssetListBloc extends Bloc<AssetListEvent, AssetListState> {
  AssetListBloc(
      {@required AssetDatabaseRepository coinDbRepo,
      @required AssetNetworkRepository assetNetworkRepository})
      : _assetDatabaseRepo = coinDbRepo,
        _assetNetworkRepository = assetNetworkRepository,
        super(AssetListState(
          isLoading: true,
          bevisAssetPagination: BevisAssetPagination(
            assets: [],
            pagination: null,
          ),
          coinListValueSum: 0,
          selectedCurrency: Currency.defaultCurrency,
        )) {
    NotificationCenter.shared()
        .eventBus
        .on<LocalWalletsNumberChanged>()
        .listen((_) {
      add(LoadAssetList(false));
    });

    NotificationCenter.shared()
        .eventBus
        .on<DefaultCurrencyChanged>()
        .listen((_) {
      add(LoadAssetList(false));
    });
  }

  BevisAssetPagination _bevisAssetPagination = BevisAssetPagination(
    assets: [],
    pagination: null,
  );

  AssetSqliteDatabaseRepositoryImpl _assetDatabaseRepo;
  AssetNetworkRepository _assetNetworkRepository;

  Future<Asset> getAssetInfo(String assetId) async {
    print("in asset info getting");
    final res = await _assetNetworkRepository.getAssetInfoByPublicKey(
        publicKey: assetId);
    if (res.error == null) {
      return res.resultValue;
    } else {
      return null;
    }
  }

  @override
  Stream<AssetListState> mapEventToState(
    AssetListEvent event,
  ) async* {
    print("in bloc");
    if (event is LoadAssetList) {
      try {
        var response = await _assetNetworkRepository.getAssets();

        if (response.error == null) {
          print("in no error");
          _bevisAssetPagination = response.resultValue as BevisAssetPagination;
          print("In result no error");

          yield state.copyWith(isLoading: false, assets: response.resultValue);
        }
      } on Error catch (e) {
        print("error loading " + e.toString());
      }
    } else if (event is RenameAsset) {
      final asset = event.asset;
      asset.name = event.newName;
      try {
        await _assetNetworkRepository.renameAsset(
            assetId: asset.assetId, name: event.newName);

        yield state.copyWith(assets: _bevisAssetPagination);
      } on DioError catch (_) {}
    } else if (event is DeleteAsset) {
      final asset = event.asset;

      try {
        await _assetNetworkRepository.deleteAsset(assetId: asset.assetId);

        final res =
            await _assetDatabaseRepo.deleteAssetByPublicKey(asset.assetId);

        if (res.error == null) {
          _bevisAssetPagination.assets.remove(asset);
          yield state.copyWith(assets: _bevisAssetPagination);
        }
      } on DioError catch (_) {}
    } else if (event is SortAssetByDate) {
      try {
        var response = await _assetNetworkRepository.getAssets();

        if (response.error == null) {
          print("in no error");
          _bevisAssetPagination = response.resultValue as BevisAssetPagination;
          print("In result no error");

          yield state.copyWith(isLoading: false, assets: _bevisAssetPagination);
        }
      } on Error catch (e) {
        print("error loading " + e.toString());
      }
    } else if (event is SortAssetByName) {
      try {
        var response =
            await _assetNetworkRepository.getAssets(sortBy: "name,asc");
        if (response.error == null) {
          print("in no error");
          _bevisAssetPagination = response.resultValue as BevisAssetPagination;
          print("In result no error");

          yield state.copyWith(isLoading: false, assets: _bevisAssetPagination);
        }
      } on Error catch (e) {
        print("error loading " + e.toString());
      }
    } else if (event is SortAssetByType) {
      try {
        var response = await _assetNetworkRepository.getAssets(
            sortBy: "masterAssetTypeKey,asc");

        if (response.error == null) {
          print("in no error");
          _bevisAssetPagination = response.resultValue as BevisAssetPagination;
          print("In result no error");

          yield state.copyWith(isLoading: false, assets: _bevisAssetPagination);
        }
      } on Error catch (e) {
        print("error loading " + e.toString());
      }
    }
  }
}
