import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:huaroad/common/audio_palyer.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/level/level_sync_handler.dart';
import 'package:huaroad/module/rank/match/battle_invite_model.dart';
import 'package:huaroad/module/record/record_model.dart';
import 'package:huaroad/module/record/record_replay_page.dart';
import 'package:huaroad/module/special_game/specail_game_data.dart';
import 'package:huaroad/net/env/env_config.dart';
import 'package:huaroad/net/env/gateway.dart';
import 'package:huaroad/plugin/model/header.dart';
import 'package:huaroad/plugin/model/report_event_model.dart';
import 'package:huaroad/plugin/model/user.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/util/eventbus_utils.dart';
import 'package:huaroad/util/logger.dart';

class NativeFlutterPlugin {
  static NativeFlutterPlugin? _instance;

  NativeFlutterPlugin._internal() {
    _instance = this;
  }

  static NativeFlutterPlugin get instance => _instance ?? NativeFlutterPlugin._internal();

  static const MethodChannel _channel = MethodChannel("com.ganyuan.huaroad/origin");

  void initChannel() {
    _channel.setMethodCallHandler((call) {
      // 同样也是根据方法名分发不同的函数
      switch (call.method) {
        case "acceptBattleInvitation":
          {
            print("NativeCallFlutter：'acceptBattleInvitation'，params：${call.arguments}");
            BattleInviteModel params = BattleInviteModel.fromJson(call.arguments);
            return _acceptBattleInvitation(params);
          }
        case "getUserInfo":
          {
            print("NativeCallFlutter：'getUserInfo'，params：${call.arguments}");
            User params = User.fromJson(call.arguments);
            return _getUserInfo(params);
          }
        case "openReviewPlayPage":
          {
            LogUtil.d(call.arguments);
            return _openReviewPlayPage(call.arguments);
          }

        case "openGamePage":
          {
            LogUtil.d(call.arguments);
            return _openGamePage(call.arguments);
          }
        case "updateLocale":
          {
            print("NativeCallFlutter：'updateLocale'，params：${call.arguments}");
            dynamic params = call.arguments;
            return _updateLocale(params['languageCode'], params['countryCode']);
          }
        case "openFamousGamePage":
          {
            print("openFamousGamePage，params：${call.arguments}");
            dynamic params = call.arguments;
            return _openFamousGamePage(params);
          }
        case "applicationEnterBackground":
          {
            print("applicationEnterBackground");
            return _applicationEnterBackground();
          }
        case 'actionScreenOn':
          {
            return _actionScreenOn();
          }
        case 'actionScreenOff':
          {
            return _actionScreenOff();
          }
        case 'appTabbarIndexChange':
          {
            return _appTabbarIndexChange(call.arguments);
          }
      }
      return Future.value("message from flutter");
    });
  }

  Future<void> _appTabbarIndexChange(int index) async {
    eventBus.fire(AppTabbarIndexChangeEvent(index));
  }

  Future<void> _actionScreenOn() async {
    eventBus.fire(ScreenStatusEvent(true));
  }

  Future<void> _actionScreenOff() async {
    // if (HRAudioPlayer().isBGMPlaying) {
    //   HRAudioPlayer().stopGameBGM();
    // }
    eventBus.fire(ScreenStatusEvent(false));
  }

  Future<void> _applicationEnterBackground() async {
    HRAudioPlayer().stopGameBGM();
    if (FindDeviceHandler().deviceConnected.value) {
      await FindDeviceHandler().bluetoothDevice?.disconnect();
    }
  }

  Future<void> _openFamousGamePage(int id) async {
    Get.toNamed(Routes.special_page);
    if (id >= SpecialGameData.list.length) return;
    Get.toNamed(Routes.special_game_page, arguments: SpecialGameData.list[id]);
  }

  Future<void> hiddenTabBar(bool isHidden) async {
    await _channel.invokeMethod("hiddenTabBar", isHidden);
  }

  Future<void> openSharePage(Map<String, dynamic> gameData) async {
    await _channel.invokeMethod("openSharePage", gameData);
  }

  Future<void> openOfficialTopic() async {
    await _channel.invokeMethod("openOfficialTopic");
  }

  Future<void> openUserHomePage(String appUserId) async {
    await _channel.invokeMethod("openUserHomePage", appUserId);
  }

  Future<void> bannerJump(Map<String, dynamic> data) async {
    await _channel.invokeMethod("bannerJump", data);
  }

  Future<void> setEnvConfig() async {
    dynamic config = await _channel.invokeMethod("envConfig");
    Header header = Header.fromJson(config);
    EnvConfig.env = GateWay.getCurrentEnv(header.env!);
    header.regTime = Global.getUserInfo()?.regTime;
    header.unionUserId = Global.getUserInfo()?.unionUserId;
    header.token = Global.getUserInfo()?.token;
    Global.setHeader = header;
    print('#####Global.header=${Global.header.toJson()}');
    print('EnvConfig.env=${EnvConfig.env}');
  }

  Future<int> getNetworkType() async {
    int networkType = 0;
    try {
      networkType = await _channel.invokeMethod("getNetworkType");
      return networkType;
    } catch (e) {
      return networkType;
    }
  }

  Future<dynamic> getGameAudioOptions() async {
    Map<String, dynamic> options = {"musicBg": 1, "musicGame": 1};
    try {
      dynamic res = await _channel.invokeMethod("getGameOptions");
      return res;
    } catch (e) {
      return options;
    }
  }

  Future<void> updateUserInfo() async {
    dynamic userInfo = await _channel.invokeMethod("updateUserInfo");
    User user = User.fromJson(userInfo);
    Global.setUserInfo = user;
    print('Global.getUserInfo=${Global.getUserInfo().toString()}');
  }

  Future<void> reportEvent(ReportEventModel reportEventModel) async {
    try {
      LogUtil.d('reportEventModel=${reportEventModel.toJson()}');
      await _channel.invokeMethod("reportEvent", reportEventModel.toJson());
    } catch (e) {
      LogUtil.d(e);
    }
  }

  Future<void> _acceptBattleInvitation(BattleInviteModel battleInviteModel) async {
    if (Get.currentRoute == Routes.rank_vs_page) {
      return;
    }

    if (Get.currentRoute != Routes.application_page) {
      Get.offNamedUntil(Routes.rank_matching_page, ModalRoute.withName(Routes.application_page),
          arguments: battleInviteModel);
    } else {
      Get.toNamed(Routes.rank_matching_page, arguments: battleInviteModel);
    }
  }

  Future<void> _getUserInfo(User user) async {
    Global.setUserInfo = user;
    print('user=${user.toJson()}');
    Header header = Global.header;
    header.regTime = user.regTime;
    header.unionUserId = user.unionUserId;
    header.token = user.token;
    Global.setHeader = header;
    LevelSyncHandler().sync();
  }

  Future<void> _updateLocale(String languageCode, String countryCode) async {
    var locale = Locale(languageCode, countryCode);
    Get.updateLocale(locale);
  }

  Future<void> _openGamePage(dynamic data) async {
    int gameId = data["game_id"];
    GameMode gameMode = GameMode.values[data["game_mode"]];
    GameType gameType = GameType.values[data["game_type"]];

    if (gameMode == GameMode.level) {
      if (gameType == GameType.hrd) {
        Get.toNamed(Routes.level_page, arguments: GameType.hrd);
      } else {
        Get.toNamed(Routes.level_num_page, arguments: gameType);
      }
    }

    if (gameMode == GameMode.freedom) {
      Get.toNamed(Routes.home_page, arguments: gameType);
    }

    if (gameMode == GameMode.famous) {
      SpecialListItem item = SpecialGameData.list[gameId];
      Get.toNamed(Routes.special_page);
      Get.toNamed(Routes.special_game_page, arguments: item);
    }
  }

  Future<void> _openReviewPlayPage(dynamic data) async {
    RecordModel model = RecordModel();
    model.opening = data["opening"];
    model.stepLength = data["step"];
    model.time = data["time"];
    model.startTime = data["start_time"];
    model.reviewId = data["review_id"];
    model.gameMode = GameMode.freedom;
    model.gameType = model.opening!.length == 20
        ? GameType.hrd
        : (model.opening!.length == 17 ? GameType.number3x3 : GameType.number4x4);
    model.name = data["userNickName"];
    model.avatar = data["userAvatar"];
    model.userId = data["userId"];
    Get.to(() => RecordReplayPage(), arguments: model);
  }
}
