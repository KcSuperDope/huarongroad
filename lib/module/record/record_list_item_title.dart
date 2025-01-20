import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/record/record_model.dart';
import 'package:huaroad/module/special_game/specail_game_data.dart';

class RecordListItemTitle {
  static String handle(RecordModel model) {
    String name = model.stageId.toString();
    if (model.gameMode == GameMode.famous && model.stageId != null) {
      name = model.stageId! < SpecialGameData.list.length ? SpecialGameData.list[model.stageId!].title! : "--";
    } else if (model.gameMode == GameMode.level) {
      name = S.Lv.trArgs([model.stageId.toString()]);
    }
    return name;
  }
}
