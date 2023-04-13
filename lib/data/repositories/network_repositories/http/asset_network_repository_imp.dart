import 'package:bevis/data/models/asset.dart';
import 'package:bevis/data/models/bevis_asset.dart';
import 'package:bevis/data/models/image_asset.dart';
import 'package:bevis/data/repositories/network_repositories/asset_network_repository.dart';
import 'package:bevis/data/repositories/network_repositories/bevis_rest_repository_imp.dart';
import 'package:bevis/data/top_up/payment_history.dart';
import 'package:bevis/main.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_repository/clients/rest/rest_repository_client.dart';
import 'package:flutter_repository/network_repositories/network_config.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';
import 'package:meta/meta.dart';

class AssetNetworkRepositoryImp extends BevisRestRepositoryImp<Asset>
    implements AssetNetworkRepository {
  AssetNetworkRepositoryImp(
      {@required RestRepositoryClient client,
      @required NetworkConfig networkConfig})
      : super(client: client, networkConfig: networkConfig);

  @override
  Future<RestRepositoryResult<Asset>> getAssetInfoByPublicKey(
      {@required String publicKey,
      String currency = 'usd',
      bool detailed = false}) async {
    final url = buildUri(path: '/api/v2/asset-info', params: {
      'public_key': publicKey,
      'currency': currency,
    }).toString();
    final request = RestRepositoryRequest(url: url, httpMethod: 'GET');
    final response = await performRequest(request);
    final result = await parseResponse<Asset>(
        response: response, parseFunction: (json) => Asset.fromJson(json));

    return result;
  }

  Future<RestRepositoryResult<List<Asset>>> getAssetInfoListByPublicKeys(
      {@required List<String> publicKeys, String currency = 'usd'}) async {
    final url =
        buildUri(path: '/api/v2/asset-info', params: {'currency': currency})
            .toString();
    final request = RestRepositoryRequest(
      url: url,
      httpMethod: 'POST',
      body: {'publicKeys': publicKeys},
    );

    final response = await performRequest(request);
    return parseResponse<List<Asset>>(
      response: response,
      parseFunction: (json) {
        final dataArr = json['data'];

        var parsedAssets = <Asset>[];

        for (final assetJson in dataArr) {
          final asset = Asset.fromJson(assetJson);
          parsedAssets.add(asset);
        }

        return parsedAssets;
      },
    );
  }

  @override
  Future<Response> writeAsset({
    @required List<int> assetFileData,
    @required BevisUploadAssets assetImage,
    @required blockChain,
    @required String deviceId,
    @required bool assetEncrypted,
    int numberOfPages = 1,
  }) async {
    final url = buildUri(path: '/api/v2/master-documents/').toString();
    Dio dio = Dio();
    dio.options.headers = {
      'Content-Type': "application/json",
      'Authorization': "Bearer " + token
    };

    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        assetFileData,
        filename: assetImage.pickedFile.filename,
        contentType: MediaType.parse(assetImage.pickedFile.mimeType),
      ),
      'blockchain': blockChain,
      'numberOfPages': numberOfPages,
      'deviceId': deviceId,
      'ipAddress': assetImage.ipAddress,
      'gps': assetImage.gps,
      'country': assetImage.country,
      'brand': assetImage.brand,
      'model': assetImage.model,
      'stateName': assetImage.stateName,
      'cityName': assetImage.cityName,
      'encrypted': assetEncrypted,
      'operatingSystem': assetImage.operatingSystem
    });

    //http://35.171.166.110:9090/api/v2/master-documents/
    var dioResponse = await dio.post(url.toString(), data: formData);

    return dioResponse;
  }

  @override
  Future<Response> addAssetToAssetID({
    @required String assetId,
    @required List<int> assetFileData,
    @required BevisUploadAssets assetImage,
    @required String deviceId,
    @required bool assetEncrypted,
    int numberOfPages = 1,
    ProgressCallback onProgress,
  }) async {
    final url = buildUri(path: '/api/v2/master-documents/').toString();
    Dio dio = Dio();
    dio.options.headers = {
      'Content-Type': "application/json",
      'Authorization': "Bearer " + token
    };

    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        assetFileData,
        filename: assetImage.pickedFile.filename,
        contentType: MediaType.parse(assetImage.pickedFile.mimeType),
      ),
      'numberOfPages': numberOfPages,
      'deviceId': deviceId,
      'ipAddress': assetImage.ipAddress,
      'gps': assetImage.gps,
      'country': assetImage.country,
      'brand': assetImage.brand,
      'model': assetImage.model,
      'stateName': assetImage.stateName,
      'cityName': assetImage.cityName,
      'assetId': assetId,
      'encrypted': assetEncrypted,
      'operatingSystem': assetImage.operatingSystem
    });
    var dioResponse = await dio.put(url.toString(),
        data: formData, onSendProgress: onProgress);

    return dioResponse;
  }

  @override
  Future<Response> validateAssetId({String assetId}) async {
    final url = buildUri(path: '/api/master-documents/validate/').toString();
    Dio dio = Dio();
    dio.options.headers = {
      'Content-Type': "application/json",
      'Authorization': "Bearer " + token
    };
    print("token  " + assetId);
    print("url" + url);
    var dioResponse =
        await dio.get(url.toString(), queryParameters: {"asset-id": assetId});

    return dioResponse;
  }

  @override
  Future<Response> assetFiles({String assetId}) async {
    final url = buildUri(path: '/api/v2/asset-files').toString();
    Dio dio = Dio();
    dio.options.headers = {
      'Content-Type': "application/json",
      'Authorization': "Bearer " + token
    };
    print("token  " + assetId);
    print("url" + url);
    var dioResponse =
        await dio.get(url.toString(), queryParameters: {"asset-id": assetId});

    return dioResponse;
  }

  @override
  Future<Response> addAsset({String assetId}) async {
    final url = buildUri(path: '/api/lister-assets').toString();
    Dio dio = Dio();
    dio.options.headers = {
      'Content-Type': "application/json",
      'Authorization': "Bearer " + token
    };
    print("token  " + assetId);
    print("url" + url);
    var dioResponse =
        await dio.post(url.toString(), data: {"assetId": assetId});
    return dioResponse;
  }

  @override
  Future<RestRepositoryResult<BevisAssetPagination>> getAssets(
      {int size = 10,
      int page = 0,
      String sortBy = "masterGenDate,desc"}) async {
    final url = buildUri(path: '/api/lister-assets', params: {
      'size': size.toString(),
      'page': page.toString(),
      'sort': sortBy
    }).toString();
    print("url" + url);
    final request = RestRepositoryRequest(
      url: url,
      httpMethod: 'GET',
      headers: {
        'Content-Type': "application/json",
        'Authorization': "Bearer " + token
      },
    );

    final response = await performRequest(request);
    return parseResponse<BevisAssetPagination>(
      response: response,
      parseFunction: (json) {
        print("json" + json.toString());
        final dataArr = json['data'];

        var parsedAssets = <BevisAsset>[];

        for (final assetJson in dataArr) {
          final asset = BevisAsset.fromJson(assetJson);
          parsedAssets.add(asset);
        }
        final pag = json['pagination'];

        return BevisAssetPagination(
            assets: parsedAssets, pagination: Pagination.fromJson(pag));
      },
    );
  }

  @override
  Future<Response> renameAsset(
      {@required String assetId, @required String name}) async {
    final url = buildUri(path: '/api/lister-assets/' + assetId).toString();
    Dio dio = Dio();
    dio.options.headers = {
      'Content-Type': "application/json",
      'Authorization': "Bearer " + token
    };

    print("in renae " + name.toLowerCase());
    var dioResponse = await dio.put(url.toString(), data: {"name": name});
    print("in here rename" + dioResponse.toString());
    return dioResponse;
  }

  @override
  Future<Response> deleteAsset({String assetId}) async {
    final url = buildUri(path: '/api/lister-assets/' + assetId).toString();
    Dio dio = Dio();
    dio.options.headers = {
      'Content-Type': "application/json",
      'Authorization': "Bearer " + token
    };
    var dioResponse = await dio.delete(url.toString());
    return dioResponse;
  }
}
