import 'package:bevis/data/repositories/network_repositories/bevis_rest_repository_imp.dart';
import 'package:bevis/data/repositories/network_repositories/top_up_repository.dart';
import 'package:bevis/data/top_up/package.dart';
import 'package:bevis/data/top_up/payment_history.dart';
import 'package:bevis/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_repository/flutter_repository.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';
import 'package:flutter_repository/clients/rest/rest_repository_client.dart';

class TopUpNetworkRepositoryImpl extends BevisRestRepositoryImp
    implements TopUpNetworkRepository {
  TopUpNetworkRepositoryImpl(
      {@required RestRepositoryClient client,
      @required NetworkConfig networkConfig})
      : super(client: client, networkConfig: networkConfig);

  @override
  Future<RestRepositoryResult<List<CreditPackage>>> getPackages() async {
    final url = buildUri(path: 'api/credits-packages').toString();

    final request = RestRepositoryRequest(
        url: url,
        httpMethod: 'GET',
        headers: {"Authorization": "Bearer " + token});
    final response = await performRequest(request);
    print("here after packages result" + response.body.toString());
    return await parseResponse(
        response: response,
        parseFunction: (json) {
          print("JSON" + json.toString());
          final dataArr = json['data'];
          var packages = <CreditPackage>[];

          for (final packageJson in dataArr) {
            final package = CreditPackage.fromJson(packageJson);
            packages.add(package);
          }
          return packages;
        });
  }

  @override
  Future<RestRepositoryResult<PaymentHistoryPagination>> getPaymentHistory(
      {int size = 10, int page = 0}) async {
    final url = buildUri(
        path: 'api/balance/history',
        params: {"size": size.toString(), 'page': page.toString()}).toString();

    print(url);
    final request = RestRepositoryRequest(
        url: url,
        httpMethod: 'GET',
        body: {"size": 10, 'page': 0},
        headers: {"Authorization": "Bearer " + token});
    final response = await performRequest(request);
    print("here after history result" + response.body.toString());
    return await parseResponse(
        response: response,
        parseFunction: (json) {
          print("JSON" + json.toString());
          final dataArr = json['data'];

          var histories = <PaymentHistory>[];

          for (final historyJson in dataArr) {
            final package = PaymentHistory.fromJson(historyJson);
            histories.add(package);
          }
          final pag = json['pagination'];

          return PaymentHistoryPagination(
              paymentHistories: histories,
              pagination: Pagination.fromJson(pag));
        });
  }

  @override
  Future<RestRepositoryResult> validatePurchase(
      {String purchaseId,
      String provider,
      String productId,
      String receiptData}) async {
    final url = buildUri(path: '/api/balance/charge').toString();

    final request =
        RestRepositoryRequest(url: url, httpMethod: 'POST', headers: {
      "Authorization": "Bearer " + token
    }, body: {
      "params": {"receiptData": receiptData, "purchaseToken": receiptData},
      "productId": productId,
      "provider": provider,
      "purchaseId": purchaseId
    });
    final response = await performRequest(request);
    return await parseResponse(
        response: response,
        parseFunction: (json) {
          final dataArr = json['balance'];

          print("jsong" + dataArr.toString());
          return dataArr.toString();
        });
  }
}
