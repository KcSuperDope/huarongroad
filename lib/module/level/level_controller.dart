import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:huaroad/assets/game_data/level_openning_data.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/audio_palyer.dart';
import 'package:huaroad/common/bg_dialog.dart';
import 'package:huaroad/module/ble/ble_data_handler.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/level/level_hard_handler.dart';
import 'package:huaroad/module/level/model/level_model.dart';
import 'package:huaroad/route/routes.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LevelController extends GetxController {
  final currentHard = "${S.Stage.tr}1".obs;
  final currentHardIndex = 1.obs;
  final currentLevelIndex = 1.obs;

  final gameType = (Get.arguments != null ? Get.arguments! as GameType : GameType.hrd).obs;

  final openings = <String>[].obs;
  final items = <LevelItemModel>[].obs;
  final treeList = <LevelTreeModel>[].obs;
  final localData = <Map<String, dynamic>>[].obs;
  final ItemScrollController itemScrollController = ItemScrollController();

  final sectionPageHeight = (26.0 + 140.0 * 17 + 220.0) * Get.width / 375.0;

  final regPng = [0, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 7];
  final reg = [
    [1, 2, 3],
    [-1, 5, 4],
    [-1, 6, 7],
    [10, 9, 8],
    [11, 12, -1],
    [14, 13, -1],
    [15, 16, 17],
    [-1, 19, 18],
    [-1, 20, 21],
    [24, 23, 22],
    [25, 26, -1],
    [28, 27, -1],
    [29, 30, 31],
    [-1, 33, 32],
    [-1, 34, 35],
    [38, 37, 36],
    [39, -1, -1],
    [-1, 40, -1],
  ];

  int _lastLevel = 0;

  @override
  void onInit() async {
    super.onInit();
    initData();
    sendLevel();
  }

  void sendLevel() {
    Future.delayed(const Duration(milliseconds: 500), () {
      BleDataHandler().sendLevel(GameType.hrd);
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

  void changeLevel(BottomSheetModel levelModel) {
    if (levelModel.index <= LevelHardHandler().lastHardIndex.value) {
      currentHard.value = levelModel.left;
      currentHardIndex.value = levelModel.index;
      scrollToLevel(level: levelModel.startLevel);
    }
  }

  void initData() async {
    openings.addAll(GameLevelOpening.data107);
    openings.addAll(GameLevelOpening.oneHundredTen.sublist(0, 440));

    items.value = initTotalItems(openings);
    treeList.value = initTotalTreeModel(items);

    await updateNewLevel(isFirst: true);

    currentHard.value = LevelHardHandler().lastHard.value;
    currentHardIndex.value = LevelHardHandler().lastHardIndex.value;
    currentLevelIndex.value = LevelHardHandler().lastLevel.value;

    _lastLevel = currentLevelIndex.value;
  }

  List<LevelItemModel> initTotalItems(List<String> openings) {
    final list = <LevelItemModel>[];
    for (int i = 0; i < openings.length; i++) {
      LevelItemModel lm = LevelItemModel();
      lm.index = i + 1;
      lm.type = gameType.value;
      lm.opening = openings[i];
      lm.isBoss = lm.index % 40 == 0;
      lm.isLevelLast = LevelHardHandler().hrdLevelLastReg.contains(lm.index);
      lm.width = ratio(80);
      lm.height = ratio(80);
      if (lm.isLevelLast) {
        lm.pngName = "lib/assets/png/level/level_item_bg_middle.png";
      }
      if (lm.isBoss) {
        lm.pngName = "lib/assets/png/level/level_big_town.png";
      }
      list.add(lm);
    }
    return list;
  }

  List<LevelTreeModel> initTotalTreeModel(List<LevelItemModel> items) {
    int index = 0;
    final list = <LevelTreeModel>[];
    while (index < items.length) {
      if (index == 0 || index % 40 == 0) {
        bool isBoss = false;
        for (var element in reg) {
          final List<LevelItemModel> treeList = [];
          for (var el1 in element) {
            if (el1 + index > items.length) break;
            if (el1 == -1) {
              LevelItemModel empty = LevelItemModel();
              empty.empty = true;
              treeList.add(empty);
            } else {
              isBoss = (index + el1) % 40 == 0;
              treeList.add(items[index + (el1 - 1)]);
            }
          }
          int sectionIndex = reg.indexOf(element);
          int pngIndex = regPng[sectionIndex];
          LevelTreeModel tm = LevelTreeModel();
          tm.isBoss = isBoss;
          tm.items = treeList;
          tm.isEnd = regPng[sectionIndex] == 7;
          tm.bgName = "lib/assets/png/level/level_line_bg_$pngIndex${list.isEmpty ? "_first" : ""}.png";
          tm.showCartoon = [1, 2, 3, 4, 5, 6].contains(pngIndex) && sectionIndex != 16;
          tm.cartoonName = "lib/assets/png/level/level_cartoon_hrd_$pngIndex.png";
          tm.height = tm.isEnd ? ratio(220) : (list.isEmpty ? ratio(140 + 26) : ratio(140));
          list.add(tm);
        }
      }
      index += 40;
    }
    return list;
  }

  Future<void> updateNewLevel({int index = -1, bool isFirst = false}) async {
    /// 刷新数据
    await LevelHardHandler().update(type: gameType.value);

    currentHard.value = LevelHardHandler().lastHard.value;
    currentHardIndex.value = LevelHardHandler().lastHardIndex.value;
    currentLevelIndex.value = LevelHardHandler().lastLevel.value;

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

  void onUnlockSolutions(int index) async {
    await Future.delayed(500.milliseconds);
    final old = unlockHard(_lastLevel);
    final current = unlockHard(index);
    if (current > old) {
      Get.dialog(
        barrierDismissible: false,
        BgDialog(
          title: S.ThesolutionapproachforDifficultyN,
          leftText: S.Cancel,
          rightText: S.OK,
          extraArgs: current,
          onTapRight: () {
            Get.toNamed(Routes.game_desc_page, arguments: {"type": GameType.hrd, "hard": current});
          },
        ),
      );
    }
  }

  int unlockHard(int index) {
    int res = 1;
    if (index < 20) {
      res = 1;
    } else if (index >= 20 && index < 40) {
      res = 2;
    } else {
      res = (index ~/ 40) + 2;
    }
    return min(9, res);
  }
}
