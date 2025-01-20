import 'dart:io';

import 'package:huaroad/db/db_sql.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {
  Database? myDatabase;

  static DBManager? _instance;

  DBManager._internal() {
    _instance = this;
  }

  factory DBManager() => _instance ?? DBManager._internal();

  Future<Database> initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'GAME.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
      onOpen: _onOpen,
    );
  }

  Future<Database?> getDatabase() async {
    if (myDatabase != null) return myDatabase;
    myDatabase = await initDB();
    return myDatabase;
  }

  Future<void> _onCreate(Database db, int version) async {
    _onVersion1(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    Batch batch = db.batch();
    if (oldVersion == 1) {
    } else if (oldVersion == 2) {
    } else if (oldVersion == 3) {}
    oldVersion++;
    //升级后版本还低于当前版本，继续递归升级
    if (oldVersion < newVersion) {
      _onUpgrade(db, oldVersion, newVersion);
    }
    await batch.commit();
  }

  Future<void> _onDowngrade(Database db, int oldVersion, int newVersion) async {
    Batch batch = db.batch();
    await batch.commit();
  }

  Future<void> _onOpen(Database db) async {}

  Future<void> _onVersion1(Database db) async {
    await db.execute(SQLString.createGameTable);
    await db.execute(SQLString.createLevelTable);
    await db.execute(SQLString.createSpecialTable);
  }
}
