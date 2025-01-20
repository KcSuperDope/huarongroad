import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/plugin/model/report_event_model.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/dialog_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AIUseUtils {
  static AIUseUtils? _instance;

  AIUseUtils._internal() {
    _instance = this;
  }

  factory AIUseUtils() => _instance ?? AIUseUtils._internal();

  int allAICount = 5;
  final lastAICount = 5.obs;

  final isNotShowTips = false.obs;

  String get userNotShowTipsKey => "AI_USE_NOT_SHOW_ALERT_${Global.userId}";

  Future<bool> getUserNotShowAlert() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userNotShowTipsKey) ?? false;
  }

  Future<void> setUserNotShowAlert(bool notShowAlert) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(userNotShowTipsKey, notShowAlert);
  }

  String getTodayKey(GameType gameType) {
    DateTime today = DateTime.now();
    return "AI_USE_${Global.userId}_${today.year}${today.month}${today.day}_$gameType";
  }

  // 每日使用次数加1
  Future<void> addDayUseCount(GameType gameType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final count = await getTodayUseCount(gameType) + 1;
    await prefs.setInt(getTodayKey(gameType), count);
  }

  // 每日剩余使用次数
  Future<int> updateAICount(GameType gameType) async {
    final count = await getTodayUseCount(gameType);
    final res = allAICount - count;
    lastAICount.value = res;
    return res;
  }

  // 每日使用次数
  Future<int> getTodayUseCount(GameType gameType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final c = prefs.getInt(getTodayKey(gameType));
    return c ?? 0;
  }

  Future<void> useAI(Game game, {VoidCallback? onTapUseAI}) async {
    if (game.isInAI.value) {
      game.switchAIMode();
      return;
    }

    final type = game.type.value;
    final count = await updateAICount(type);
    useAI() async {
      if (count <= 0) {
        Fluttertoast.showToast(msg: S.timesisuseduptoday.tr);
        return;
      }
      game.switchAIMode();
      await addDayUseCount(type);
      await updateAICount(type);
      reportEvent(game);
      if (onTapUseAI != null) {
        onTapUseAI();
      }
    }

    final isNotShowAlert = await getUserNotShowAlert();
    if (isNotShowAlert) {
      useAI();
      return;
    }

    DialogUtils.showAlert(
      title: S.Youhavenchanceslefttoday.trArgs([count.toString()]),
      showClose: false,
      content:
          game.mode.value == GameMode.level ? S.youcantgetstarswithAItutorialcontinue : S.UnderAITeachingnotgetscore,
      onTapRight: () async => useAI(),
      bottomWidget: GestureDetector(
        onTap: () {
          isNotShowTips.value = !isNotShowTips.value;
          setUserNotShowAlert(isNotShowTips.value);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => isNotShowTips.value
                    ? Image.asset("lib/assets/png/radio_button.png", width: 18, height: 18)
                    : Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: color_line, width: 2),
                        ),
                      ),
              ),
              const SizedBox(width: 6),
              const Text("不再提示", style: TextStyle(color: color_mid_text, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  ///棋局埋点
  void reportEvent(Game game) {
    int categoryId = 1;
    int subApplicationId = 1;
    if (game.type.value == GameType.hrd) {
      subApplicationId = game.mode.value == GameMode.famous ? 1 : (game.mode.value == GameMode.level ? 2 : 3);
    } else {
      categoryId = 2;
      subApplicationId = game.mode.value == GameMode.freedom ? 3 : (game.type.value == GameType.number3x3 ? 5 : 6);
    }
    GameEvent gameEvent = GameEvent(
        categoryId: categoryId,
        subApplicationId: subApplicationId,
        connectStatus: game.isConnected.value ? 1 : 0,
        gameStatus: 104,
        gameId: game.opening,
        level: game.id);
    ReportEventModel reportEventModel = ReportEventModel(eventId: EventId.game, gameEvent: gameEvent);
    NativeFlutterPlugin.instance.reportEvent(reportEventModel);
  }
}
