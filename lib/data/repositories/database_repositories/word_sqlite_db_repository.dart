// import 'package:easylang/data/domain/word.dart';
// import 'package:easylang/data/repository/sqlite/sqlite_db_repository.dart';
// import 'package:easylang/data/repository/word_repository.dart';
// import 'package:easylang/data/sqlite/db_provider.dart';

// class WordSqliteDatabaseRepositoryImpl extends SqliteDatabaseRepository<Word>
//     implements WordRepository {

//   WordSqliteDatabaseRepositoryImpl(DBProvider dbProvider) : super(dbProvider);

//   @override
//   String get tableName => "Word";

//   @override
//   ItemMap<Word> get entityToMap => (word) => word.toMap();

//   @override
//   MapToEntity<Word> get mapToEntity => (map) => Word.fromJson(map);

// }
