import 'package:flutter/cupertino.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';

abstract class LoginNetworkRepository {
  Future<RestRepositoryResult> login({@required String email,@required String password,@required bool remeberMe});
  Future<RestRepositoryResult> loginWithSocial({@required String accessToken,@required String provider});

}