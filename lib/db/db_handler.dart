import 'package:huaroad/db/db_manager.dart';
import 'package:huaroad/db/db_sql.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/hrd_game/hrd_game.dart';
import 'package:huaroad/module/game/num_game/num_game.dart';
import 'package:sqflite/sqflite.dart';

class DBHandler {
  static DBHandler? _instance;

  DBHandler._internal() {
    _instance = this;
  }

  factory DBHandler() => _instance ?? DBHandler._internal();

  Future<List<Game>> queryRecordGame({required GameMode mode, required GameType type}) async {
    Database? db = await DBManager().getDatabase();
    List<Game> list = [];
    if (db != null) {
      final data = await db.query(
        SQLString.history,
        where: "mode = ? and type = ? and user_id = ?",
        whereArgs: [mode.index, type.index, Global.userId],
      );
      if (data.isNotEmpty) {
        for (var element in data) {
          Game game = Game.fromDBJson(element);
          list.add(game);
        }
      }
    }
    return list;
  }

  Future<bool> insertGame(Game g) async {
    Map<String, dynamic> data;
    if (g.type.value == GameType.hrd) {
      data = (g as HrdGame).toDBJson();
    } else {
      data = (g as NumGame).toDBJson();
    }
    Database? db = await DBManager().getDatabase();
    if (db != null) {
      return await db.insert(SQLString.history, data, conflictAlgorithm: ConflictAlgorithm.replace) != 0;
    }
    return false;
  }

  /// 插入一条闯关数据
  Future<bool> insertLevelData(Game g) async {
    Map<String, dynamic> data;
    if (g.type.value == GameType.hrd) {
      data = (g as HrdGame).toDBLevelJson();
    } else {
      data = (g as NumGame).toDBLevelJson();
    }
    Database? db = await DBManager().getDatabase();
    if (db != null) {
      return await db.insert(SQLString.level, data, conflictAlgorithm: ConflictAlgorithm.replace) != 0;
    }
    return false;
  }

  /// 查询闯关数据
  Future<List<Map<String, dynamic>>> queryLevelData({int? index, required GameType type}) async {
    Database? db = await DBManager().getDatabase();
    String where = "(type = ? and user_id = ?)";
    List whereArgs = [type.index, Global.userId];
    if (index != null) {
      where += " and l_index = ?";
      whereArgs.add(index);
    }
    if (db != null) {
      final data = await db.query(SQLString.level, where: where, whereArgs: whereArgs);
      return data;
    }
    return [];
  }

  /// 更新某局数据
  Future<bool> updateLevelData(Game g) async {
    Map<String, dynamic> data;
    if (g.type.value == GameType.hrd) {
      data = (g as HrdGame).toDBLevelJson();
    } else {
      data = (g as NumGame).toDBLevelJson();
    }
    Database? db = await DBManager().getDatabase();
    if (db != null) {
      final res = await db.update(
        SQLString.level,
        data,
        where: "l_index = ? and type = ? and user_id = ?",
        whereArgs: [g.index, g.type.value.index, Global.userId],
      );
      return res != 0;
    }
    return false;
  }

  /// 清空游戏数据
  Future<bool> clearAllGameData() async {
    Database? db = await DBManager().getDatabase();
    if (db != null) {
      final res = await db.delete(SQLString.history);
      return res != 0;
    }
    return false;
  }

  /// 清空闯关数据
  Future<bool> clearGameTypeLevelData({required GameType type}) async {
    Database? db = await DBManager().getDatabase();
    if (db != null) {
      final res = await db.delete(
        SQLString.level,
        whereArgs: [type.index, Global.userId],
        where: "type = ? and user_id = ?",
      );
      return res != 0;
    }
    return false;
  }

  /// 批量插入闯关数据
  Future<bool> insertGameTypeLevelData({required GameType type, required Map<String, dynamic> data}) async {
    Database? db = await DBManager().getDatabase();
    if (db != null) {
      final res = await db.insert(SQLString.level, data, conflictAlgorithm: ConflictAlgorithm.replace);
      return res != 0;
    }
    return false;
  }

  /// 所有名局记录
  Future<List<Map<String, dynamic>>> querySpecialData() async {
    Database? db = await DBManager().getDatabase();
    if (db != null) {
      final data = await db.query(SQLString.special, where: "user_id = ?", whereArgs: [Global.userId]);
      return data;
    }
    return [];
  }

  /// 更新名局数据
  Future<bool> updateSpecialData(HrdGame g) async {
    Map<String, dynamic> data = g.toDBSpecialJson();
    Database? db = await DBManager().getDatabase();
    if (db != null) {
      final res = await db.update(
        SQLString.special,
        data,
        where: "opening = ? and user_id = ?",
        whereArgs: [g.opening, Global.userId],
      );
      return res != 0;
    }
    return false;
  }

  /// 插入一条名局数据
  Future<bool> insertSpecialData(HrdGame g) async {
    Map<String, dynamic> data = g.toDBSpecialJson();
    Database? db = await DBManager().getDatabase();
    if (db != null) {
      return await db.insert(SQLString.special, data, conflictAlgorithm: ConflictAlgorithm.replace) != 0;
    }
    return false;
  }
}
