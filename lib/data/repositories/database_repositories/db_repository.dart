import 'package:bevis/data/repositories/database_repositories/sqlite_db_repository.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';

class DatabaseRepositoryResult<ItemType>
    extends RepositoryResult<ItemType> {
  DatabaseRepositoryResult({ItemType resultValue, Error error})
      : super(resultValue: resultValue, error: error);
}

abstract class DatabaseRepository<ItemType> implements Repository<ItemType> {
  Future<SqliteDatabaseRepositoryResult<ItemType>> updateDbEntity(
      String id, String idKey, Map<String, dynamic> body);
}