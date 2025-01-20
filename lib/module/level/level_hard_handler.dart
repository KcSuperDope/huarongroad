import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/db/db_handler.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/level/level_controller.dart';
import 'package:huaroad/module/level/level_num_controller.dart';
import 'package:huaroad/util/bottom_hard_sheet.dart';

enum SheetPage { home, level, rank }

class LevelHardHandler {
  static LevelHardHandler? _instance;

  LevelHardHandler._internal() {
    _instance = this;

    initData();
  }

  factory LevelHardHandler() => _instance ?? LevelHardHandler._internal();

  late BottomSheetModel infiniteModel;

  final lastLevel = 1.obs; //当前关卡
  final lastHard = "${S.Stage.tr}1".obs; // 当前难度
  final lastHardIndex = 1.obs; // 当前难度
  final totalStarNum = 0.obs; // 总星星数
  final hrdBottomSheetItemList = <BottomSheetModel>[];
  final numBottomSheetItemList = <BottomSheetModel>[];
  List starNumList = [];

  final hrdLevelReg = [20, 20, 40, 40, 40, 40, 40, 40, 40, 60, 60, 60, 60];
  final hrdLevelLastReg = [20, 380, 500]; //难度二级关
  final hrdLevelBossReg = [40, 80, 120, 160, 200, 240, 280, 320, 440, 560]; //难度boss关
  final unLimited = 560;

  void initData() {
    /// hrd

    int tag = 0;
    for (int i = 1; i <= 13; i++) {
      int num = hrdLevelReg[i - 1];
      BottomSheetModel bsm = BottomSheetModel();
      bsm.index = i;
      bsm.left = "${S.Stage.tr}$i";
      bsm.startLevel = tag + 1;
      bsm.endLevel = tag + num;
      bsm.center = S.Lv.trArgs(['${bsm.startLevel}-${bsm.endLevel}']);
      bsm.totalStarNum = num * 3;
      bsm.right = "";
      hrdBottomSheetItemList.add(bsm);
      tag += num;
    }

    infiniteModel = createInfiniteModel();
    hrdBottomSheetItemList.add(infiniteModel);

    /// num
    BottomSheetModel numModel1 = BottomSheetModel();
    numModel1.index = 1;
    numModel1.left = "3x3";
    numModel1.center = S.Lv.trArgs(['1-30']);

    BottomSheetModel numModel2 = BottomSheetModel();
    numModel2.index = 2;
    numModel2.left = "4*4";
    numModel2.center = S.Lv.trArgs(['30-999']);
    numModel2.totalStarNum = 2910;

    numBottomSheetItemList.add(numModel1);
    numBottomSheetItemList.add(numModel2);
  }

  Future<void> syncDeviceLevel({
    required GameType gameType,
    required List stars,
    bool updatePage = true,
  }) async {
    Completer completer = Completer();
    await DBHandler().clearGameTypeLevelData(type: gameType);
    if (stars.isNotEmpty) {
      for (int i = 0; i < stars.length; i++) {
        final Map<String, dynamic> data = {};
        data["user_id"] = Global.userId;
        data["l_index"] = i + 1;
        data["starNum"] = stars[i].toString();
        data["type"] = gameType.index;
        await DBHandler().insertGameTypeLevelData(type: gameType, data: data);
      }
    }

    if (updatePage) {
      if (gameType == GameType.hrd) {
        Get.find<LevelController>().updateNewLevel();
      } else {
        Get.find<LevelNumController>().updateNewLevel();
      }
    }
    completer.complete();
    return completer.future;
  }

  Future<void> update({required GameType type}) async {
    Completer completer = Completer();

    List<Map<String, dynamic>> list = [];
    final data = await DBHandler().queryLevelData(type: type);
    if (data.isNotEmpty) {
      list.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
        final aNum = a["l_index"];
        final bNum = b["l_index"];
        if (aNum > bNum) {
          return 1;
        } else {
          return -1;
        }
      });
    }

    list.addAll(data);

    /// 当前关卡
    lastLevel.value = min(list.length + 1, type == GameType.hrd ? 1000 : (type == GameType.number3x3 ? 300 : 700));

    /// 最大解锁难度
    if (type == GameType.hrd) {
      if (lastLevel.value > unLimited) {
        lastHard.value = S.infinitestages;
        lastHardIndex.value = 14;
      } else {
        lastHardIndex.value = getHardIndex(lastLevel.value);
        lastHard.value = "${S.Stage.tr}${lastHardIndex.value}";
      }
    } else {
      if (lastLevel.value >= 300) {
        lastHard.value = "4x4";
        lastHardIndex.value = 2;
      } else {
        lastHard.value = "3x3";
        lastHardIndex.value = 1;
      }
    }

    /// 总星星数量
    totalStarNum.value = 0;
    for (var element in hrdBottomSheetItemList) {
      element.starNum = 0;
    }
    for (var element in numBottomSheetItemList) {
      element.starNum = 0;
    }
    List totalNumList = list.map((e) => e["starNum"]).toList();
    starNumList = totalNumList;
    int hardIndex = 0;
    if (type == GameType.hrd) {
      for (int i = 0; i < totalNumList.length; i++) {
        int level = i + 1;
        int starNum = totalNumList[i];
        totalStarNum.value += starNum;
        hrdBottomSheetItemList[getHardIndex(level) - 1].starNum += starNum;
      }

      for (var element in hrdBottomSheetItemList) {
        if (element.index <= lastHardIndex.value) {
          element.right = "${element.starNum}/${element.totalStarNum}";
          element.rightImage = "lib/assets/png/level/star_small_s.png";
          element.showStar = true;
        } else {
          element.right = S.WaitUnLocked.tr;
          element.rightImage = "lib/assets/png/level/level_bottom_lock.png";
          element.showStar = false;
        }
      }
    } else {
      for (int i = 0; i < totalNumList.length; i++) {
        int index = i + 1;
        int starNum = totalNumList[i];
        totalStarNum.value += starNum;
        if (index <= 300) {
          hardIndex = 0;
        } else {
          hardIndex = 1;
        }
        numBottomSheetItemList[hardIndex].starNum += starNum;
      }

      for (var element in numBottomSheetItemList) {
        if (element.index <= lastHardIndex.value) {
          element.right = "${element.starNum}/${element.totalStarNum}";
          element.rightImage = "lib/assets/png/level/star_small_s.png";
        }
      }
    }

    completer.complete();
    return completer.future;
  }

  /// 根据关卡获取对应的难度
  int getHardIndex(int level, {GameType gameType = GameType.hrd}) {
    if (gameType == GameType.number3x3) {
      return 1;
    }

    if (gameType == GameType.number4x4) {
      return 2;
    }

    int hardIndex = 1;
    if (level > unLimited) {
      hardIndex = 14;
      return hardIndex;
    }

    for (int i = 0; i < hrdBottomSheetItemList.length; i++) {
      final item = hrdBottomSheetItemList[i];
      final start = item.startLevel;
      final end = item.endLevel;

      if (level >= start && level <= end) {
        return item.index;
      }
    }
    return hardIndex;
  }

  ///根据难度索引key获取对应value
  String getLastHard(int hardIndex, GameType type) {
    String str = '${S.Stage.tr}1';
    if (type == GameType.hrd) {
      str = hardIndex > 13 ? "${S.infinite.tr}1" : "${S.Stage.tr}$hardIndex";
    } else {
      if (hardIndex == 2) {
        str = "4x4";
      } else {
        str = "3x3";
      }
    }
    return str;
  }

  void show({
    required int current,
    required Function(BottomSheetModel model) onSelect,
    SheetPage page = SheetPage.home,
    GameType type = GameType.hrd,
    RankPlayerModel? rankPlayerModel,
  }) {
    BottomActionSheet.show(
      page: page,
      current: current,
      context: Get.context!,
      lastHardIndex: lastHardIndex.value,
      onSelect: (m) => onSelect(m),
      actions: type == GameType.hrd ? hrdBottomSheetItemList : numBottomSheetItemList,
      rankPlayerModel: rankPlayerModel,
      type: type,
    );
  }

  BottomSheetModel createInfiniteModel() {
    BottomSheetModel infiniteModel = BottomSheetModel();
    infiniteModel.index = 14;
    infiniteModel.startLevel = unLimited + 1;
    infiniteModel.endLevel = 1000;
    infiniteModel.left = "${S.infinite.tr}1";
    infiniteModel.center = S.Lv.trArgs(['${infiniteModel.startLevel}-${infiniteModel.endLevel}']);
    infiniteModel.totalStarNum = (1000 - unLimited) * 3;
    return infiniteModel;
  }
}

class BottomSheetModel {
  String left = "";
  String center = "";
  String right = "";
  String hardDesc = "";
  String rightImage = "lib/assets/png/level/level_bottom_lock.png";
  int index = 0;
  int starNum = 0;
  int totalStarNum = 0;
  int startLevel = 0;
  int endLevel = 0;
  bool showStar = false;

  BottomSheetModel();
}

class RankPlayerModel {
  String? myAvatar;
  String? rivalAvatar;
  int? rivalLevel;

  RankPlayerModel({this.myAvatar, this.rivalAvatar, this.rivalLevel});
}
