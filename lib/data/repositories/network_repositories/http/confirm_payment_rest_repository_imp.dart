import 'dart:io';
import 'package:async/async.dart';

import 'package:bevis/data/models/topup/topup_order.dart';
import 'package:bevis/data/repositories/network_repositories/bevis_rest_repository_imp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_repository/network_repositories/network_config.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';
import 'package:flutter_repository/clients/rest/rest_repository_client.dart';
import 'package:http/http.dart';

class ConfirmPaymentRestRepositoryImp extends BevisRestRepositoryImp<TopupOrder> {
  ConfirmPaymentRestRepositoryImp(
      {@required NetworkConfig networkConfig,
      @required RestRepositoryClient client})
      : super(networkConfig: networkConfig, client: client);

  Future<RestRepositoryResult<TopupOrder>> uploadFileForOrder(
      {@required int orderId,
      @required String fileName,
      @required File file}) async {
    final url = buildUri(path: '/api/topup/order/$orderId/file');
    var stream = ByteStream(DelegatingStream(file.openRead()).cast());
    final length = await file.length();
    var uploadRequest = MultipartRequest('PUT', url);

    final multipartFile =
        MultipartFile('file', stream, length, filename: fileName);
    uploadRequest.files.add(
      multipartFile,
    );
    final response = await uploadRequest.send();
    if (response.statusCode == 200) {
      return RestRepositoryResult(
        response: response,
      );
    } else {
      return RestRepositoryResult(
          response: response,
          error: NetworkError(errorMsg: 'Something went wrong!'));
    }
  }
}
