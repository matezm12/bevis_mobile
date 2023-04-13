import 'package:bevis/data/models/asset.dart';
import 'package:bevis/data/repositories/asset_repository.dart';
import 'package:bevis/data/repositories/database_repositories/db_repository.dart';

abstract class AssetDatabaseRepository implements AssetRepository {
  Future<DatabaseRepositoryResult<Asset>> getAssetByPublicKey(String publicKey);
  Future<DatabaseRepositoryResult<int>> deleteAssetByPublicKey(
      String publicKey);

  Future<DatabaseRepositoryResult<int>> deleteAll();
}
