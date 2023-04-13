import 'package:bevis/data/repositories/database_repositories/db_repository.dart';
import 'package:bevis/data/repositories/database_repositories/db_provider.dart';
import 'package:flutter_repository/repository.dart';

typedef Map<String, dynamic> ItemMap<S>(S entity);

typedef S MapToEntity<S>(Map<String, dynamic> map);

class SqliteDatabaseRepositoryResult<ItemType>
    extends DatabaseRepositoryResult<ItemType> {
  SqliteDatabaseRepositoryResult({ItemType resultValue, Error error})
      : super(resultValue: resultValue, error: error);
}

abstract class SqliteDatabaseRepository<ItemType>
    implements DatabaseRepository<ItemType> {
  final DBProvider _dbProvider;

  SqliteDatabaseRepository(this._dbProvider);

  DBProvider get databaseProvider => _dbProvider;

  @override
  Future<SqliteDatabaseRepositoryResult<ItemType>> create(
      Map<String, dynamic> body) async {
    var db = await _dbProvider.database;

    var fields = body.keys.reduce((value, element) => value + "," + element);

    var fieldsTemplate = body.keys
        .reduce((value, element) => value[0] == "." ? value + ",?" : ".?,?")
        .substring(1);

    var values = body.keys.map((key) => body[key]).toList();

    var sqlQuery = "INSERT Into " +
        tableName +
        "(" +
        fields +
        ")"
            " VALUES (" +
        fieldsTemplate +
        ")";
    print("Prepared sql query: [$sqlQuery] with values $values");
    var rawId = await db.rawInsert(sqlQuery, values);
    print("Created entity with id $rawId");
    return SqliteDatabaseRepositoryResult(resultValue: mapToEntity(body));
  }

  @override
  Future<SqliteDatabaseRepositoryResult<List<ItemType>>> getAll(
      [Map<String, dynamic> queryParams]) async {
    final db = await _dbProvider.database;
    var res = await db.query(tableName);
    List<ItemType> list =
        res.isNotEmpty ? res.map((c) => mapToEntity(c)).toList() : <ItemType>[];
    print("Loaded from SQLite : $list");
    return SqliteDatabaseRepositoryResult(resultValue: list);
  }

  @override
  Future<RepositoryResult<ItemType>> delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future<SqliteDatabaseRepositoryResult<ItemType>> getOne(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<SqliteDatabaseRepositoryResult<MPage<ItemType>>> getPage(
      int page, int pageSize,
      [Map<String, String> queryParams]) async {
    throw UnimplementedError();
  }

  @override
  Future<SqliteDatabaseRepositoryResult<ItemType>> update(
      dynamic id, Map<String, dynamic> body) async {
    throw UnimplementedError();
  }

  Future<SqliteDatabaseRepositoryResult<ItemType>> updateDbEntity(
      String id, String idKey, Map<String, dynamic> body) async {
    ItemType entity = mapToEntity(body);
    Map<String, dynamic> entityMap = entityToMap(entity);

    var db = await _dbProvider.database;
    String params = "";
    body.forEach((key, value) {
      if (key == idKey) {
        return key;
      }
      if (value is String) {
        var v = value.replaceAll("'", "''");
        return params += "$key = '$v',";
      } else {
        return params += "$key = $value,";
      }
    });
    params = params.substring(0, params.length - 1);
    db.update(
      tableName,
      body,
      where: idKey + "=\"" + id + "\"",
    );
    // var sql = "UPDATE " +
    //     tableName +
    //     " SET " +
    //     params +
    //     " WHERE publicKey = " +
    //     id;
    // print("Raw query SQLite : $sql");
    // await db.rawUpdate(sql);
    print("Updated entity with id $id");
    return SqliteDatabaseRepositoryResult(resultValue: mapToEntity(entityMap));
  }

  String get tableName;

  ItemMap<ItemType> get entityToMap;

  MapToEntity<ItemType> get mapToEntity;
}
