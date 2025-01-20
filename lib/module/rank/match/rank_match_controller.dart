import 'dart:async';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/module/find_device/find_devices.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/level/level_hard_handler.dart';
import 'package:huaroad/module/rank/battle/rank_vs_controller.dart';
import 'package:huaroad/module/rank/battle/vs_start_model.dart';
import 'package:huaroad/module/rank/match/battle_invite_model.dart';
import 'package:huaroad/module/rank/match/friend_model.dart';
import 'package:huaroad/module/rank/match/invite_friend_bottomsheet.dart';
import 'package:huaroad/module/rank/match/user_battle_info_model.dart';
import 'package:huaroad/net/env/gateway.dart';
import 'package:huaroad/net/grpc/grpc_service.dart';
import 'package:huaroad/net/grpc/proto_id.dart';
import 'package:huaroad/net/http/dio_method.dart';
import 'package:huaroad/net/http/dio_util.dart';
import 'package:huaroad/net/http/urls.dart';
import 'package:huaroad/plugin/model/report_event_model.dart';
import 'package:huaroad/plugin/model/user.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/protos/battle.pb.dart';
import 'package:huaroad/protos/login.pb.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/util/dialog_util.dart';
import 'package:huaroad/util/eventbus_utils.dart';
import 'package:huaroad/util/time_util.dart';
import 'package:wakelock/wakelock.dart';

class RankMatchController extends GetxController {
  int _currentHardIndex = 1;
  final currentHard = "${S.Stage.tr}1".obs;
  final winNumber = 0.obs;
  final winRate = "0".obs;
  final _timeWatch = Stopwatch();
  Timer? _timer;
  final timerString = "00:00".obs;
  var matching = false.obs;
  var inviteSuccess = false.obs;
  var owner = true.obs;
  int _matchStartTime = 1;
  int _matchEndTime = 60;
  var friends = <FriendModel>[].obs;
  var matchTitle = ''.obs;
  var matchSubtitle = ''.obs;
  User? myInfo;
  User? rivalInfo;
  late GrpcService _grpcService;
  int _roomId = 0;
  final BattleInviteModel _battleInviteModel = Get.arguments;
  var grpcConnect = false.obs;
  var onlyDevicePlayer = false.obs;
  var ready = false.obs;
  var hasAddFriend = false.obs;
  UserBattleInfoModel? userBattleInfoModel;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    Wakelock.enable();
    _initData();
    _initGrpcService();
    _deviceConnectEventListener();
  }

  @override
  void onClose() {
    _grpcService.shutdown();
    Wakelock.disable();
    _subscription?.cancel();
    super.onClose();
  }

  void _initData() async {
    await LevelHardHandler()
        .update(type: _battleInviteModel.type == 2 ? GameType.number3x3 : GameType.hrd);
    _currentHardIndex =
        LevelHardHandler().lastHardIndex.value > 13 ? 13 : LevelHardHandler().lastHardIndex.value;
    if (_battleInviteModel.owner != null) {
      owner.value = _battleInviteModel.owner!;
    }
    if (_battleInviteModel.inviteSuccess != null) {
      inviteSuccess.value = _battleInviteModel.inviteSuccess!;
    }
    if (_battleInviteModel.roomId != null) {
      _roomId = _battleInviteModel.roomId!;
    }
    if (_battleInviteModel.level != null) {
      _currentHardIndex = _battleInviteModel.level!;
    }
    if (_battleInviteModel.player != null) {
      rivalInfo = User();
      rivalInfo?.avatar = _battleInviteModel.player?.avatar;
      rivalInfo?.userId = _battleInviteModel.player?.userId.toString();
      rivalInfo?.nickName = _battleInviteModel.player?.nickName;
    }
    currentHard.value = _battleInviteModel.type == 2
        ? _currentHardIndex == 2
            ? "4*4"
            : "3*3"
        : "${S.Stage.tr}$_currentHardIndex";
    myInfo = Global.getUserInfo();
    _getWinNumber();
  }

  void _initGrpcService() {
    _grpcService = GrpcService();
    _grpcService.addGrpcListener((protoId, data) {
      switch (protoId) {
        case ProtoId.s2c_heartbeat:
          s2c_heartbeat heartbeat = s2c_heartbeat.fromBuffer(data);
          print('heartbeat:$heartbeat');
          grpcConnect.value = true;
          break;
        case ProtoId.s2c_battle_start:
          s2c_battle_start battleStart = s2c_battle_start.fromBuffer(data);
          print('battleStart:$battleStart');
          _enterVsPage(battleStart);
          break;
        case ProtoId.s2c_match_suc:
          s2c_match_suc matchSuc = s2c_match_suc.fromBuffer(data);
          print('matchSuc:$matchSuc');
          _ready(matchSuc);
          break;
        case ProtoId.s2c_match_exit:
          s2c_match_exit matchExit = s2c_match_exit.fromBuffer(data);
          print('matchExit:$matchExit');
          _rivalQuitMatch();
          break;
        case ProtoId.s2c_battle_room_enter:
          s2c_battle_room_enter battleRoomEnter = s2c_battle_room_enter.fromBuffer(data);
          print('battleRoomEnter:$battleRoomEnter');
          _friendEnterRoom(battleRoomEnter);
          break;
        case ProtoId.s2c_battle_refuse:
          s2c_battle_refuse battleRefuse = s2c_battle_refuse.fromBuffer(data);
          print('battleRefuse:$battleRefuse');
          _friendRefuse(battleRefuse);
          break;
        case ProtoId.s2c_battle_left:
          s2c_battle_left battleLeft = s2c_battle_left.fromBuffer(data);
          print('battleLeft:$battleLeft');
          _friendLeftRoom();
          break;
        case ProtoId.s2c_battle_level:
          s2c_battle_level battleLevel = s2c_battle_level.fromBuffer(data);
          print('battleLevel:$battleLevel');
          _friendChangeLevel(battleLevel.level);
          break;
        case ProtoId.s2c_battle_status:
          s2c_battle_status battleStatus = s2c_battle_status.fromBuffer(data);
          print('battle_status:$battleStatus');
          Get.find<RankVsController>().rivalStateChange(battleStatus.status);
          break;
        case ProtoId.s2c_battle_countdown:
          s2c_battle_countdown battleCountdown = s2c_battle_countdown.fromBuffer(data);
          print('battleCountdown:$battleCountdown');
          Get.find<RankVsController>().waitCountDown(battleCountdown.second);
          break;
        case ProtoId.s2c_battle_result:
          if (Get.currentRoute == Routes.rank_vs_page) {
            s2c_battle_result battleResult = s2c_battle_result.fromBuffer(data);
            print('battleResult:$battleResult');
            Get.find<RankVsController>().enterReportPage(battleResult);
            reportBattleResult(battleResult.blueResult.result.result == 1);
          }
          break;
        //好友准备
        case ProtoId.s2c_battle_ready_state:
          s2c_battle_ready_state battleReadyState = s2c_battle_ready_state.fromBuffer(data);
          print('battleReadyState:$battleReadyState');
          _friendReady(battleReadyState);
          break;
        default:
      }
    }, onErrorHandler: _netWorkError);

    _grpcService.send(ProtoId.c2s_heartbeat);
  }

  void onTapBack() {
    DialogUtils.showAlert(
      title: S.Waiting,
      content: S.Gamehasntstartedleavetheroom,
      onTapRight: () {
        leftRoom();
        Get.back();
        Get.back();
      },
      onTapClose: () => Get.back(),
    );
  }

  void selectHard() {
    if (matching.value || !owner.value) {
      return;
    }
    LevelHardHandler().show(
        type: _battleInviteModel.type == 2 ? GameType.number3x3 : GameType.hrd,
        page: SheetPage.rank,
        onSelect: (i) => changeLevel(i),
        current: _currentHardIndex,
        rankPlayerModel: RankPlayerModel(
            myAvatar: Global.userAvatar,
            rivalAvatar: rivalInfo?.avatar,
            rivalLevel: rivalInfo?.level));
  }

  void toRecord() {
    Get.toNamed(
      Routes.record_page,
      arguments: {
        "type": _battleInviteModel.type == 2 ? GameType.number3x3 : GameType.hrd,
        "mode": GameMode.rank,
      },
    );
  }

  void startMatch() async {
    if (!grpcConnect.value) {
      Fluttertoast.showToast(msg: S.Networkissue.tr);
      _grpcService.send(ProtoId.c2s_heartbeat);
    }
    if (!await _httpMatch()) {
      return;
    }
    matching.value = true;
    matchTitle.value = S.Matching;
    matchSubtitle.value = '${S.Esimatedtime.tr} $_matchStartTime-$_matchEndTime${S.seconds.tr}';
    _timeWatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final time = TimeUtil.transformMilliSeconds(_timeWatch.elapsedMilliseconds);
      timerString.value = time.substring(0, time.length - 3);

      if (_timeWatch.elapsedMilliseconds >= 70000) {
        _timeWatch.stop();
        _timeWatch.reset();
        _timer?.cancel();
        matching.value = false;
      }
    });
  }

  ///棋局埋点
  void reportEvent(int gameStatus, {int duration = 0, int step = 0, String gameId = ''}) {
    GameEvent gameEvent = GameEvent(
        categoryId: _battleInviteModel.type,
        subApplicationId: 4,
        connectStatus: 1,
        gameStatus: gameStatus,
        duration: duration,
        step: step,
        gameId: gameId,
        level: _currentHardIndex);
    ReportEventModel reportEventModel =
        ReportEventModel(eventId: EventId.game, gameEvent: gameEvent);
    NativeFlutterPlugin.instance.reportEvent(reportEventModel);
  }

  void _ready(s2c_match_suc matchSuc) {
    reportEvent(204, duration: _timeWatch.elapsedMilliseconds);
    rivalInfo = User();
    rivalInfo?.avatar = matchSuc.face.avatar;
    rivalInfo?.userId = matchSuc.face.userId.toString();
    rivalInfo?.nickName = matchSuc.face.nickName;
    if (rivalInfo?.userId?.length == 5) {
      //机器人
      userBattleInfoModel = UserBattleInfoModel();
      userBattleInfoModel?.name = rivalInfo?.nickName;
      userBattleInfoModel?.avatar = rivalInfo?.avatar;
      userBattleInfoModel?.weekTotalBattleWinNum = Random().nextInt(50) + 1;
      userBattleInfoModel?.weekTotalBattleNum =
          ((userBattleInfoModel!.weekTotalBattleWinNum! * 100) / (Random().nextInt(20) + 40))
              .round();
      userBattleInfoModel?.birthday = (Random().nextInt(15) + 1995).toString();
      userBattleInfoModel?.country = S.Unknownlocation.tr;
    }
    _roomId = matchSuc.roomId.toInt();
    _timeWatch.stop();
    _timeWatch.reset();
    _timer?.cancel();
    matchTitle.value = S.matchfound;
    matchSubtitle.value = S.startingthegame;
    int countTime = 3;
    timerString.value = countTime.toString();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countTime == 0) {
        timer.cancel();
        _httpReady(0);
        return;
      }
      countTime--;
      timerString.value = countTime.toString();
    });
  }

  Future<bool> _httpMatch() async {
    bool success = false;
    //type:1 华容道, 2 数字拼图
    final Map<String, dynamic> params = <String, dynamic>{};
    params['userId'] = myInfo!.userId;
    params['type'] = _battleInviteModel.type;
    params['level'] = _currentHardIndex;
    try {
      dynamic result =
          await DioUtil().request(Urls.POST_BATTLE_MATCH, method: DioMethod.post, data: params);
      if (result != null) {
        if (result['data']['status'] == 0) {
          success = true;
          _matchStartTime = result['data']['startSecond'];
          _matchEndTime = result['data']['endSecond'];
          reportEvent(203);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: S.Networkissue.tr);
    }
    return Future.value(success);
  }

  void _rivalQuitMatch() {
    _timer?.cancel();
    matching.value = false;
    timerString.value = "00:00";
    DialogUtils.showAlert(
      title: S.hasquit,
      content: S.hasquitrematch,
      textRight: S.Rematch,
      onTapRight: () => startMatch(),
      onTapClose: () => Get.back(),
    );
  }

  void quitMatch() {
    if (matching.value && rivalInfo != null) {
      _httpReady(1);
    } else {
      _httpQuitMatch();
    }
    _timeWatch.stop();
    _timeWatch.reset();
    _timer?.cancel();
    matching.value = false;
    timerString.value = "00:00";
  }

  void _httpQuitMatch() async {
    //type:1 华容道, 2 数字拼图
    final Map<String, dynamic> params = <String, dynamic>{};
    params['userId'] = myInfo!.userId;
    params['type'] = _battleInviteModel.type;
    params['level'] = _currentHardIndex;
    dynamic result =
        await DioUtil().request(Urls.POST_BATTLE_QUIT_MATCH, method: DioMethod.post, data: params);
    print('result=$result');
  }

  void _httpReady(int status) async {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['userId'] = myInfo!.userId;
    params['roomId'] = _roomId;
    params['status'] = status; //准备状态 0:就绪 1:取消
    dynamic result =
        await DioUtil().request(Urls.POST_BATTLE_READY, method: DioMethod.post, data: params);
    print('result=$result');
  }

  void _enterVsPage(s2c_battle_start battleStart) {
    matching.value = false;
    ready.value = false;
    timerString.value = "00:00";
    VsStartModel vsStartModel = VsStartModel(
        battleType: _battleInviteModel.type,
        battleId: battleStart.battleId.toInt(),
        myInfo: myInfo,
        rivalInfo: rivalInfo,
        putData: battleStart.putData,
        owner: owner.value,
        inviteSuccess: inviteSuccess.value,
        connectDevice: FindDeviceHandler().deviceConnected.value,
        level: _currentHardIndex);
    if (Get.currentRoute != Routes.rank_matching_page) {
      Get.until((route) => Get.currentRoute == Routes.rank_matching_page);
    }
    Get.toNamed(Routes.rank_vs_page, arguments: vsStartModel);
  }

  void changeLevel(BottomSheetModel levelModel) {
    currentHard.value = levelModel.left;
    _currentHardIndex = levelModel.index;
    _getWinNumber();
    if (inviteSuccess.value) {
      _httpChangeLevel();
    }
  }

  void getFriends() async {
    String mainId = Global.getUserInfo()?.mainId ?? '1';
    try {
      dynamic result = await DioUtil().request(GateWay.im + Urls.POST_BATTLE_FRIEND_LIST,
          method: DioMethod.post, params: {'mainId': mainId});

      List<FriendModel> list = [];
      for (var e in result['data']) {
        if (e['onLineStatus'] == 1) {
          list.add(FriendModel.fromJson(e));
        }
      }

      friends.clear();
      friends.addAll(list);
    } catch (e) {
      Fluttertoast.showToast(msg: S.Networkissue.tr);
    }
    Get.bottomSheet(InviteFriendBottomSheet(), isDismissible: false, enableDrag: false);
  }

  void inviteFriend(String inviteUserId) async {
    if (!grpcConnect.value) {
      _grpcService.send(ProtoId.c2s_heartbeat);
    }
    //type:1 华容道, 2 数字拼图
    final Map<String, dynamic> params = <String, dynamic>{};
    params['userId'] = myInfo!.userId;
    params['type'] = _battleInviteModel.type;
    params['inviteUserId'] = inviteUserId;
    dynamic result = await DioUtil()
        .request(Urls.POST_BATTLE_INVITE_FRIEND, method: DioMethod.post, data: params);
    reportEvent(201);
    print('result=$result');
  }

  void leftRoom() async {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['userId'] = myInfo!.userId;
    params['roomId'] = _roomId;
    dynamic result =
        await DioUtil().request(Urls.POST_BATTLE_LEFT_ROOM, method: DioMethod.post, data: params);
    print('result=$result');
  }

  void startBattle() {
    if (!grpcConnect.value) {
      _grpcService.send(ProtoId.c2s_heartbeat);
    }
    _httpStartBattle();
  }

  void kickOut() async {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['userId'] = myInfo!.userId;
    params['kickUserId'] = rivalInfo?.userId;
    params['roomId'] = _roomId;
    dynamic result =
        await DioUtil().request(Urls.POST_BATTLE_KICK, method: DioMethod.post, data: params);
    print('result=$result');
    inviteSuccess.value = false;
  }

  void connectDevice() {
    FlutterBluePlus.adapterState.listen((event) {
      BluetoothAdapterState state = event;
      if (state == BluetoothAdapterState.on) {
        if (!Get.isDialogOpen!) {
          Get.bottomSheet(
              SizedBox(height: Get.height * 0.6, child: FindDevicesPage(dialogMode: true)),
              clipBehavior: Clip.hardEdge,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false);
        }
      } else if (state == BluetoothAdapterState.off ||
          state == BluetoothAdapterState.unavailable ||
          state == BluetoothAdapterState.unauthorized) {
        if (!Get.isDialogOpen!) {
          DialogUtils.showTitleImageDialog(
            title: S.Bluetoothnotenabled,
            image: "lib/assets/png/tip_bluetooth_off.png",
            buttonTitle: S.Enablebluetooth,
            onTap: () => AppSettings.openAppSettings(type: AppSettingsType.bluetooth),
          );
        }
      } else {}
    });
  }

  void onTapReady() async {
    ready.value = !ready.value;
    final Map<String, dynamic> params = <String, dynamic>{};
    params['to_app_user_id'] = rivalInfo!.userId;
    params['is_ready'] = ready.value;
    dynamic result = await DioUtil()
        .request(GateWay.battle + Urls.POST_BATTLE_DOREADY, method: DioMethod.post, data: params);
    print('result=$result');
  }

  void onTapAddFriend() async {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['mainId'] = Global.getUserInfo()?.mainId ?? '1';
    params['targetAppUserId'] = rivalInfo?.userId ?? '';
    dynamic result = await DioUtil()
        .request(GateWay.im + Urls.POST_BATTLE_FRIEND_APPLY, method: DioMethod.post, data: params);
    print('result=$result');
    if (!hasAddFriend.value) {
      hasAddFriend.value = true;
    }
  }

  void onTapRivalAvatar() async {
    if (rivalInfo?.userId?.length != 5) {
      dynamic result = await DioUtil().request((GateWay.battle + Urls.GET_BATTLE_USERINFO)
          .replaceAll(RegExp(r'{app_user_id}'), rivalInfo?.userId ?? '')
          .replaceAll(RegExp(r'{level}'), _currentHardIndex.toString()));
      if (result['data'] != null) {
        userBattleInfoModel = UserBattleInfoModel.fromJson(result['data']);
      } else {
        userBattleInfoModel = UserBattleInfoModel();
      }
    }
    Get.bottomSheet(UserInfoBottomSheet());
  }

  void _getWinNumber() async {
    dynamic result = await DioUtil().request((GateWay.battle + Urls.GET_BATTLE_USERINFO)
        .replaceAll(RegExp(r'{app_user_id}'), myInfo!.userId!)
        .replaceAll(RegExp(r'{level}'), _currentHardIndex.toString()));
    UserBattleInfoModel battleInfoModel = UserBattleInfoModel.fromJson(result['data']);
    if (battleInfoModel.weekTotalBattleWinNum != null) {
      winNumber.value = battleInfoModel.weekTotalBattleWinNum!.toInt();
      winRate.value =
          (battleInfoModel.weekTotalBattleWinNum! / battleInfoModel.weekTotalBattleNum! * 100)
              .toStringAsFixed(0);
    } else {
      winNumber.value = 0;
      winRate.value = '0';
    }
  }

  void _friendEnterRoom(s2c_battle_room_enter battleRoomEnter) {
    if (Get.isBottomSheetOpen!) {
      Get.back();
    }
    rivalInfo = User();
    rivalInfo?.avatar = battleRoomEnter.face.avatar;
    rivalInfo?.userId = battleRoomEnter.face.userId.toString();
    rivalInfo?.nickName = battleRoomEnter.face.nickName;
    rivalInfo?.level = battleRoomEnter.level;
    _roomId = battleRoomEnter.roomId.toInt();
    inviteSuccess.value = true;
  }

  void _friendRefuse(s2c_battle_refuse battleRefuse) {
    FriendModel friend = friends.firstWhere((e) => e.userId == battleRefuse.userId.toInt());
    friend.inviting.value = false;
    friend.count.value = 0;
    Fluttertoast.showToast(
        msg: '${battleRefuse.nickName}${S.hasdeclined.tr}', toastLength: Toast.LENGTH_LONG);
  }

  void _friendLeftRoom() {
    inviteSuccess.value = false;
    if (!owner.value) {
      owner.value = true;
    }
  }

  void _friendChangeLevel(int level) {
    currentHard.value = LevelHardHandler().getLastHard(
      level,
      _battleInviteModel.type == 2 ? GameType.number3x3 : GameType.hrd,
    );
    _currentHardIndex = level;
    _getWinNumber();
  }

  void _httpStartBattle() async {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['userId'] = myInfo!.userId;
    params['type'] = _battleInviteModel.type;
    params['level'] = _currentHardIndex;
    dynamic result =
        await DioUtil().request(Urls.POST_BATTLE_START, method: DioMethod.post, data: params);
    print('result=$result');
  }

  void _httpChangeLevel() async {
    //type:1 华容道, 2 数字拼图
    final Map<String, dynamic> params = <String, dynamic>{};
    params['userId'] = myInfo!.userId;
    params['level'] = _currentHardIndex;
    params['roomId'] = _roomId;
    dynamic result = await DioUtil()
        .request(Urls.POST_BATTLE_CHANGE_LEVEL, method: DioMethod.post, data: params);
    print('result=$result');
  }

  void _netWorkError() {
    grpcConnect.value = false;
    if (Get.currentRoute == Routes.rank_vs_page) {
      Get.find<RankVsController>().netWorkError();
    }
  }

  void _deviceConnectEventListener() {
    _subscription = eventBus.on<DeviceConnectedEvent>().listen((event) {
      if (!event.isConnected) {
        if (matching.value) {
          quitMatch();
        }
        Fluttertoast.showToast(msg: S.Thedevicehasbeendisconnected.tr);
      }
    });
  }

  void _friendReady(s2c_battle_ready_state state) {
    ready.value = state.isReady;
  }

  void reportBattleResult(bool win) async {
    if (inviteSuccess.value) {
      return;
    }
    final Map<String, dynamic> params = <String, dynamic>{};
    params['is_won_battle'] = win;
    params['level'] = _currentHardIndex;
    dynamic result = await DioUtil()
        .request(GateWay.battle + Urls.POST_BATTLE_RESULT, method: DioMethod.post, data: params);
    print('result=$result');
    _getWinNumber();
  }
}
