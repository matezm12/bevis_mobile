import 'package:flutter/foundation.dart';
import 'package:flutter_repository/network_repositories/network_config.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';
import 'package:flutter_repository/clients/rest/rest_repository_client.dart';

import '../bevis_rest_repository_imp.dart';
import '../login_network_repository.dart';

class LoginNetworkRepositoryImpl extends BevisRestRepositoryImp
    implements LoginNetworkRepository {
  LoginNetworkRepositoryImpl(
      {@required RestRepositoryClient client,
      @required NetworkConfig networkConfig})
      : super(client: client, networkConfig: networkConfig);

  @override
  Future<RestRepositoryResult> login(
      {String email, String password, bool remeberMe}) async {
    final url = buildUri(path: '/api/authenticate').toString();

    final request = RestRepositoryRequest(url: url, httpMethod: 'POST', body: {
      'password': password,
      'email': email,
      'rememberMe': true,
    });
    final response = await performRequest(request);
    print("here after login result" + response.body.toString());
    final result = await parseResponse(
      response: response,
    );

    return result;
  }

  @override
  Future<RestRepositoryResult> loginWithSocial(
      {String accessToken, @required String provider}) async {
    final url = buildUri(path: '/api/social/$provider/sign-up').toString();
    final request = RestRepositoryRequest(url: url, httpMethod: 'POST', body: {
      'accessToken': accessToken,
    });
    final response = await performRequest(request);
    final result = await parseResponse(
      response: response,
    );
    return result;
  }
}
