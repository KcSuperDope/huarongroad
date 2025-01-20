import 'dart:async';

import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/audio_palyer.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/hrd_game/hrd_game.dart';
import 'package:huaroad/module/game/num_game/num_game.dart';
import 'package:huaroad/module/rank/battle/vs_start_model.dart';
import 'package:huaroad/module/rank/match/rank_match_controller.dart';
import 'package:huaroad/module/rank/report/rank_report_model.dart';
import 'package:huaroad/net/http/dio_method.dart';
import 'package:huaroad/net/http/dio_util.dart';
import 'package:huaroad/net/http/urls.dart';
import 'package:huaroad/protos/battle.pb.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/dialog_util.dart';
import 'package:huaroad/util/eventbus_utils.dart';
import 'package:huaroad/util/time_util.dart';

class RankVsController extends GetxController {
  late Game game;
  final VsStartModel vsStartModel = Get.arguments;
  final timerString = '01:00'.obs;
  final stateString = S.placement.obs;
  Timer? _timer;
  var myState = S.Placing.obs;
  var rivalState = S.Placing.obs;
  bool startCountDown = false;
  final allowScroll = true.obs;
  int countTime = 0;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    createGame();
    if (vsStartModel.connectDevice!) {
      _prepare();
    }
    _deviceConnectEventListener();
  }

  @override
  void onClose() {
    _timer?.cancel();
    HRAudioPlayer().stopGameBGM();
    game.removeStateListener();
    if (myState.value != S.Completed) {
      game.fail();
    }
    _subscription?.cancel();
  }

  void createGame() {
    if (vsStartModel.battleType == 1) {
      //game = HrdGame.fromData('10221220224411441111');
      game = HrdGame.fromData(vsStartModel.putData!);
    } else {
      game = NumGame.fromData(vsStartModel.putData!);
    }
    game.mode.value = GameMode.rank;
    game.addStateListener((state) async {
      /// 观察
      if (state == GameState.ready) {
        _timer?.cancel();
        _observe();
      }

      /// 开始
      if (state == GameState.onGoing) {
        if (myState.value == S.solving) {
          return;
        }
        _timer?.cancel();
        _timeing();
      }

      /// 失败
      if (state == GameState.fail) {
        Get.back();
        DialogUtils.showImageAlert(
            title: S.Challengefailed,
            titleColor: color_F13C3C,
            image: 'lib/assets/png/tip_fail.png',
            content: S.Failedcompletegameinspecifiedtime,
            textRight: S.Rematch);
        _httpFail();
      }

      /// 成功
      if (state == GameState.success) {
        _timer?.cancel();
        myState.value = S.Completed;
        _httpEndRecover(game.timerWatch.elapsedMilliseconds, game.history.steps.length,
            game.history.getHistoryString());
      }
    });

    _connectGame(isConnected: FindDeviceHandler().deviceConnected.value);
  }

  void _connectGame({required bool isConnected}) {
    isConnected ? game.connect() : game.disconnect();
  }

  void _deviceConnectEventListener() {
    _subscription = eventBus.on<DeviceConnectedEvent>().listen((event) {
      if (!event.isConnected) {
        Get.back();
        DialogUtils.showTitleImageDialog(
          title: S.Thedevicehasbeendisconnected,
          image: "lib/assets/png/tip_bluetooth_disconnect.png",
          buttonTitle: S.ProceedtoConnect,
          onTap: () => Get.find<RankMatchController>().connectDevice(),
        );
        _httpFail();
      }
    });
  }

  void _prepare() {
    Get.find<RankMatchController>().reportEvent(205, gameId: vsStartModel.putData!);
    countTime = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countTime <= 0) {
        timer.cancel();
        Get.back();
        DialogUtils.showImageAlert(
            title: S.Challengefailed,
            titleColor: color_F13C3C,
            image: 'lib/assets/png/tip_fail.png',
            content: S.timeout,
            textRight: S.Rematch);
        _httpFail();
        return;
      }
      countTime--;
      timerString.value = '00:${countTime.toString().padLeft(2, '0')}';
    });
  }

  void _observe() {
    _httpStartObserve();
    Get.find<RankMatchController>()
        .reportEvent(206, duration: (60 - countTime) * 1000, gameId: vsStartModel.putData!);
    countTime = 15;
    timerString.value = '00:$countTime';
    stateString.value = S.observation;
    myState.value = S.Observing;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countTime <= 0) {
        timer.cancel();
        _timeing();
        return;
      }
      countTime--;
      timerString.value = '00:${countTime.toString().padLeft(2, '0')}';
    });
  }

  void _timeing() async {
    _httpStartRecover();
    Get.find<RankMatchController>()
        .reportEvent(101, duration: (15 - countTime) * 1000, gameId: vsStartModel.putData!);
    stateString.value = '';
    myState.value = S.solving;
    game.start();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (!startCountDown) {
        timerString.value = TimeUtil.transformMilliSeconds(game.timerWatch.elapsedMilliseconds);
      }
      if (game.timerWatch.elapsedMilliseconds >= 3600000) {
        timer.cancel();
        Get.back();
        DialogUtils.showImageAlert(
            title: S.Challengefailed,
            titleColor: color_F13C3C,
            image: 'lib/assets/png/tip_fail.png',
            content: S.Failedcompletegameinspecifiedtime,
            textRight: S.Rematch);
        _httpFail();
      }
    });
  }

  void waitCountDown(int second) {
    startCountDown = true;
    countTime = second;
    timerString.value = countTime.toString();
    stateString.value = S.Countdown;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countTime <= 0) {
        timer.cancel();
        Get.back();
        DialogUtils.showImageAlert(
            title: S.Challengefailed,
            titleColor: color_F13C3C,
            image: 'lib/assets/png/tip_fail.png',
            content: S.Failedcompletegameinspecifiedtime,
            textRight: S.Rematch);
        _httpFail();
        return;
      }
      countTime--;
      timerString.value = countTime.toString();
    });
  }

  void enterReportPage(s2c_battle_result battleResult) {
    _timer?.cancel();
    RankReportModel model = RankReportModel();
    model.redResult = battleResult.redResult;
    model.blueResult = battleResult.blueResult;
    model.owner = vsStartModel.owner;
    model.inviteSuccess = vsStartModel.inviteSuccess;
    model.finishTime = DateTime.now().millisecondsSinceEpoch;
    model.opening = vsStartModel.putData;
    model.gameType = vsStartModel.battleType == 2 ? GameType.number3x3 : GameType.hrd;
    Get.offNamed(Routes.rank_report_page, arguments: model);
  }

  void onTapBack() {
    if (myState.value == S.Completed) {
      DialogUtils.showAlert(
        title: S.chessCompleted,
        content: S.knowresultstillquite,
        onTapRight: () {
          _httpExitBattle();
          Get.back();
          Get.find<RankMatchController>().reportBattleResult(true);
        },
      );
    } else {
      DialogUtils.showAlert(
        title: S.Donotfinished,
        content: S.failurewithoutfinishStillquit,
        onTapRight: () {
          _httpExitBattle();
          Get.find<RankMatchController>()
              .reportEvent(103, step: game.history.steps.length, gameId: vsStartModel.putData!);
          Get.back();
          Get.find<RankMatchController>().reportBattleResult(false);
        },
      );
    }
  }

  void rivalStateChange(int status) {
    switch (status) {
      case 1:
        rivalState.value = S.Observing;
        break;
      case 2:
        rivalState.value = S.solving;
        break;
      case 3:
        rivalState.value = S.Completed;
        break;
      case 4:
        rivalState.value = S.Challengefailed;
        break;
      case 5:
        rivalState.value = S.Offline;
        break;
      case 6:
        rivalState.value = S.Reconnecting;
        break;
      default:
    }
  }

  void _httpExitBattle() async {
    //type:1 华容道, 2 数字拼图
    final Map<String, dynamic> params = <String, dynamic>{};
    params['userId'] = vsStartModel.myInfo?.userId;
    params['battleId'] = vsStartModel.battleId;
    params['battleType'] = vsStartModel.battleType;
    dynamic result =
        await DioUtil().request(Urls.POST_BATTLE_EXIT, method: DioMethod.post, data: params);
    print('result=$result');
  }

  void _httpStartObserve() async {
    //type:1 华容道, 2 数字拼图
    final Map<String, dynamic> params = <String, dynamic>{};
    params['userId'] = vsStartModel.myInfo?.userId;
    params['battleId'] = vsStartModel.battleId;
    params['battleType'] = vsStartModel.battleType;
    dynamic result = await DioUtil()
        .request(Urls.POST_BATTLE_START_OBSERVE, method: DioMethod.post, data: params);
    print('result=$result');
  }

  void _httpStartRecover() async {
    //type:1 华容道, 2 数字拼图
    final Map<String, dynamic> params = <String, dynamic>{};
    params['userId'] = vsStartModel.myInfo?.userId;
    params['battleId'] = vsStartModel.battleId;
    params['battleType'] = vsStartModel.battleType;
    dynamic result = await DioUtil()
        .request(Urls.POST_BATTLE_START_RECOVER, method: DioMethod.post, data: params);
    print('result=$result');
  }

  void _httpEndRecover(int time, int steps, String review) async {
    //type:1 华容道, 2 数字拼图
    final Map<String, dynamic> params = <String, dynamic>{};
    params['userId'] = vsStartModel.myInfo?.userId;
    params['battleId'] = vsStartModel.battleId;
    params['battleType'] = vsStartModel.battleType;
    params['finishTime'] = time;
    params['step'] = steps;
    params['opening'] = vsStartModel.putData;
    params['review'] = review;
    dynamic result =
        await DioUtil().request(Urls.POST_BATTLE_END_RECOVER, method: DioMethod.post, data: params);
    Get.find<RankMatchController>()
        .reportEvent(102, duration: time, step: steps, gameId: vsStartModel.putData!);
    print('result=$result');
  }

  void _httpFail() async {
    //type:1 华容道, 2 数字拼图
    final Map<String, dynamic> params = <String, dynamic>{};
    params['userId'] = vsStartModel.myInfo?.userId;
    params['battleId'] = vsStartModel.battleId;
    params['battleType'] = vsStartModel.battleType;
    dynamic result =
        await DioUtil().request(Urls.POST_BATTLE_FAIL, method: DioMethod.post, data: params);
    print('result=$result');
    Get.find<RankMatchController>().reportBattleResult(false);
  }

  void netWorkError() {
    Get.back();
    DialogUtils.showImageAlert(
      title: S.Challengefailed,
      titleColor: color_F13C3C,
      image: 'lib/assets/png/tip_fail.png',
      content: S.Networkissuepleaseretrylater,
    );
    _httpFail();
  }
}
