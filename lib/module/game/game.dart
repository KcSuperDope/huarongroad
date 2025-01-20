import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/audio_palyer.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/module/ble/ble_data_handler.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/module/game/game_ai_teach.dart';
import 'package:huaroad/module/game/game_guide.dart';
import 'package:huaroad/module/game/game_history.dart';
import 'package:huaroad/module/game/game_record.dart';
import 'package:huaroad/module/game/game_share.dart';
import 'package:huaroad/module/game/game_step.dart';
import 'package:huaroad/module/game/game_teach_model.dart';
import 'package:huaroad/module/game/game_time_watch.dart';
import 'package:huaroad/module/game/hrd_game/hrd_game.dart';
import 'package:huaroad/module/game/num_game/num_game.dart';
import 'package:huaroad/module/hrd/hrd_dialog.dart';
import 'package:huaroad/module/level/level_hard_handler.dart';
import 'package:huaroad/module/piece/piece.dart';
import 'package:huaroad/module/piece/piece_handler.dart';
import 'package:huaroad/module/piece/piece_model.dart';
import 'package:huaroad/plugin/model/report_event_model.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/util/ai_use_util.dart';
import 'package:huaroad/util/eventbus_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef CMatrix2 = List<List<int>>;
typedef HallState = List<bool>;
typedef StateChange = void Function(GameState state);
typedef ExternalMethod = void Function();

enum GameState { prepare, pressOk, ready, onGoing, success, fail, error, longTime }

enum GameFailReason { timeOut, stepCountOut, userCancel }

/// hrd, 数字拼图
enum GameType { hrd, number3x3, number4x4, number4x5 }

/// 练习，闯关，排位，名局
enum GameMode { freedom, level, rank, famous }

/// 游戏记录上传状态
enum GameUploadState { unUpload, uploading, uploadFail, uploadSuccess }

const maxGameTime = 10 * 60 * 1000;
const maxStepCount = 1000;

const game_last_tps_key = "game_last_tps_";

/// 禁止直接生成实例，必须使用子类
class Game {
  int id = -1;
  int index = 1;
  int rowNum = 0;
  int colNum = 0;
  int startTime = 0;
  int totalTime = 0;

  String tag = "home";
  int reviewId = -1;
  List<int> openingList = [];
  CMatrix2 openingMatrix = [];
  String opening = "";
  int famousHard = 1;

  final title = "".obs;
  final starNum = 0.obs;
  final mode = GameMode.freedom.obs;
  final type = GameType.hrd.obs;
  final state = GameState.prepare.obs;
  final failReason = GameFailReason.timeOut.obs;
  final pieceList = <PieceModel>[].obs;

  final isConnected = false.obs;
  final isInAI = false.obs;
  final useAI = false.obs;
  final allowPlay = true.obs;

  final timerWatch = MyStopWatch();
  final history = GameHistory();
  final aiTeach = AITeach();
  final guide = LongTimeGuide();

  final teachModels = <TeachModel>[].obs;
  final showStepCount = 0.obs; // 显示的步数，ai帮解剩余步数或者游戏步数；
  final animationDuration = 40.obs; // 棋子移动动画时长
  final Queue<GameStep> stepQueen = Queue();

  String openingBoardFilepath = "";
  StateChange? stateChangeListener;
  ExternalMethod? randomAction;
  ExternalMethod? nextAction;
  ExternalMethod? playAgainAction;

  GameUploadState uploadState = GameUploadState.unUpload;
  AnimationController? teachAnimationController;
  StreamSubscription? _screenStatusSubscription;

  double get tps => double.parse((history.totalCount.value / (getTotalTime() / 1000)).toStringAsFixed(2));

  int get hard => mode.value == GameMode.level
      ? LevelHardHandler().getHardIndex(id, gameType: type.value)
      : mode.value == GameMode.famous
          ? famousHard
          : id;

  init() {
    startTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    pieceList.value = PieceHandler().createModelList(openingMatrix, type.value);

    timerWatch.maxTime = maxGameTime;
    timerWatch.onTimeOut = () => fail(playAudio: true, timeOut: true);

    history.maxStepCount = maxStepCount;
    history.onStepCountOut = () => fail(playAudio: true, stepCountOut: true);

    guide.getControllerTag = tag;
    guide.pieceList = pieceList;
    guide.getSolution = getSolutionModel;

    AIUseUtils().updateAICount(type.value);

    _addScreenStatusListener();

    if (mode.value == GameMode.rank) return;

    Future.delayed(const Duration(milliseconds: 300), () async {
      openingBoardFilepath = await GameShare.captureImage();
    });
  }

  /// 求解(步骤 + 棋盘)
  Future getSolutionModel() async {
    return [];
  }

  /// 是否成功
  bool win() {
    return false;
  }

  /// 屏幕状态
  void _addScreenStatusListener() {
    _screenStatusSubscription = eventBus.on<ScreenStatusEvent>().listen((event) {
      if (state.value == GameState.onGoing) {
        if (event.isOn) {
          HRAudioPlayer().resumeGameBGM();
        } else {
          if (HRAudioPlayer().isBGMPlaying) {
            HRAudioPlayer().pauseGameBGM();
          }
        }
      }
    });
  }

  void playAgain() {
    FindDeviceHandler().deviceConnected.value ? connect() : disconnect();
    playAgainAction != null ? playAgainAction!() : () {};
  }

  void lookTeach() {
    Get.toNamed(Routes.game_desc_page, arguments: {"type": type.value, "hard": hard});
  }

  /// 棋盘恢复到初始状态
  void reset() {
    pieceList.value = PieceHandler().createModelList(openingMatrix, type.value);
    state.value = isConnected.value ? GameState.prepare : GameState.ready;
    stateChangeListener != null ? stateChangeListener!(state.value) : () {};
    animationDuration.value = isConnected.value ? 0 : 40;
    isInAI.value = false;
    timerWatch.reset();
    guide.reset();
    history.clear();
    starNum.value = 0;
    useAI.value = false;
  }

  /// 状态监听
  void addStateListener(StateChange sc) => stateChangeListener = sc;

  /// 取消监听
  void removeStateListener() {
    stateChangeListener = null;
    _screenStatusSubscription?.cancel();
  }

  /// 结束时间
  int getTotalTime() {
    int res = 0;
    if (history.steps.isNotEmpty) {
      res = history.steps.last.timestamp;
    }
    return res;
  }

  /// 虚拟棋盘可以移动
  bool canMove(PieceModel model, int targetX, int targetY) {
    if (isConnected.value) return false;
    if (targetX < 0 || targetY < 0 || targetX >= colNum || targetY >= rowNum) return false;
    if ((model.kind == 2 || model.kind == 4) && targetX >= colNum - 1) return false;
    if ((model.kind == 3 || model.kind == 4) && targetY >= rowNum - 1) return false;
    // 目前位置是空 且其他棋子和目前棋子无交集
    PieceModel target = model.clone();
    target.dx = targetX;
    target.dy = targetY;
    if (pieceList.any((element) => element != model && element.overlaps(target))) {
      return false;
    }
    return true;
  }

  /// 游戏已连接设备
  void connect({int? levelIndex}) {
    isConnected.value = true;
    BleDataHandler().sendGame(this, levelIndex: levelIndex);
    reset();
  }

  /// 失去连接
  void disconnect() {
    isConnected.value = false;
    reset();
  }

  /// 主动开始游戏
  void start() {
    if (isConnected.value) {
      BleDataHandler().startGame();
    } else {
      HRAudioPlayer().playGameBGM();
      timerWatch.start();
      startTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      reportEvent();
      state.value = GameState.onGoing;
      stateChangeListener != null ? stateChangeListener!(state.value) : () {};
    }
  }

  CMatrix2 getCurrentMatrix() {
    return PieceHandler().createMatrix(rowNum, colNum, pieceList, type.value);
  }

  List<int> getCurrentList() {
    return PieceHandler().createCurrentList(rowNum, colNum, pieceList, type.value);
  }

  String getCurrentMatrixString() {
    return PieceHandler().createMatrixString(rowNum, colNum, pieceList, type.value);
  }

  List<Offset> getEmpty() {
    List<Offset> res = [];
    final current = getCurrentList();
    for (int i = 0; i < current.length; i++) {
      if (current[i] == 0) {
        res.add(Offset((i % colNum).toDouble(), (i ~/ colNum).toDouble()));
      }
    }
    return res;
  }

  void receivePrepareBoard(List<int> board) {
    for (var piece in pieceList) {
      if (piece.kind! < 0) continue;
      final tempList = [];
      for (var index in piece.place()) {
        tempList.add(board[index]);
      }

      piece.state = tempList.contains(0) ? PieceState.empty : PieceState.normal;
      Get.find<HRPieceController>(tag: tag).update([piece.id!]);
    }

    pieceList.removeWhere((element) => element.kind == -2);
    pieceList.addAll(
      PieceHandler().createError(correct: getCurrentList(), current: handleList(board), type: type.value),
    );

    if (state.value != GameState.prepare) {
      if (getCurrentList().toString() == board.toString()) {
        state.value = GameState.pressOk;
      } else {
        state.value = GameState.error;
      }
    }
  }

  void receiveBoard(List<int> board, GameState bleState, {required int stepCount}) {
    if (board.isEmpty) return;

    /// 移除掉error棋子
    pieceList.removeWhere((element) => element.kind == -2);
    CMatrix2 matrix2 = listToMatrix(handleList(board));
    gameUpdate(matrix2: matrix2, bleState: bleState, stepCount: stepCount);
  }

  List<int> handleList(List<int> board) {
    final List<int> list = [];
    if (type.value == GameType.number3x3) {
      list.add(board[0]);
      list.add(board[1]);
      list.add(board[2]);
      list.add(board[4]);
      list.add(board[5]);
      list.add(board[6]);
      list.add(board[8]);
      list.add(board[9]);
      list.add(board[10]);
    } else if (type.value == GameType.number4x4) {
      list.addAll(board.sublist(0, 16));
    } else {
      list.addAll(board);
    }
    return list;
  }

  void gameUpdate({required CMatrix2 matrix2, required GameState bleState, required int stepCount}) {
    if (state.value == GameState.success || state.value == GameState.fail) return;

    state.value = bleState;

    switch (state.value) {
      case GameState.ready:
        stateChangeListener != null ? stateChangeListener!(state.value) : () {};
        break;
      case GameState.onGoing:
        if (mode.value != GameMode.rank) guide.refreshTime();
        stateChangeListener != null ? stateChangeListener!(state.value) : () {};
        if (stepCount == 0) {
          // stepCount == 0 仅代表游戏开始，不代表有棋盘变化
          timerWatch.start();
          startTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          reportEvent();
        } else {
          boardUpdate(cMatrix2: matrix2, stepCount: stepCount);
        }
        break;
      case GameState.success:
        success();
        break;
      case GameState.fail:
        fail();
        break;
    }
  }

  void boardUpdate({required CMatrix2 cMatrix2, required int stepCount}) {
    pieceList.value = PieceHandler().createModelList(cMatrix2, type.value);
    history.totalCount.value = stepCount;
    doAI();
  }

  void doAI() async {
    if (isInAI.value && teachModels.isNotEmpty) {
      CMatrix2 current = getCurrentMatrix();
      if (current.toString() == teachModels.first.matrix2.toString()) {
        teachModels.removeAt(0);
        aiTeach.matchingNextTeachStep(teachModels, pieceList, tag);
      } else {
        Fluttertoast.showToast(msg: S.resolving.tr);
        teachModels.value = await getSolutionModel();
        aiTeach.matchingNextTeachStep(teachModels, pieceList, tag);
      }
    }
  }

  void receiveStep(GameStep step) {
    switch (state.value) {
      case GameState.ready:
        HRAudioPlayer().playGameBGM();
        timerWatch.start();
        startTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        reportEvent();
        state.value = GameState.onGoing;
        if (mode.value != GameMode.rank) guide.refreshTime();
        stateChangeListener != null ? stateChangeListener!(state.value) : () {};
        stepQueen.add(step);
        history.add(step);
        doStep();
        win() ? success() : () {};
        break;
      case GameState.onGoing:
        if (mode.value != GameMode.rank) guide.refreshTime();
        stateChangeListener != null ? stateChangeListener!(state.value) : () {};
        stepQueen.add(step);
        history.add(step);
        doStep();
        win() ? success() : () {};
        break;
    }
  }

  void playStep(GameStep step) {
    if (step.pieceMoveInfo.isNotEmpty) {
      pieceMove(step);
    }
  }

  void doStep() {
    while (stepQueen.isNotEmpty) {
      GameStep step = stepQueen.removeFirst();
      pieceMove(step);
      doAI();
      doStep();
    }
  }

  void pieceMove(GameStep step) {
    final List<GamePieceMove> list = step.moves;
    if (list.isEmpty) return;

    for (var move in list) {
      PieceModel m = pieceList.firstWhere((element) => element.id == move.id);
      m.dx = m.dx! + move.toX;
      m.dy = m.dy! + move.toY;
      Get.find<HRPieceController>(tag: tag).update([move.id]);
    }
  }

  /// 游戏成功
  void success() async {
    timerWatch.stop();
    isInAI.value = false;
    guide.exit(isFinish: true);

    final lastTps = await _getLastTps();

    await Future.delayed(300.milliseconds);

    state.value = GameState.success;
    stateChangeListener != null ? stateChangeListener!(state.value) : () {};
    HRAudioPlayer().playSuccess();
    if (mode.value != GameMode.rank) dialog(tps: tps - lastTps);

    _saveTps();

    if (useAI.value == true) return;
    if (mode.value == GameMode.rank) return;

    upload();
  }

  /// 游戏失败
  void fail({
    bool playAudio = false,
    bool stepCountOut = false,
    bool timeOut = false,
    bool userCancel = false,
    bool isShowDialog = true,
  }) async {
    timerWatch.stop();
    isInAI.value = false;
    guide.exit(isFinish: true);

    if (playAudio) {
      HRAudioPlayer().playFail();
    } else {
      HRAudioPlayer().stopGameBGM();
    }

    await Future.delayed(300.milliseconds);

    state.value = GameState.fail;
    stateChangeListener != null ? stateChangeListener!(state.value) : () {};

    if (isConnected.value) BleDataHandler().exitGame();

    if (stepCountOut) failReason.value = GameFailReason.stepCountOut;
    if (userCancel) failReason.value = GameFailReason.userCancel;
    if (timeOut) failReason.value = GameFailReason.timeOut;

    int? lastStepCount;
    if (timeOut) {
      final lastSteps = await await getSolutionModel();
      lastStepCount = (lastSteps as List).length;
    }

    if (mode.value != GameMode.rank && isShowDialog) dialog(lastStepCount: lastStepCount, userCancel: userCancel);

    if (useAI.value == true) return;
    if (mode.value == GameMode.rank) return;

    upload();
  }

  void dialog({bool stepCountOut = false, bool timeOut = false, double? tps, int? lastStepCount, bool? userCancel}) {
    final imageName = state.value == GameState.success ? (useAI.value ? "ai" : "success") : "fail";
    Get.dialog(
      barrierDismissible: false,
      HrdCommonDialog(
        tps: tps,
        game: this,
        starNum: starNum.value,
        title: _getTitle(),
        imageName: imageName,
        newRecord: false,
        lastStepCount: lastStepCount,
        userCancel: userCancel ?? false,
      ),
    );
  }

  Future<double> _getLastTps() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("$game_last_tps_key${Global.userId}") ?? 0.0;
  }

  void _saveTps() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("$game_last_tps_key${Global.userId}", tps);
  }

  String _getTitle() {
    String res = "";
    if (mode.value == GameMode.freedom) {
      res = "${S.Practice.tr} ${S.Stage.tr}$id";
    } else if (mode.value == GameMode.level) {
      res = "${S.Stages.tr} ${S.Lv.trArgs([index.toString()])}";
    } else if (mode.value == GameMode.rank) {
      res = "${S.VS.tr} ${S.Stage.tr}$id";
    } else if (mode.value == GameMode.famous) {
      res = "${S.Classic.tr} ${title.value.tr}";
    }
    return res;
  }

  Future<void> upload({bool retry = false}) async {
    uploadState = GameUploadState.uploading;
    if (!retry && isConnected.value) await Future.delayed(500.milliseconds);
    try {
      final data = await GameRecordTool().upload(this);
      reviewId = data["reviewId"];
      uploadState = GameUploadState.uploadSuccess;
    } catch (e) {
      uploadState = GameUploadState.uploadFail;
      rethrow;
    }
  }

  /// AI帮解
  void switchAIMode() async {
    if (type.value == GameType.number4x5) return;
    if (state.value == GameState.fail || state.value == GameState.success) return;
    if (state.value == GameState.prepare) {
      Fluttertoast.showToast(msg: S.placethepiecesfirst.tr);
      return;
    }

    final isInAITemp = !isInAI.value;
    guide.listen(isInAITemp);

    if (isInAITemp) {
      useAI.value = true;
      teachModels.value = await getSolutionModel();
      aiTeach.matchingNextTeachStep(teachModels, pieceList, tag);
      if (isConnected.value) {
        BleDataHandler().inAi();
      }
    }

    isInAI.value = isInAITemp;
  }

  /// hall相同
  bool isSameHall(HallState hall1, HallState hall2) {
    return hall1.toString() == hall2.toString();
  }

  /// 一维数组 -> 二维
  CMatrix2 listToMatrix(List<int> board) {
    CMatrix2 matrix = [];
    int start = 0;
    int end = colNum;
    while (start >= 0 && end <= board.length) {
      matrix.add(List.from(board.sublist(start, end)));
      start += colNum;
      end += colNum;
    }
    return matrix;
  }

  static Game fromDBJson(Map<String, dynamic> data) {
    Game game = Game();
    if (data.isNotEmpty) {
      if (data["type"] == 0) {
        game = HrdGame.fromData(data["opening"]);
      } else {
        game = NumGame.fromData(data["opening"]);
      }
      game.id = data["id"];
      game.history.generalStep(data["steps"]);
      game.startTime = data["time"];
      game.totalTime = data["duration"];
      game.type.value = GameType.values[data["type"]];
      game.mode.value = GameMode.values[data["mode"]];
      game.state.value = GameState.values[data["state"]];
      game.title.value = data["title"] ?? "";
    }
    return game;
  }

  void clearCacheCaptureImage() {
    if (openingBoardFilepath.isNotEmpty) {
      File cacheImage = File(openingBoardFilepath);
      if (cacheImage.existsSync()) {
        cacheImage.deleteSync();
      }
    }
  }

  ///棋局埋点
  void reportEvent() {
    if (mode.value == GameMode.rank) {
      return;
    }
    int categoryId = 1;
    int subApplicationId = 1;
    if (type.value == GameType.hrd) {
      subApplicationId = mode.value == GameMode.famous ? 1 : (mode.value == GameMode.level ? 2 : 3);
    } else {
      categoryId = 2;
      subApplicationId = mode.value == GameMode.freedom ? 3 : (type.value == GameType.number3x3 ? 5 : 6);
    }
    GameEvent gameEvent = GameEvent(
        categoryId: categoryId,
        subApplicationId: subApplicationId,
        connectStatus: isConnected.value ? 1 : 0,
        gameStatus: 101,
        gameId: opening,
        level: id);
    ReportEventModel reportEventModel = ReportEventModel(eventId: EventId.game, gameEvent: gameEvent);
    NativeFlutterPlugin.instance.reportEvent(reportEventModel);
  }
}
