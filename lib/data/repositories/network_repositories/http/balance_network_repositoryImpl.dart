import 'package:bevis/data/repositories/network_repositories/bevis_rest_repository_imp.dart';
import 'package:bevis/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_repository/clients/rest/rest_repository_client.dart';
import 'package:flutter_repository/network_repositories/network_config.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';

import '../balance_network_repository.dart';

class BalanceNetworkRepositoryImpl extends BevisRestRepositoryImp
    implements BalanceNetworkRepository {
  BalanceNetworkRepositoryImpl(
      {@required RestRepositoryClient client,
      @required NetworkConfig networkConfig})
      : super(client: client, networkConfig: networkConfig);

  @override
  Future<RestRepositoryResult<String>> getBalance() async {
    final url = buildUri(path: '/api/balance').toString();

    final request = RestRepositoryRequest(
        url: url,
        httpMethod: 'GET',
        headers: {"Authorization": "Bearer " + token});
    final response = await performRequest(request);
    print("balance" + response.body.toString());
    return await parseResponse(
      response: response,
      parseFunction: (json) {
        final dataArr = json['balance'];

        print("jsong" + dataArr.toString());
        return dataArr.toString();
      },
    );
  }
}
