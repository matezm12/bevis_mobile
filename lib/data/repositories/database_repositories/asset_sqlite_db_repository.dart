import 'package:bevis/data/models/asset.dart';
import 'package:bevis/data/repositories/database_repositories/asset_db_repository.dart';
import 'package:bevis/data/repositories/database_repositories/db_provider.dart';
import 'package:bevis/data/repositories/database_repositories/db_repository.dart';
import 'package:bevis/data/repositories/database_repositories/sqlite_db_repository.dart';

class AssetSqliteDatabaseRepositoryImpl extends SqliteDatabaseRepository<Asset>
    implements AssetDatabaseRepository {
  AssetSqliteDatabaseRepositoryImpl(DBProvider dbProvider) : super(dbProvider);

  Future<SqliteDatabaseRepositoryResult<Asset>> getAssetByPublicKey(
      String publicKey) async {
    final db = await databaseProvider.database;
    var res = await db
        .query(tableName, where: 'publicKey = ?', whereArgs: [publicKey]);
    if (res.isNotEmpty) {
      final asset = mapToEntity(res.first);
      return SqliteDatabaseRepositoryResult(resultValue: asset, error: null);
    }

    return SqliteDatabaseRepositoryResult(resultValue: null, error: null);
  }

  Future<SqliteDatabaseRepositoryResult<int>> deleteAssetByPublicKey(
      String publicKey) async {
    final db = await databaseProvider.database;
    final deleteQuery = 'DELETE FROM $tableName WHERE publicKey = ?';
    final count = await db.rawDelete(deleteQuery, [publicKey]);
    return SqliteDatabaseRepositoryResult(resultValue: count);
  }

  @override
  String get tableName => "Asset";

  @override
  ItemMap<Asset> get entityToMap => (asset) => asset.toDbMap();

  @override
  MapToEntity<Asset> get mapToEntity => (map) {
        Map<String, dynamic> json = Map<String, dynamic>.from(map);
        if (json['hasTokens'] != null) {
          json['hasTokens'] = json['hasTokens'] == 1;
        }

        return Asset.fromDatabaseMap(json);
      };

  @override
  Future<DatabaseRepositoryResult<int>> deleteAll() async {
    final db = await databaseProvider.database;
    final deleteQuery = 'DELETE FROM $tableName';
    final count = await db.rawDelete(deleteQuery);
    return SqliteDatabaseRepositoryResult(resultValue: count);
  }
}
