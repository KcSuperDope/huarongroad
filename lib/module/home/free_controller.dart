import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/game_data/game_opening_handler.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/audio_palyer.dart';
import 'package:huaroad/module/ble/ble_data_handler.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_share.dart';
import 'package:huaroad/module/game/hrd_game/hrd_game.dart';
import 'package:huaroad/module/game/num_game/num_game.dart';
import 'package:huaroad/module/level/level_hard_handler.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/util/ai_use_util.dart';
import 'package:huaroad/util/dialog_util.dart';
import 'package:huaroad/util/eventbus_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

class FreeController extends GetxController with GetTickerProviderStateMixin {
  final game = Game().obs;
  final allowScroll = true.obs;
  final currentHard = ((Get.arguments as GameType == GameType.hrd) ? "${S.Stage.tr}1" : "3x3").obs;
  final currentHardIndex = 1.obs;
  GameType gameType = Get.arguments as GameType;

  StreamSubscription? _subscription;

  @override
  void onInit() async {
    super.onInit();
    Wakelock.enable();
    GameShare.shareBoardKey = GlobalKey();
    addEventbusListener();
    if (gameType == GameType.hrd) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      currentHardIndex.value = prefs.getInt("last_hard") ?? 1;
      currentHard.value = LevelHardHandler().getLastHard(currentHardIndex.value, gameType);
    }
    createGame();
  }

  void addEventbusListener() {
    _subscription = eventBus.on<DeviceConnectedEvent>().listen((event) {
      connectGame(isConnected: event.isConnected);
    });
  }

  @override
  void onClose() {
    super.onClose();
    _subscription?.cancel();
    HRAudioPlayer().stopGameBGM();
    game.value.removeStateListener();
  }

  void changeLevel(BottomSheetModel levelModel) async {
    currentHard.value = levelModel.left;
    currentHardIndex.value = levelModel.index;
    if (game.value.type.value != GameType.hrd) {
      gameType = levelModel.index == 1 ? GameType.number3x3 : GameType.number4x4;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("last_hard", currentHardIndex.value);
    createGame();
  }

  void onTapBack() {
    if (game.value.state.value == GameState.onGoing) {
      DialogUtils.showAlert(
        title: S.gamedonotfinish,
        content: S.Gamedonotfinishstillquite,
        showClose: false,
        onTapRight: () {
          game.value.fail(isShowDialog: false);
          Get.back();
          Get.back();
        },
        onTapClose: () => Get.back(),
        bottomWidget: GestureDetector(
          onTap: () => Get.toNamed(Routes.game_desc_page, arguments: {
            "type": game.value.type.value,
            "hard": currentHardIndex.value,
          }),
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
      if (game.value.isConnected.value) BleDataHandler().exitGame();
      Get.back();
    }
  }

  void onTapCreateGame() {
    if (game.value.state.value == GameState.onGoing) {
      DialogUtils.showAlert(
        title: S.gamedonotfinish,
        content: S.gamenotoverregeneratenewgame,
        onTapRight: () {
          game.value.fail(isShowDialog: false);
          createGame();
        },
        bottomWidget: GestureDetector(
          onTap: () => Get.toNamed(Routes.game_desc_page, arguments: game.value.type.value),
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
      createGame();
    }
  }

  void createGame() async {
    HRAudioPlayer().stopGameBGM();

    List<String> levelList = GameOpeningHandler().getLevels(currentHardIndex.value, PageGame.home, gameType);
    if (gameType == GameType.hrd) {
      game.value = HrdGame.fromData(levelList[Random().nextInt(levelList.length)]);
    } else {
      game.value = NumGame.fromData(levelList[Random().nextInt(levelList.length)]);
    }
    game.value.title.value = S.Practice.tr;
    game.value.id = currentHardIndex.value;
    game.value.mode.value = GameMode.freedom;
    game.value.tag = "home";
    game.value.randomAction = createGame;
    game.value.aiTeach.teachAnimationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    connectGame(isConnected: FindDeviceHandler().deviceConnected.value);
  }

  void connectGame({required bool isConnected}) {
    if (isConnected) {
      game.value.connect();
    } else {
      game.value.disconnect();
    }
  }

  void onAITap() async => await AIUseUtils().useAI(game.value);
}
