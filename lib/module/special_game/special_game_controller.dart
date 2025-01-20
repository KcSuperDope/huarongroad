import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/audio_palyer.dart';
import 'package:huaroad/module/ble/ble_data_handler.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_share.dart';
import 'package:huaroad/module/game/hrd_game/hrd_game.dart';
import 'package:huaroad/module/special_game/specail_game_data.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/util/ai_use_util.dart';
import 'package:huaroad/util/dialog_util.dart';
import 'package:huaroad/util/eventbus_utils.dart';
import 'package:wakelock/wakelock.dart';

class SpecialGameController extends GetxController with GetTickerProviderStateMixin {
  final allowScroll = true.obs;
  final gameItem = (Get.arguments as SpecialListItem).obs;
  final game = HrdGame.fromData((Get.arguments as SpecialListItem).opening!).obs;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    Wakelock.enable();
    GameShare.shareBoardKey = GlobalKey();
    addEventbusListener();

    game.value.id = SpecialGameData.list.indexOf(gameItem.value);
    game.value.famousHard = gameItem.value.hard!;
    game.value.mode.value = GameMode.famous;
    game.value.title.value = gameItem.value.title!;
    game.value.tag = "_famous_hrd_${game.value.id}";
    game.value.aiTeach.teachAnimationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    game.value.nextAction = next;
    connectGame(isConnected: FindDeviceHandler().deviceConnected.value);
  }

  void next() {
    final gameItems = SpecialGameData.list;
    final index = gameItems.indexOf(gameItem.value);
    if (index + 1 < gameItems.length) {
      final item = gameItems[index + 1];
      Get.offNamed(Routes.special_game_page, arguments: item, preventDuplicates: false);
    } else {
      Fluttertoast.showToast(msg: S.Reachedmaximumlevel.tr);
    }
  }

  @override
  void onClose() {
    super.onClose();
    HRAudioPlayer().stopGameBGM();

    game.value.removeStateListener();
    _subscription?.cancel();
  }

  void addEventbusListener() {
    _subscription = eventBus.on<DeviceConnectedEvent>().listen((event) {
      connectGame(isConnected: event.isConnected);
    });
  }

  void connectGame({required bool isConnected}) {
    if (isConnected) {
      game.value.connect();
    } else {
      game.value.disconnect();
    }
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
        },
        onTapClose: () => Get.back(),
        bottomWidget: GestureDetector(
          onTap: () => Get.toNamed(Routes.game_desc_page, arguments: {"type": GameType.hrd, "hard": 1}),
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

  double boundingTextWidth(String text) {
    if (text.isEmpty) {
      return 0.0;
    }
    final TextPainter textPainter = TextPainter(
      maxLines: 1,
      textDirection: TextDirection.ltr,
      text: TextSpan(text: text, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
    )..layout(maxWidth: double.infinity);
    return textPainter.size.width;
  }

  void onAITap() async => await AIUseUtils().useAI(game.value);
}
