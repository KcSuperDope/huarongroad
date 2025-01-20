import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:huaroad/module/appliction/application_repository.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/rank/match/battle_invite_model.dart';
import 'package:huaroad/module/special_game/specail_game_data.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/route/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerJumpHandler {
  static Map<String, VoidCallback> pageConfig = {
    '1': () => Get.toNamed(Routes.special_page),
    '2': () => Get.toNamed(Routes.home_page, arguments: GameType.hrd),
    '3': () => Get.toNamed(Routes.level_page, arguments: GameType.hrd),
    '4': () => Get.toNamed(Routes.rank_matching_page, arguments: BattleInviteModel(type: 1)),
    '5': () => Get.toNamed(Routes.home_page, arguments: GameType.number3x3),
    '6': () => Get.toNamed(Routes.level_num_page, arguments: GameType.number3x3),
    '7': () => Get.toNamed(Routes.level_num_page, arguments: GameType.number4x4),
    '8': () => Get.toNamed(Routes.rank_matching_page, arguments: BattleInviteModel(type: 2)),
  };

  static List<String> toSpecialGamePageIds = ["101", "102", "103", "104", "105", "106", "107", "108", "109"];
  static List<String> toTopListPageIds = ["1011", "1021", "1031", "1041", "1051", "1061", "1071", "1081", "1091"];

  static void jump(BannerModel model) async {
    if (model.jumpType == "page") {
      if (model.jumpContent != null && model.jumpContent!.isNotEmpty) {
        final jumpContent = model.jumpContent!;
        if (pageConfig.keys.contains(jumpContent)) {
          pageConfig[jumpContent]!.call();
        } else if (toSpecialGamePageIds.contains(jumpContent)) {
          final index = int.parse(jumpContent[jumpContent.length - 1]) - 1;
          if (SpecialGameData.list.length <= index) return;
          Get.toNamed(Routes.special_game_page, arguments: SpecialGameData.list[index]);
        } else if (toTopListPageIds.contains(jumpContent)) {
          final index = int.parse(jumpContent[jumpContent.length - 2]) - 1;
          if (SpecialGameData.list.length <= index) return;
          Get.toNamed(Routes.top_list_page, arguments: {
            "mode": GameMode.famous,
            "type": GameType.hrd,
            "id": index,
            "name": (SpecialGameData.list[index].title ?? "").tr,
          });
        }
      }
    } else if (model.jumpType == "link") {
      if (model.jumpContent == null && model.jumpContent!.isEmpty) return;
      launchUrl(Uri.parse(model.jumpContent!));
    } else {
      NativeFlutterPlugin.instance.bannerJump({"jump_type": model.jumpType!, "jump_content": model.jumpContent});
    }
  }
}
