import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/protos/battle.pb.dart';

class RankReportModel {
  msg_player_battle_result? blueResult;
  msg_player_battle_result? redResult;
  bool? owner;
  bool? inviteSuccess;
  GameType? gameType;
  String? opening;
  int? finishTime;

  RankReportModel(
      {this.blueResult,
      this.redResult,
      this.gameType,
      this.owner = true,
      this.inviteSuccess = false,
      this.finishTime,
      this.opening});
}
