import 'package:get/get.dart';
import 'package:huaroad/assets/game_data/level_num_data.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/audio_palyer.dart';
import 'package:huaroad/module/ble/ble_data_handler.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/level/level_hard_handler.dart';
import 'package:huaroad/module/level/model/level_model.dart';
import 'package:huaroad/route/routes.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LevelNumController extends GetxController {
  final currentHard = "${S.Stage.tr}1".obs;
  final currentHardIndex = 1.obs;
  final currentLevelIndex = 1.obs;

  final gameType = (Get.arguments != null ? Get.arguments! as GameType : GameType.hrd).obs;

  final openings = <String>[].obs;
  final items = <LevelItemModel>[].obs;
  final treeList = <LevelTreeModel>[].obs;

  final localData = <Map<String, dynamic>>[].obs;

  final ItemScrollController itemScrollController = ItemScrollController();

  final regPng = [6, 1, 2, 3, 4, 5];
  final reg = [
    [1, 2, 3],
    [-1, 5, 4],
    [-1, 6, 7],
    [10, 9, 8],
    [11, 12, -1],
    [14, 13, -1],
  ];

  @override
  void onInit() async {
    super.onInit();
    initData();
    sendLevel();
  }

  void sendLevel() {
    Future.delayed(const Duration(milliseconds: 500), () {
      BleDataHandler().sendLevel(gameType.value);
    });
  }

  @override
  void onClose() {
    super.onClose();
    BleDataHandler().currentGame = null;
  }

  void onTapLevelItem({required LevelItemModel item}) {
    if (item.index > LevelHardHandler().lastLevel.value) {
      HRAudioPlayer().playCannotClick();
      return;
    }

    Get.toNamed(Routes.level_game_page, arguments: item);
  }

  void initData() async {
    if (gameType.value == GameType.number3x3) {
      openings.addAll(LevelNumData.num3x3);
    }
    if (gameType.value == GameType.number4x4) {
      openings.addAll(LevelNumData.num4x4);
    }

    items.value = initTotalItems(openings);
    treeList.value = initTotalTreeModel(items);

    await updateNewLevel(isFirst: true);

    currentHard.value = LevelHardHandler().lastHard.value;
    currentHardIndex.value = LevelHardHandler().lastHardIndex.value;
    currentLevelIndex.value = LevelHardHandler().lastLevel.value;
  }

  List<LevelItemModel> initTotalItems(List<String> openings) {
    final list = <LevelItemModel>[];
    for (int i = 0; i < openings.length; i++) {
      LevelItemModel lm = LevelItemModel();
      lm.index = i + 1;
      lm.type = gameType.value;
      lm.opening = openings[i];
      lm.pngName = "lib/assets/png/level/level_item_bg_num${gameType.value == GameType.number3x3 ? "" : "_middle"}.png";
      lm.width = ratio(80);
      lm.height = ratio(90);
      list.add(lm);
    }
    return list;
  }

  List<LevelTreeModel> initTotalTreeModel(List<LevelItemModel> items) {
    int index = 0;
    final list = <LevelTreeModel>[];
    while (index < items.length) {
      if (index == 0 || index % 14 == 0) {
        for (var element in reg) {
          final List<LevelItemModel> treeList = [];
          for (var el1 in element) {
            if (el1 == -1) {
              LevelItemModel empty = LevelItemModel();
              empty.empty = true;
              treeList.add(empty);
            } else {
              if ((el1 - 1) + index < items.length) {
                treeList.add(items[index + (el1 - 1)]);
              } else {
                break;
              }
            }
          }
          int sectionIndex = reg.indexOf(element);
          int pngIndex = list.isNotEmpty ? regPng[sectionIndex] : 0;
          LevelTreeModel tm = LevelTreeModel();
          tm.items = treeList;
          tm.bgName = "lib/assets/png/level/level_line_bg_${pngIndex}_num.png";
          tm.showCartoon = pngIndex != 0;
          tm.cartoonName = "lib/assets/png/level/level_cartoon_num_$pngIndex.png";
          tm.height = list.isEmpty ? ratio(140 + 26) : ratio(140);
          list.add(tm);
        }
      }
      index += 14;
    }

    ///底部背景图
    LevelTreeModel tm = LevelTreeModel();
    tm.isLastBottom = true;
    tm.showCartoon = false;
    tm.bgName = "lib/assets/png/level/level_line_bg_${gameType.value == GameType.number3x3 ? 1 : 6}_num.png";
    list.add(tm);

    return list;
  }

  Future<void> updateNewLevel({int index = -1, bool isFirst = false}) async {
    /// 重新请求数据库
    await LevelHardHandler().update(type: gameType.value);

    /// 更新某关数据
    if (index > 0) {
      final levelItem = items[index - 1];
      levelItem.starNum.value = LevelHardHandler().starNumList[index - 1];
    } else {
      /// 更新全部数据
      final starData = LevelHardHandler().starNumList;
      for (int i = 0; i < items.length; i++) {
        items[i].starNum.value = i < starData.length ? starData[i] : 0;
      }
    }

    /// 滑动到当前关卡;
    scrollToLevel(level: LevelHardHandler().lastLevel.value, isFirst: isFirst);
  }

  /// 滚动到当前 (是否是起始位置)
  void scrollToLevel({required int level, bool isFirst = false}) {
    if (level > openings.length) return;
    LevelTreeModel model = treeList.firstWhere((p0) => p0.items.map((e) => e.index).toList().contains(level));
    final index = treeList.indexOf(model);

    if (isFirst) {
      Future.delayed(const Duration(milliseconds: 300), () {
        itemScrollController.scrollTo(index: index, duration: const Duration(milliseconds: 50));
      });
    } else {
      itemScrollController.scrollTo(index: index, duration: const Duration(milliseconds: 120));
    }
  }

  double ratio(double val) {
    return Get.width / 375 * val;
  }
}
