import 'package:flutter_repository/network_repositories/rest_repository.dart';

abstract class BalanceNetworkRepository {
  Future<RestRepositoryResult> getBalance();
}
