import 'package:bevis/data/models/topup/topup_order.dart';
import 'package:bevis/data/repositories/network_repositories/bevis_rest_repository_imp.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_repository/network_repositories/network_config.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';
import 'package:flutter_repository/clients/rest/rest_repository_client.dart';

class TopupOverviewRestRepositoryImp extends BevisRestRepositoryImp<TopupOrder> {
  TopupOverviewRestRepositoryImp(
      {@required NetworkConfig networkConfig,
      @required RestRepositoryClient client})
      : super(networkConfig: networkConfig, client: client);

  @override
  String get defaultRoute => '/api/topup/order';

  @override
  ItemCreator get defaultParseFunction => (json) => TopupOrder.fromJson(json);
}
