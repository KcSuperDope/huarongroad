import 'package:huaroad/db/db_handler.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/hrd_game/hrd_game.dart';
import 'package:huaroad/module/game/num_game/num_game.dart';
import 'package:huaroad/net/http/dio_util.dart';
import 'package:huaroad/net/http/urls.dart';
import 'package:huaroad/plugin/model/report_event_model.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/util/logger.dart';

class GameRecordTool {
  static GameRecordTool? _instance;

  GameRecordTool._internal() {
    _instance = this;
  }

  factory GameRecordTool() => _instance ?? GameRecordTool._internal();

  /// 上传一把游戏
  Future<Map<String, dynamic>> upload(Game game) async {
    final url = ((game.type.value == GameType.hrd) ? Urls.post_stage_sync : Urls.post_stage_sync_num);
    int type = 1;
    int subApplicationId = 1;
    if (game.type.value == GameType.hrd) {
      type = (game.mode.value == GameMode.level ? 1 : (game.mode.value == GameMode.freedom ? 2 : 3));
      subApplicationId = game.mode.value == GameMode.famous ? 1 : (game.mode.value == GameMode.level ? 2 : 3);
    } else {
      type = (game.mode.value == GameMode.freedom ? 1 : (game.type.value == GameType.number3x3 ? 2 : 3));
      subApplicationId = game.mode.value == GameMode.freedom ? 3 : (game.type.value == GameType.number3x3 ? 5 : 6);
    }

    final userId = Global.userId;

    final data = game.type.value == GameType.hrd ? (game as HrdGame).toNetJson() : (game as NumGame).toNetJson();

    final Map<String, dynamic> params = {
      "userId": userId,
      "type": type,
      "stages": [data],
    };
    reportEvent(game.type.value == GameType.hrd ? 1 : 2, subApplicationId, data["device"],
        data["result"] == 0 ? 102 : 103, data["time"], data["step"], data["opening"], data["stageId"]);
    try {
      final result = await DioUtil().post(url, data: params);
      final data = result["data"].first;
      return data;
    } catch (e) {
      DBHandler().insertGame(game);
      LogUtil.d("$e----本局游戏上传失败，已存至本地");
      rethrow;
    }
  }

  /// 获取游戏记录
  Future<List<dynamic>> getRecordList(
      {required GameType gameType, required GameMode gameMode, required int pageIndex}) async {
    final userId = Global.userId;
    String url = '';
    int type = 1;

    if (gameMode == GameMode.rank) {
      url = Urls.POST_BATTLE_RECORD;
      type = gameType == GameType.number3x3 ? 2 : 1;
    } else {
      if (gameType == GameType.hrd) {
        url = Urls.get_record_list;
        type = gameMode == GameMode.level ? 1 : (gameMode == GameMode.freedom ? 2 : 3);
      } else {
        url = Urls.get_record_list_num;
        type = gameMode == GameMode.freedom ? 1 : (gameType == GameType.number3x3 ? 2 : 3);
      }
    }

    try {
      final result = await DioUtil().get(url
          .replaceAll(RegExp(r'{userId}'), userId)
          .replaceAll(RegExp(r'{type}'), type.toString())
          .replaceAll(RegExp(r'{page}'), pageIndex.toString()));
      final list = result["data"];
      return list;
    } catch (e) {
      LogUtil.d(e);
      rethrow;
    }
  }

  /// 获取记录详情
  Future<dynamic> getRecordDetail({required int reviewId}) async {
    final result = await DioUtil().get(Urls.get_record_detail.replaceAll(RegExp(r'{reviewId}'), reviewId.toString()));
    return result;
  }

  ///棋局埋点
  void reportEvent(int categoryId, int subApplicationId, int connectStatus, int gameStatus, int duration, int step,
      String gameId, int level) {
    GameEvent gameEvent = GameEvent(
        categoryId: categoryId,
        subApplicationId: subApplicationId,
        connectStatus: connectStatus,
        gameStatus: gameStatus,
        duration: duration,
        step: step,
        gameId: gameId,
        level: level);
    ReportEventModel reportEventModel = ReportEventModel(eventId: EventId.game, gameEvent: gameEvent);
    NativeFlutterPlugin.instance.reportEvent(reportEventModel);
  }
}
