// import 'package:bevis/data/repositories/network_repositories/network_config.dart';
// import 'package:http/http.dart' as http;
// import 'package:uri/uri.dart';
// import 'package:meta/meta.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'dart:convert';

// import '../network_repository.dart';
// export '../network_repository.dart';



// abstract class NetworkRepositoryHttpImp<ItemType>
//     implements NetworkRepository<ItemType> {
//   final UriBuilder _uriBuilder = UriBuilder();
//   final NetworkConfig _networkConfig;
//   final HttpRestClient _client;

//   NetworkRepositoryHttpImp({@required NetworkConfig networkConfig, @required RestRepositoryClient client})
//       : _networkConfig = networkConfig, _client = client {
//     _uriBuilder.scheme = networkConfig.apiScheme;
//     _uriBuilder.host = networkConfig.apiHost;
//     _uriBuilder.port = networkConfig.apiPort;
//   }

//   String get getAllRoute => null;
//   String get getOneRoute => null;
//   String get createRoute => null;
//   String get updateRoute => null;
//   String get deleteRoute => null;

//   String get defaultRoute => null;

//   @override
//   dynamic jsonParser(
//       {@required dynamic json, @required CollectionType collectionType}) {
//     switch (collectionType) {
//       case CollectionType.single:
//         final Map<String, dynamic> jsonMap = json;
//         return creator(jsonMap);
//       case CollectionType.collection:
//         final mapList = List<Map<String, dynamic>>.from(json);
//         var models = List<ItemType>();
//         for (final map in mapList) {
//           final model = creator(map);
//           models.add(model);
//         }
//         return models;
//       case CollectionType.paginableCollection:
//         var models = List<ItemType>();
//         final mapList = json['data'];
//         for (final map in mapList) {
//           final model = creator(map);
//           models.add(model);
//         }

//         return models;
//     }
//   }

//   Future<RestRepositoryResult<Page<ItemType>>> getPage(
//       int page, int pageSize,
//       [Map<String, String> queryParams]) async {
//     var params = queryParams != null ? queryParams : Map<String, String>();
//     params['page'] = page.toString();
//     params['pageSize'] = pageSize.toString();
//     final result = await getAll(params);
//     if (result.error != null) {
//       return RestRepositoryResult(
//           error: result.error, response: result.response);
//     }

//     final http.Response response = result.response;
//     List<ItemType> items = result.resultValue;
//     final metadataJson = jsonDecode(response.body)['pagination'];
//     final loadedPageMetadata = PageMetadata.fromJson(metadataJson);
//     final loadedPage = Page(data: items, metadata: loadedPageMetadata);
//     return RestRepositoryResult(value: loadedPage, response: response);
//   }

//   Future<RestRepositoryResult<List<ItemType>>> getAll(
//       [Map<String, String> queryParams]) async {
//     _uriBuilder.path = _buildUrlPathForRoute(Route.getAll);
//     _uriBuilder.queryParameters = queryParams;

//     var url = _uriBuilder.build().toString();
//     final decodedUrl = Uri.decodeFull(url);
//     print(decodedUrl);

//     var defaultHeaders = await getDefaultHeaders();
//     print(defaultHeaders);

//     final response = await http.get(decodedUrl, headers: defaultHeaders);
//     print(response.body);
//     var collectionType = CollectionType.collection;
//     if (queryParams != null && queryParams['page'] != null) {
//       collectionType = CollectionType.paginableCollection;
//     }

//     final List<ItemType> result =
//         _parseBody(responseBody: response.body, collectionType: collectionType);
//     return RestRepositoryResult(value: result, response: response);
//   }

//   Future<RestRepositoryResult<ItemType>> getOne(int id) async {
//     _uriBuilder.path = "${_buildUrlPathForRoute(Route.getOne)}/$id";
//     final url = _uriBuilder.build().toString();
//     final response = await http.get(url);

//     final result = _parseBody(
//         responseBody: response.body, collectionType: CollectionType.single);
//     return RestRepositoryResult(value: result, response: response);
//   }

//   Future<RestRepositoryResult<ItemType>> create(
//       Map<String, dynamic> body) async {
//     _uriBuilder.path = _buildUrlPathForRoute(Route.create);
//     final url = _uriBuilder.build().toString();
//     print("POST: $url");
//     var defaultHeaders = await getDefaultHeaders();
//     print("Headers: $defaultHeaders");
//     print("Body: $body");
//     final response =
//         await http.post(url, body: jsonEncode(body), headers: defaultHeaders);
//     print(response.body);
//     if (response.statusCode == 200) {
//       final result = _parseBody(
//           responseBody: response.body, collectionType: CollectionType.single);
//       return RestRepositoryResult(value: result, response: response);
//     } else {
//       return RestRepositoryResult(
//           response: response,
//           error: NetworkError(errorMsg: 'Something went wrong'));
//     }
//   }

//   Future<RestRepositoryResult<ItemType>> update(
//       dynamic id, Map<String, dynamic> body) async {
//     _uriBuilder.path = "${_buildUrlPathForRoute(Route.update)}/$id";
//     final url = _uriBuilder.build().toString();
//     print("PUT: $url");
//     var defaultHeaders = await getDefaultHeaders();
//     print("Headers: $defaultHeaders");
//     print("Body: $body");
//     final response =
//         await http.put(url, body: jsonEncode(body), headers: defaultHeaders);
//     print(response.body);
//     final result = _parseBody(
//         responseBody: response.body, collectionType: CollectionType.single);
//     return RestRepositoryResult(value: result, response: response);
//   }

//   Future<void> delete(int id) async {
//     _uriBuilder.path = _buildUrlPathForRoute(Route.delete);

//     final url = _uriBuilder.build().toString();
//     final response = await http.delete(url);
//     response.body
//     return RestRepositoryResult(value: null, response: response);
//   }

//   Future<RestRepositoryResult>performRequest({@required String url, @required String httpMethod, Map<String, dynamic> body}) {
//     var request = http.Request();
//     request.headers
//   }

//   String _buildUrlPathForRoute(Route route) {
//     if (defaultRoute != null) {
//       return defaultRoute;
//     }

//     switch (route) {
//       case Route.getAll:
//         return getAllRoute;
//       case Route.getOne:
//         return getOneRoute;
//       case Route.create:
//         return createRoute;
//       case Route.update:
//         return updateRoute;
//       case Route.delete:
//         return deleteRoute;
//     }
//   }

  // Uri buildUri(
  //     {@required String path,
  //     String scheme,
  //     String host,
  //     int port,
  //     Map<String, String> params}) {
  //   final UriBuilder uriBuilder = UriBuilder();
  //   uriBuilder.scheme = scheme ?? _networkConfig.apiScheme;
  //   uriBuilder.host = host ?? _networkConfig.apiHost;
  //   uriBuilder.port = port ?? _networkConfig.apiPort;
  //   uriBuilder.path = path;
  //   uriBuilder.queryParameters = params;
  //   return uriBuilder.build();
  // }

//   Future<Map<String, String>> getDefaultHeaders() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String jwtToken = prefs.getString('PREF_JWT_TOKEN');
//     var headers = {
//       'Content-type': 'application/json',
//       'Accept': 'application/json',
//     };
//     if (jwtToken != null) {
//       headers["Authorization"] = "Bearer " + jwtToken;
//     }
//     return headers;
//   }

//   dynamic _parseBody({String responseBody, CollectionType collectionType}) {
//     final decodedJson = jsonDecode(responseBody);
//     final model = jsonParser(json: decodedJson, collectionType: collectionType);
//     return model;
//   }
// }
