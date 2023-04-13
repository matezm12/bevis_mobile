import 'package:bevis/data/models/topup/topup_region.dart';
import 'package:bevis/data/repositories/network_repositories/bevis_rest_repository_imp.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_repository/flutter_repository.dart';
import 'package:flutter_repository/clients/rest/rest_repository_client.dart';

class TopupRegionsNetworkRepositoryImp
    extends BevisRestRepositoryImp<TopupRegion> {
  TopupRegionsNetworkRepositoryImp(
      {@required RestRepositoryClient client,
      @required NetworkConfig networkConfig})
      : super(client: client, networkConfig: networkConfig);

  @override
  String get defaultRoute => 'api/topup-region';

  @override
  ItemCreator get getAllParseFunction => (json) {
        final data = json['data'];

        var parsedRegions = <TopupRegion>[];

        for (final regionJson in data) {
          parsedRegions.add(TopupRegion.fromJson(regionJson));
        }

        return parsedRegions;
      };
}
