import 'package:bevis/data/repositories/network_repositories/bevis_rest_repository_imp.dart';
import 'package:flutter_repository/network_repositories/network_config.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';
import 'package:flutter_repository/clients/rest/rest_repository_client.dart';
import 'package:meta/meta.dart';

import '../sign_up_network_repository.dart';

class SignUpNetworkRepositoryImp extends BevisRestRepositoryImp
    implements SignUpNetworkRepository {
  SignUpNetworkRepositoryImp(
      {@required RestRepositoryClient client,
      @required NetworkConfig networkConfig})
      : super(client: client, networkConfig: networkConfig);

  @override
  Future<RestRepositoryResult> singUp(
      {String firstName,
      String lastName,
      String email,
      String password}) async {
    final url = buildUri(path: '/api/register').toString();
    final request = RestRepositoryRequest(url: url, httpMethod: 'POST', body: {
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'email': email
    });
    final response = await performRequest(request);
    final result = await parseResponse(
      response: response,
    );
    return result;
  }

  @override
  Future<RestRepositoryResult> activateAccount({String code}) async {
    final url = buildUri(path: '/api/activate', params: {
      'key': code,
    }).toString();
    final request = RestRepositoryRequest(url: url, httpMethod: 'GET');
    final response = await performRequest(request);
    final result = await parseResponse(
      response: response,
    );
    return result;
  }

  @override
  Future<RestRepositoryResult> resetPasswordAccount({String email}) async {
    final url = buildUri(path: '/api/account/reset-password/init').toString();

    final request = RestRepositoryRequest(
        url: url, httpMethod: 'POST', body: {'email': email});
    final response = await performRequest(request);
    final result = await parseResponse(
      response: response,
    );

    return result;
  }

  @override
  Future<RestRepositoryResult> newPasswordAccount(
      {String code, String newPassword}) async {
    final url = buildUri(path: '/api/account/reset-password/finish').toString();

    final request = RestRepositoryRequest(
        url: url,
        httpMethod: 'POST',
        body: {'key': code, 'newPassword': newPassword});
    final response = await performRequest(request);
    final result = await parseResponse(
      response: response,
    );

    return result;
  }
}
