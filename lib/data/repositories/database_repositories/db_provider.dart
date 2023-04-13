import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static final DBProvider db = DBProvider._();

  String get databaseName => 'BEVIS.db';

  Database _database;

  DBProvider._();

  static const List<String> _initialScripts = [
    '''
  CREATE TABLE Asset (
              publicKey TEXT PRIMARY KEY,
              json TEXT
              );
'''
  ];

  static const List<String> _migrations = [
  ];

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);
    
    return await openDatabase(path, version: _migrations.length + 1,
        onCreate: (Database db, int verison) {
      _initialScripts.forEach((script) async => await db.execute(script));
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (var i = oldVersion - 1; i < newVersion - 1; i++) {
        await db.execute(_migrations[i]);
      }
    });
  }
}
