import 'package:get/get.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/rank/match/rank_match_controller.dart';
import 'package:huaroad/module/rank/report/rank_report_model.dart';
import 'package:huaroad/module/record/record_model.dart';
import 'package:huaroad/module/record/record_replay_page.dart';
import 'package:huaroad/protos/battle.pb.dart';

class RankReportController extends GetxController {
  RankReportModel reportModel = Get.arguments;

  void onMoreRound() {
    Get.back();
    if (!reportModel.inviteSuccess!) {
      Get.find<RankMatchController>().startMatch();
    }
  }

  void toReplayPage(msg_player_battle_result result) {
    RecordModel model = RecordModel(
        name: result.player.nickName,
        avatar: result.player.avatar,
        userId: result.player.userId.toString(),
        time: result.result.time,
        stepLength: result.result.step,
        reviewId: result.result.reviewId.toInt(),
        opening: reportModel.opening,
        startTime: reportModel.finishTime! ~/ 1000,
        gameMode: GameMode.rank,
        gameType: reportModel.gameType);
    Get.to(() => RecordReplayPage(), arguments: model);
  }
}
