import 'package:flutter/cupertino.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';

abstract class SignUpNetworkRepository {
  Future<RestRepositoryResult> singUp(
      {@required String firstName,
      @required String lastName,
      @required String email,
      @required String password});
  Future<RestRepositoryResult> activateAccount({@required String code});
  Future<RestRepositoryResult> resetPasswordAccount({@required String email});
  Future<RestRepositoryResult> newPasswordAccount(
      {@required String code, @required String newPassword});
}
