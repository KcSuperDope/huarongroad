import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/audio_palyer.dart';
import 'package:huaroad/db/db_handler.dart';
import 'package:huaroad/module/ble/ble_data_handler.dart';
import 'package:huaroad/module/device_info/device_info_model.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_share.dart';
import 'package:huaroad/module/game/hrd_game/hrd_game.dart';
import 'package:huaroad/module/game/num_game/num_game.dart';
import 'package:huaroad/module/level/level_controller.dart';
import 'package:huaroad/module/level/level_hard_handler.dart';
import 'package:huaroad/module/level/level_num_controller.dart';
import 'package:huaroad/module/level/level_sync_handler.dart';
import 'package:huaroad/module/level/model/level_model.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/util/ai_use_util.dart';
import 'package:huaroad/util/dialog_util.dart';
import 'package:huaroad/util/eventbus_utils.dart';
import 'package:wakelock/wakelock.dart';

class LevelGameController extends GetxController with GetTickerProviderStateMixin {
  late Game game;
  final starNum = 3.obs;
  final allowScroll = true.obs;
  final deviceInfoModel = DeviceInfoModel();
  final deviceConnected = false.obs;
  final index = Get.arguments.index;
  final opening = Get.arguments.opening;
  final type = Get.arguments.type;
  final useAITeach = false.obs;

  Timer? starTimer;
  int oldStarNum = 0;
  bool isPushNextGame = false; // 是否直接进入下局游戏
  List<int> starList = [1, 2, 3];
  Map<String, dynamic> old = {};

  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    Wakelock.enable();
    GameShare.shareBoardKey = GlobalKey();
    createGame();
    addEventbusListener();
    queryOld();
  }

  @override
  void onClose() {
    super.onClose();
    _subscription?.cancel();
    starTimer?.cancel();
    game.removeStateListener();
    HRAudioPlayer().stopGameBGM();

    /// 直接进入下局游戏，不发出中断信号
    if (!isPushNextGame) BleDataHandler().exitGame();
  }

  /// 设备的断开/连接，都将使本局游戏初始化
  void addEventbusListener() {
    _subscription = eventBus.on<DeviceConnectedEvent>().listen((event) => onReplay());
  }

  void connectGame({required bool isConnected}) {
    isConnected ? game.connect(levelIndex: index - 1) : game.disconnect();
  }

  // 获取本把游戏的记录，如果破记录则更新，如果没破记录则插入
  Future<void> queryOld() async {
    Completer completer = Completer();
    final oldData = await DBHandler().queryLevelData(index: index, type: type);
    if (oldData.isNotEmpty) {
      old = oldData.first;
      oldStarNum = old["starNum"];
    }
    completer.complete();
    return completer.future;
  }

  void createGame() {
    if (type == GameType.hrd) {
      game = HrdGame.fromData(opening);
    } else {
      game = NumGame.fromData(opening);
    }
    game.id = index;
    game.index = index;
    game.mode.value = GameMode.level;
    game.tag = "_level_${game.type.value == GameType.hrd ? "hrd" : "num"}_$index";
    game.title.value = S.Lv.trArgs([index.toString()]);
    game.nextAction = nextGame;
    game.playAgainAction = playAgain;
    game.aiTeach.teachAnimationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    game.addStateListener((state) async {
      /// 开始
      if (state == GameState.onGoing) {
        if (starTimer != null) return;
        starTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          decreaseStarNum(game.timerWatch.elapsedMilliseconds ~/ 1000);
        });
      }

      /// 失败
      if (state == GameState.fail) {
        starNum.value = 0;
        // onFailDialog();
      }

      /// 成功
      if (state == GameState.success) {
        if (starTimer != null) {
          starTimer!.cancel();
          starTimer = null;
        }

        if (useAITeach.value) {
          // onAIFinishDialog();
        } else {
          await onSaveRecord();
          // onSuccessDialog();
          unLockNext();
          await syncLevelToServer();
        }
      }
    });
    connectGame(isConnected: FindDeviceHandler().deviceConnected.value);
  }

  void playAgain() async {
    await queryOld();
    starNum.value = 3;
    useAITeach.value = false;
    starTimer?.cancel();
    starTimer = null;
  }

  void onReplay() async {
    await queryOld();
    starNum.value = 3;
    useAITeach.value = false;
    starTimer?.cancel();
    starTimer = null;

    connectGame(isConnected: FindDeviceHandler().deviceConnected.value);
  }

  void onExit() {
    Get.back();
  }

  void decreaseStarNum(int time) {
    /// ai模式下，星星清零
    if (useAITeach.value) return;
    if (time >= 100 * 60) {
      starNum.value = 0;
      game.fail(playAudio: true);
      starTimer?.cancel();
      starTimer = null;
    } else if (time >= 120) {
      starNum.value = 1;
    } else if (time >= 60) {
      starNum.value = 2;
    }
    game.starNum.value = starNum.value;
  }

  // 解锁下一关
  void unLockNext() {
    // 无新的进度和新的记录
    if (LevelHardHandler().lastLevel.value > index && oldStarNum >= starNum.value) return;
    if (game.type.value == GameType.hrd) {
      Get.find<LevelController>().updateNewLevel(index: index);
    } else {
      Get.find<LevelNumController>().updateNewLevel(index: index);
    }
  }

  Future<void> syncLevelToServer() async {
    // 无新的进度和新的记录
    if (LevelHardHandler().lastLevel.value > index && oldStarNum >= starNum.value) return;
    LevelSyncHandler().compareLevelProgress(gameType: game.type.value);
  }

  Future<void> onSaveRecord() async {
    Completer completer = Completer();
    await queryOld();
    if (old.isNotEmpty) {
      if (starNum.value > oldStarNum) {
        await DBHandler().updateLevelData(game);
      }
    } else {
      await DBHandler().insertLevelData(game);
    }
    completer.complete();
    return completer.future;
  }

  void nextGame() {
    List<LevelItemModel> totals = [];
    if (game.type.value == GameType.hrd) {
      totals = Get.find<LevelController>().items;
    } else {
      totals = Get.find<LevelNumController>().items;
    }

    if (index >= totals.length) {
      Fluttertoast.showToast(msg: S.Reachedmaximumlevel.tr);
      return;
    }
    isPushNextGame = true;
    Get.offNamed(Routes.level_game_page, arguments: totals[index], preventDuplicates: false);
  }

  void onTapBack() {
    if (game.state.value == GameState.onGoing) {
      DialogUtils.showAlert(
        title: S.gamedonotfinish,
        content: S.Gamedonotfinishstillquite,
        showClose: false,
        onTapRight: () {
          game.fail(isShowDialog: false);
          Get.back();
          if (game.type.value == GameType.hrd) Get.find<LevelController>().onUnlockSolutions(index);
        },
        bottomWidget: GestureDetector(
          onTap: () => Get.toNamed(Routes.game_desc_page, arguments: {"type": game.type.value, "hard": game.hard}),
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              "${S.Checkthetutorialguideassistance.tr}>>>",
              style: const TextStyle(color: Colors.lightBlue, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      Get.back();
      if (game.type.value == GameType.hrd) Get.find<LevelController>().onUnlockSolutions(index);
    }
  }

  void onAITap() {
    AIUseUtils().useAI(game, onTapUseAI: () {
      useAITeach.value = true;
      starNum.value = 0;
    });
  }
}
