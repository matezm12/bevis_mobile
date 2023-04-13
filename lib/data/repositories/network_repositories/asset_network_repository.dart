import 'package:bevis/data/models/asset.dart';
import 'package:bevis/data/models/image_asset.dart';
import 'package:bevis/data/repositories/asset_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';

import 'package:meta/meta.dart';

abstract class AssetNetworkRepository implements AssetRepository {
  Future<RestRepositoryResult<Asset>> getAssetInfoByPublicKey(
      {@required String publicKey,
      String currency = 'usd',
      bool detailed = false});
  Future<RestRepositoryResult<List<Asset>>> getAssetInfoListByPublicKeys(
      {@required List<String> publicKeys, String currency = 'usd'});
  Future<Response> writeAsset({
    @required List<int> assetFileData,
    @required BevisUploadAssets assetImage,
    @required blockChain,
    @required String deviceId,
    @required bool assetEncrypted,
    int numberOfPages = 1,
  });
  Future<Response> addAssetToAssetID({
    @required String assetId,
    @required List<int> assetFileData,
    @required BevisUploadAssets assetImage,
    @required String deviceId,
    @required bool assetEncrypted,
    int numberOfPages = 1,
    ProgressCallback onProgress,
  });

  Future<Response> validateAssetId({@required String assetId});

  Future<Response> assetFiles({@required String assetId});

  Future<Response> addAsset({@required String assetId});

  Future<RestRepositoryResult> getAssets(
      {int size = 10, int page = 0, String sortBy = "masterGenDate,desc"});

  Future<Response> renameAsset(
      {@required String assetId, @required String name});

  Future<Response> deleteAsset({@required String assetId});
}
