import 'package:flutter/cupertino.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';

abstract class TopUpNetworkRepository {
  Future<RestRepositoryResult> getPackages();
  Future<RestRepositoryResult> getPaymentHistory({int size, int page});
  Future<RestRepositoryResult> validatePurchase(
      {@required String purchaseId,
      @required String provider,
      @required String productId,
      @required String receiptData});
}
