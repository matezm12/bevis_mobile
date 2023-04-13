import 'dart:convert';
import 'package:bevis/utils/notifications/notification_center.dart';
import 'package:bevis/utils/notifications/notification_events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_repository/clients/rest/rest_repository_client.dart';

import 'package:flutter_repository/network_repositories/network_config.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';
import 'package:flutter_repository/network_repositories/rest_repository_imp.dart';

import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

abstract class BevisRestRepositoryImp<ItemType>
    extends RestRepositoryImp<ItemType> {
  BevisRestRepositoryImp(
      {@required NetworkConfig networkConfig,
      @required RestRepositoryClient client})
      : super(networkConfig: networkConfig, client: client);

  @override
  Future<RestRepositoryResponse> performRequest(
      RestRepositoryRequest request) async {
    if (!kIsWeb) {
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;

      if (request.headers == null) {
        request.headers = {};
      }

      request.headers.addEntries([MapEntry('version-header', 'v$version')]);
    }

    return super.performRequest(request);
  }

  @override
  Future<RestRepositoryResult<ResponseType>> parseResponse<ResponseType>(
      {RestRepositoryResponse response, ItemCreator parseFunction}) async {
    print("here" + response.toString());
    if (response.statusCode == HttpStatus.upgradeRequired) {
      NotificationCenter.shared().eventBus.fire(AppUpgradeRequired());

      final bodyMap = jsonDecode(response.body);
      return RestRepositoryResult(
        response: response,
        error: NetworkError(
          type: bodyMap['type'],
          errorCode: response.statusCode,
          errorMsg: bodyMap['message'],
          errorTitle: bodyMap['error'],
        ),
      );
    }
    if (response.statusCode == HttpStatus.forbidden) {
      final bodyMap = jsonDecode(response.body);

      if (bodyMap['message'] == "Access Denied" && bodyMap['type'] == null) {
        NotificationCenter.shared().eventBus.fire(SessionExpired());
      }
    }
    if (response.statusCode == HttpStatus.conflict) {
      final bodyMap = jsonDecode(response.body);
      return RestRepositoryResult(
        response: response,
        error: NetworkError(
          type: bodyMap['type'],
          errorCode: response.statusCode,
          errorMsg: bodyMap['message'],
          errorTitle: bodyMap['error'],
        ),
      );
    }
    if (successfullStatusCodes.contains(response.statusCode)) {
      if (parseFunction == null) {
        return RestRepositoryResult<ResponseType>(response: response);
      }

      try {
        print("JSON Parse " + jsonDecode(response.body).toString());
        final json = jsonDecode(response.body);

        var parsedObject;
        if (json is List) {
          parsedObject = parseFunction({"data": json});
        } else {
          parsedObject = parseFunction(json);
        }

        print("in parsing");
        return RestRepositoryResult<ResponseType>(
            response: response, value: parsedObject);
      } catch (e) {
        print("pasing error" + e.toString());
      }
    } else {
      final bodyMap = jsonDecode(response.body);

      print("bodymap" + bodyMap.toString());
      return RestRepositoryResult<ResponseType>(
        response: response,
        error: NetworkError(
            type: bodyMap['type'],
            errorCode: response.statusCode,
            errorMsg: bodyMap["message"],
            errorTitle: bodyMap["type"]),
      );
    }

    return null;
  }

  @override
  Map<String, String> get defaultHeaders {
    var headers = super.defaultHeaders;
    headers['Accept'] = 'application/json';
    headers['Content-type'] = 'application/json';

    return headers;
  }
}
