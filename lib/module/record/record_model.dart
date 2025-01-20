import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/protos/battle.pb.dart';

class RecordModel {
  String? name;
  String? avatar;
  String? userId;
  int? time;
  int? startTime;
  int? stepLength;
  int? stageId;
  int? reviewId;
  String? opening;
  GameMode? gameMode;
  GameType? gameType;
  int? result;
  int? device;
  msg_player_battle_result? blueResult;
  msg_player_battle_result? redResult;

  RecordModel(
      {this.name,
      this.avatar,
      this.userId,
      this.time,
      this.startTime,
      this.stepLength,
      this.stageId,
      this.reviewId,
      this.opening,
      this.gameMode,
      this.gameType,
      this.result,
      this.blueResult,
      this.redResult});

  static RecordModel fromJson({
    required Map<String, dynamic> data,
    required GameType gameType,
    required GameMode gameMode,
  }) {
    RecordModel model = RecordModel();
    model.stepLength = data["step"];
    model.time = data["time"];
    model.startTime = data["finishTime"];
    model.stageId = data["stageId"];
    model.reviewId = data["reviewId"];
    model.opening = data["opening"];
    model.gameType = gameType;
    model.gameMode = gameMode;
    model.result = data["result"];
    model.device = data["device"];
    if (data["blueResult"] != null) {
      model.blueResult = getBattleResult(data["blueResult"]);
    }
    if (data["redResult"] != null) {
      model.redResult = getBattleResult(data["redResult"]);
    }
    return model;
  }

  static msg_player_battle_result getBattleResult(dynamic json) {
    var player = msg_player_face_base.create();
    player.userId = $fixnum.Int64(json["player"]["userId"]);
    player.nickName = json["player"]["name"];
    player.avatar = json["player"]["avatar"];
    var result = msg_battle_result.create();
    result.result = json["result"]["result"];
    result.step = json["result"]["step"];
    result.time = json["result"]["time"];
    result.reviewId = $fixnum.Int64(json["result"]["reviewId"]);
    var battleResult = msg_player_battle_result.create();
    battleResult.player = player;
    battleResult.result = result;
    return battleResult;
  }
}
