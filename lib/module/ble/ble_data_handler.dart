import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/auto_size.dart';
import 'package:huaroad/module/device_info/device_dfu_util.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_step.dart';
import 'package:huaroad/module/level/level_hard_handler.dart';
import 'package:huaroad/module/level/level_sync_handler.dart';
import 'package:huaroad/module/level/widgets/level_sync_dialog.dart';
import 'package:huaroad/util/dialog_util.dart';
import 'package:huaroad/util/logger.dart';

class BleDataHandler {
  static BleDataHandler? _instance;

  BleDataHandler._internal() {
    _instance = this;
  }

  factory BleDataHandler() => _instance ?? BleDataHandler._internal();

  BluetoothCharacteristic? _characteristic;

  /// 闯关游戏
  Game? currentGame;

  /// 设备闯关进度
  final _totalStarList = [];

  /// 多包发送
  int _index = 0;
  List<List> _sectionList = [];
  final _syncProgress = 0.obs;
  int deviceLevel = -1;
  bool _userAlwaysSyncProgress = true;

  /// 丢步查询
  int _lastIndex = 255;
  List<int> _missStepIndexList = [];

  /// 上一次移动信息，如果重复则丢弃
  List<int> _lastPieceMoveInfo = [];

  void onInit() {}

  void inAi() {
    send([0x0C]);
  }

  /// 退出游戏
  void exitGame() {
    send([0x06]);
    _lastIndex = 255;
    _missStepIndexList.clear();
  }

  /// 开始游戏
  void startGame() {
    send([0x0A]);
  }

  ///初始化蓝牙写信道
  void initCharacteristic(BluetoothCharacteristic characteristic) {
    _characteristic = characteristic;
    send([0x02]);
    send([0x03]);
  }

  /// 历史步数查询
  void sendHistoryStepIndex(int index) {
    send([0x0b, index]);
  }

  /// 发送闯关数据
  void sendLevel(GameType type) {
    deviceLevel = -1;
    List<int> data = [];
    data.add(0x08);
    data.add(int.parse("${type.index.toRadixString(2).padLeft(2, "0")}000000", radix: 2));
    data.add(0);
    data.add(0);
    int checkSum = 0;
    for (var element in data) {
      checkSum += element;
    }
    data.add(checkSum & 0xff);

    LogUtil.d("send --  gameType : $type  app : ${LevelHardHandler().lastLevel.value}，data : $data");

    send(data);
  }

  /// levelIndex : 是否是关卡内置游戏
  void sendGame(Game game, {int? levelIndex}) {
    if (!FindDeviceHandler().deviceConnected.value) return;
    _lastIndex = 255;
    _missStepIndexList.clear();
    _lastPieceMoveInfo = [];

    List<int> data = [];
    data.add(0x05);
    data.add(game.type.value.index);
    data.add(game.state.value.index);
    final boardList = game.openingList;
    String total = "";

    /// 棋盘
    for (var element in boardList) {
      total += element.toRadixString(2).padLeft(5, "0");
    }
    total = total.padRight(100, "0");

    /// 后4位表示是内置棋盘or闯关棋盘

    /// 内置关卡数
    if (levelIndex != null && _userAlwaysSyncProgress) {
      total += "0001";
      final levelData = levelIndex.toRadixString(2).padLeft(16, "0");
      final levelData1 = levelData.substring(0, 8);
      final levelData2 = levelData.substring(8, 16);
      total += levelData2;
      total += levelData1;
    } else {
      total += "0000";
      total += 0.toRadixString(2).padLeft(16, "0");
    }

    int i = 0;
    while (i < total.length) {
      final a = int.parse(total.substring(i, i + 8), radix: 2);
      i += 8;
      data.add(a);
    }

    print("************ send ************");
    print(_userAlwaysSyncProgress);
    print("levelIndex : $levelIndex");
    print(boardList);
    print(data);
    print("************ send ************");
    send(data);

    currentGame = game;
  }

  void send(List<int> data) async {
    if (!FindDeviceHandler().deviceConnected.value) return;
    LogUtil.d("send ble data : $data");
    if (_characteristic != null) {
      await _characteristic!.write(data);
    }
  }

  ///解析蓝牙notify返回数据
  void decode(List<int> data) {
    if (data.isNotEmpty) {
      final first = data.first.toRadixString(2).padLeft(8, "0");
      final head = int.parse(first.substring(0, 4), radix: 2);
      switch (head) {
        /// 棋子移动信息
        case 0x00:
          _pieceMoveInfo(data);
          break;

        /// 棋盘状态
        case 0x01:
          _boardChange(data);
          break;

        /// 设备信息
        case 0x02:
          _deviceInfo(data);
          break;

        /// 电量
        case 0x03:
          _powerInfo(data);
          break;

        /// 绑定账号
        case 0x04:
          break;

        /// APP下发棋盘
        case 0x05:
          break;

        /// 应答设备已连接
        case 0x06:
          break;

        /// 摆放阶段上报状态
        case 0x07:
          _prepareBoard(data);
          break;

        /// 闯关数量
        case 0x08:
          _deviceLevel(data);
          break;

        /// 闯关星星
        case 0x09:
          _receiveLevelStar(data);
          break;

        /// 闯关星星
        case 0x0b:
          _lostPieceMoveInfo(data);
          break;

        /// 进入ai
        case 0x0c:
          break;
      }
    }
  }

  /// 摆放阶段上报状态
  void _prepareBoard(List<int> data) {
    if (currentGame == null) return;

    String total = "";
    for (var element in data) {
      total += element.toRadixString(2).padLeft(8, "0");
    }

    /// 棋盘
    final board = total.substring(4, 104);
    final List<int> boardList = [];
    for (int i = 0; i < board.length; i++) {
      if (i % 5 == 0) {
        final s = board.substring(i, i + 5);
        final num = int.parse(s, radix: 2);
        boardList.add(num);
      }
    }

    printBoard(boardList);

    currentGame!.receivePrepareBoard(boardList);
  }

  void _powerInfo(List<int> data) {
    String total = "";
    for (var element in data) {
      total += element.toRadixString(2).padLeft(8, "0");
    }

    /// 充电状态
    var powerState = int.parse(total.substring(4, 8), radix: 2);

    /// 百分比
    var powerPercent = int.parse(total.substring(8, 16), radix: 2);

    print("充电状态：$powerState  电量：$powerPercent");

    FindDeviceHandler().deviceInfoModel.set(power: powerPercent);
  }

  void _deviceInfo(List<int> data) {
    String total = "";
    for (var element in data) {
      total += element.toRadixString(2).padLeft(8, "0");
    }

    /// 保留
    var index = int.parse(total.substring(4, 8), radix: 2);

    /// 硬件版本号
    var hardwareVersion = int.parse(total.substring(8, 16), radix: 2);

    /// 固件版本号
    var softwareVersionData = total.substring(16, 32);
    List<int> softwareVersionList = [];
    int i = 0;
    while (i < softwareVersionData.length) {
      final a = int.parse(softwareVersionData.substring(i, i + 8), radix: 2);
      softwareVersionList.add(a);
      i += 8;
    }
    var softwareVersion = softwareVersionList.join(".");

    /// 型号
    final productData = total.substring(32, 112);
    List<int> versionProductAscList = [];
    i = 0;
    while (i < productData.length) {
      final a = int.parse(productData.substring(i, i + 8), radix: 2);
      if (a != 0) versionProductAscList.add(a);
      i += 8;
    }
    var prodCode = const Utf8Codec().decode(versionProductAscList);

    /// 研发代号
    var rdCodeData = total.substring(112, 136);
    List<int> rdCodeDataAscList = [];
    i = 0;
    while (i < rdCodeData.length) {
      final a = int.parse(rdCodeData.substring(i, i + 8), radix: 2);
      rdCodeDataAscList.add(a);
      i += 8;
    }
    var rdCode = const Utf8Codec().decode(rdCodeDataAscList);

    /// macAddr
    var macLast3 = int.parse(total.substring(136, 160), radix: 2);

    if (kDebugMode) {
      print("保留：$index  硬件版本号：$hardwareVersion  固件版本号：$softwareVersion  型号：$prodCode  研发代号：$rdCode  macAddr：$macLast3");
      print("研发代号：$rdCode");
      print("macAddr：$macLast3");
    }

    FindDeviceHandler().deviceInfoModel.set(
          softwareVersion: softwareVersion,
          hardwareVersion: hardwareVersion.toString(),
          prodCode: prodCode,
        );

    // _factoryMode(softwareVersion);
  }

  void _factoryMode(String v) async {
    double version = double.parse(v);
    if (version < 1.21) {
      try {
        await DeviceDfuUtil().handle();
        await DeviceDfuUtil().doDfu();
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  void _pieceMoveInfo(List<int> data) {
    if (data.toString() == _lastPieceMoveInfo.toString()) return;
    _lastPieceMoveInfo = data;

    String total = "";
    for (var element in data) {
      total += element.toRadixString(2).padLeft(8, "0");
    }

    /// 操作序号
    var index = int.parse(total.substring(4, 12), radix: 2);

    /// 移动步数
    var pieceMoveCount = int.parse(total.substring(12, 16), radix: 2);

    /// 移动信息
    final pieceMoveString = total.substring(16, 80);
    String pieceMoveInfo = "";
    int currentCount = 0;
    for (int i = 0; i < pieceMoveString.length; i++) {
      if (i % 8 == 0) {
        final s = pieceMoveString.substring(i, i + 8);
        final index = int.parse(s.substring(0, 4), radix: 2);
        final dir = int.parse(s.substring(4, 6), radix: 2).dir;
        currentCount++;
        if (currentCount > pieceMoveCount) break;
        pieceMoveInfo += "$index$dir";
      }
    }

    /// 时间
    var time = int.parse(total.substring(80, 100), radix: 2);

    _compareIndex(index);

    if (currentGame != null) {
      GameStep step = GameStep();
      step.pieceMoveCount = pieceMoveCount;
      step.pieceMoveInfo = pieceMoveInfo;
      step.index = index;
      step.timestamp = time * 10;
      currentGame!.history.add(step);
    }

    if (kDebugMode) {
      LogUtil.d("0x00 棋子移动： index：$index time: $time  步数：$pieceMoveCount  步骤：$pieceMoveInfo");
    }
  }

  void _boardChange(List<int> data) {
    String total = "";
    for (var element in data) {
      total += element.toRadixString(2).padLeft(8, "0");
    }

    /// 操作序号
    var index = int.parse(total.substring(4, 12), radix: 2);

    /// 游戏模式
    var type = int.parse(total.substring(12, 14), radix: 2);

    /// 关卡
    var level = int.parse(total.substring(14, 24), radix: 2);

    /// 状态
    var state = int.parse(total.substring(24, 27), radix: 2);

    /// 状态
    var boardMode = int.parse(total.substring(27, 28), radix: 2);

    /// 时间
    var time = int.parse(total.substring(108, 128), radix: 2);

    /// 步数
    var stepCount = int.parse(total.substring(128, 141), radix: 2);

    /// 星星
    var starCount = int.parse(total.substring(141, 143), radix: 2);

    /// 棋盘
    final board = total.substring(28, 108);
    final List<int> boardList = [];
    for (int i = 0; i < board.length; i++) {
      if (i % 4 == 0) {
        final s = board.substring(i, i + 4);
        final num = int.parse(s, radix: 2);
        boardList.add(num);
      }
    }
    printBoard(boardList);

    GameState bleState = GameState.prepare;
    switch (state) {
      case 0:
        bleState = GameState.prepare;
        break;
      case 1:
        bleState = GameState.ready;
        break;
      case 2:
        bleState = GameState.onGoing;
        break;
      case 3:
        bleState = GameState.longTime;
        break;
      case 4:
        bleState = GameState.fail;
        break;
      case 5:
        bleState = GameState.success;
        break;
      case 6:
        bleState = GameState.error;
        break;
    }

    if (kDebugMode) {
      LogUtil.d("0x01 棋盘状态 index：$index  模式：$type  time：$time  状态：$bleState  步数：$stepCount");
    }

    if (currentGame != null) {
      currentGame!.receiveBoard(boardList, bleState, stepCount: stepCount);
      if (bleState == GameState.success) {
        _afterSuccess(index);
      }
    }
  }

  void printBoard(List<int> list) {
    if (list.isNotEmpty) {
      String a = '\n';
      for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 4; j++) {
          a += "${list[i * 4 + j]} ";
        }
        a += '\n';
      }
      if (kDebugMode) print(a);
    }
  }

  void _deviceLevel(List<int> data) {
    String total = "";
    for (var element in data) {
      total += element.toRadixString(2).padLeft(8, "0");
    }
    var gameType = GameType.values[int.parse(total.substring(4, 6), radix: 2)];
    var level = int.parse(total.substring(8, 18), radix: 2);
    level = min(level + 1, gameType == GameType.hrd ? 1000 : (gameType == GameType.number3x3 ? 300 : 700));
    deviceLevel = level;

    LogUtil.d("receive -- gameType : $gameType  device : $level ----  app : ${LevelHardHandler().lastLevel.value}");

    if (level != LevelHardHandler().lastLevel.value) {
      DialogUtils.showAlert(
        title: S.StageSync,
        content: S.syncappdevicestageprogress,
        onTapLeft: () {
          _userAlwaysSyncProgress = false;
        },
        onTapRight: () {
          Get.dialog(
            LevelSyncDialog(
              appLevel: LevelHardHandler().lastLevel.value,
              deviceLevel: level,
              onLeftTap: (isSelectDevice) {
                _userAlwaysSyncProgress = false;
              },
              onRightTap: (isSelectDevice) {
                _userAlwaysSyncProgress = true;
                isSelectDevice ? _onTapSyncFromDevice(gameType) : _startSendLevelData(gameType);
              },
            ),
          );
        },
      );
    }
  }

  void _onTapSyncFromDevice(GameType gameType) async {
    if (deviceLevel < 0) return;
    if (deviceLevel > 1) {
      _requestLevelStar(type: gameType, ackCmd: 2);
    }

    /// 当前并无闯关进度，不在请求0x09协议
    if (deviceLevel == 1) {
      await LevelHardHandler().syncDeviceLevel(gameType: gameType, stars: []);
      Fluttertoast.showToast(msg: S.StageCompleted.tr);
      try {
        await LevelSyncHandler().uploadLevelProgress(gameType: gameType, stars: []);
      } catch (e) {}
    }
  }

  /// 09 协议既可以是 请求 也可以是下发数据
  void _requestLevelStar({required GameType type, required int ackCmd}) {
    if (ackCmd == 2) {
      _totalStarList.clear();
      _syncProgress.value = 0;

      Get.dialog(
        Obx(() => DialogUtils.progress(title: S.Inprogress, progress: _syncProgress.value)),
        barrierDismissible: false,
      );
    }

    List<int> data = [];
    data.add(0x09);
    String total = "";
    // 类型
    total += type.index.toRadixString(2).padLeft(2, "0");
    // 命令指示
    total += ackCmd.toRadixString(2).padLeft(2, "0");
    // 空数据
    total += 0.toRadixString(2).padRight(116, "0");

    int i = 0;
    while (i < total.length) {
      final a = int.parse(total.substring(i, i + 8), radix: 2);
      i += 8;
      data.add(a);
    }

    int checkSum = 0;
    for (var element in data) {
      checkSum += element;
    }

    data.add(checkSum & 0xff);

    send(data);
  }

  /// 09 协议既可以是 请求 也可以是下发数据，也可以是接收应答
  void _receiveLevelStar(List<int> data) async {
    String total = "";
    for (var element in data) {
      total += element.toRadixString(2).padLeft(8, "0");
    }
    var gameType = GameType.values[int.parse(total.substring(4, 6), radix: 2)];
    // 1.app下发 2.mcu上报 3.应答
    var cmdType = int.parse(total.substring(6, 8), radix: 2);

    // 总包数
    var totalLength = int.parse(total.substring(8, 13), radix: 2);

    // 当前包
    var index = int.parse(total.substring(13, 18), radix: 2);

    // 本包包含多少数据
    var indexContentLength = int.parse(total.substring(18, 24), radix: 2);

    // 星星数据
    final starString = total.substring(24, 124);
    final starList = [];
    for (int i = 0; i < starString.length; i += 2) {
      final starNum = int.parse(starString.substring(i, i + 2), radix: 2);
      starList.add(starNum);
    }

    LogUtil.d(
        ">>>>>>>>>>>>>>>>>>>>>>receive<<<<<<<<<<<<<<<<<<<<    \n$gameType \ncmdType: $cmdType \ntotal: $totalLength \ncurrent: $index \ncurrent_content_length: $indexContentLength \nstarList $starList");

    if (cmdType == 2) {
      /// app收到，应答，设备继续发送下个数据包
      _requestLevelStar(type: gameType, ackCmd: 3);
      _syncProgress.value = ((index + 1) / totalLength * 100).toInt();
    }

    if (cmdType == 3) {
      /// 设备收到，应答，继续发送下个数据包
      _index++;
      if (_index < _sectionList.length) {
        _syncProgress.value = ((_index + 1) / _sectionList.length * 100).toInt();
        _sendSectionLevelData(type: gameType, index: _index);
      } else {
        /// app端已经发送完毕
        Fluttertoast.showToast(msg: S.StageCompleted.tr);
        if (Get.isDialogOpen!) Get.back();
      }
    }

    _totalStarList.addAll(starList.sublist(0, indexContentLength));

    if (index == totalLength - 1) {
      if (cmdType == 2) {
        await LevelHardHandler().syncDeviceLevel(gameType: gameType, stars: _totalStarList);
        Fluttertoast.showToast(msg: S.StageCompleted.tr);
        Get.back();
        try {
          await LevelSyncHandler().uploadLevelProgress(gameType: gameType, stars: _totalStarList);
        } catch (e) {}
      }
    }
  }

  void _startSendLevelData(GameType type) {
    /// 获取App闯关进度
    final list = LevelHardHandler().starNumList;
    final List<List> sectionList = [];
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i += 50) {
        sectionList.add(list.sublist(i, min(i + 50, list.length)));
      }
    }

    _index = 0;
    _syncProgress.value = 0;
    _sectionList = sectionList;

    Get.dialog(
      Obx(() => DialogUtils.progress(title: S.Inprogress, progress: _syncProgress.value)),
      barrierDismissible: false,
    );

    _sendSectionLevelData(type: type, index: _index);
  }

  void _sendSectionLevelData({required GameType type, required int index}) {
    List<int> data = [];
    data.add(0x09);
    String total = "";
    // 类型
    total += type.index.toRadixString(2).padLeft(2, "0");
    // 命令指示
    total += 1.toRadixString(2).padLeft(2, "0");
    // 总包数
    total += (_sectionList.isEmpty ? 1 : _sectionList.length).toRadixString(2).padLeft(5, "0");

    // 当前序号
    total += index.toRadixString(2).padLeft(5, "0");

    List stars = [];
    if (_sectionList.isNotEmpty) {
      stars = _sectionList[index];
    }

    total += stars.length.toRadixString(2).padLeft(6, "0");
    // 数据
    stars.length != 50 ? stars.addAll(List.filled(50 - stars.length, 0).toList()) : () {};

    for (var num in stars) {
      total += (num as int).toRadixString(2).padLeft(2, "0");
    }

    int i = 0;
    while (i < total.length) {
      final a = int.parse(total.substring(i, i + 8), radix: 2);
      i += 8;
      data.add(a);
    }

    int checkSum = 0;
    for (var element in data) {
      checkSum += element;
    }

    data.add(checkSum & 0xff);

    LogUtil.d(
        ">>>>>>>>>>>>>>>>>>>>>>send<<<<<<<<<<<<<<<<<<<< \n$type  \ncmdType: 1 \ntotal: ${_sectionList.length} \ncurrent: $_index \ncurrent_content_length: ${stars.length}"
        " \nstarList $stars");

    send(data);
  }

  void _lostPieceMoveInfo(List<int> data) {
    String total = "";
    for (var element in data) {
      total += element.toRadixString(2).padLeft(8, "0");
    }

    /// 操作序号
    var index = int.parse(total.substring(4, 12), radix: 2);

    /// 移动步数
    var pieceMoveCount = int.parse(total.substring(12, 16), radix: 2);

    /// 移动信息
    final pieceMoveString = total.substring(16, 80);
    String pieceMoveInfo = "";
    int currentCount = 0;
    for (int i = 0; i < pieceMoveString.length; i++) {
      if (i % 8 == 0) {
        final s = pieceMoveString.substring(i, i + 8);
        final index = int.parse(s.substring(0, 4), radix: 2);
        final dir = int.parse(s.substring(4, 6), radix: 2).dir;
        currentCount++;
        if (currentCount > pieceMoveCount) break;
        pieceMoveInfo += "$index$dir";
      }
    }

    /// 时间
    var time = int.parse(total.substring(80, 100), radix: 2);

    if (currentGame != null) {
      GameStep step = GameStep();
      step.pieceMoveCount = pieceMoveCount;
      step.pieceMoveInfo = pieceMoveInfo;
      step.index = index;
      step.timestamp = time * 10;
      currentGame!.history.add(step);
    }

    if (kDebugMode) {
      LogUtil.d("0x00 棋子移动： index：$index time: $time  步数：$pieceMoveCount  步骤：$pieceMoveInfo");
    }
  }

  _handleLostSteps() {
    while (_missStepIndexList.isNotEmpty) {
      final index = _missStepIndexList.first;
      sendHistoryStepIndex(index);
      _missStepIndexList.removeAt(0);
    }
  }

  void _compareIndex(int index) {
    List<int> missStepList = [];
    if (_lastIndex == 255) {
      _lastIndex = 0;
    } else {
      _lastIndex++;
    }
    if (index != _lastIndex) {
      int total = index - _lastIndex;
      if (total < 0) {
        for (int i = 0; i < index; i++) {
          missStepList.add(i);
        }
        if (255 - _lastIndex >= 0) {
          for (int i = _lastIndex; i <= 255; i++) {
            missStepList.add(i);
          }
        }
      } else {
        for (int i = _lastIndex; i < index; i++) {
          missStepList.add(i);
        }
      }
      LogUtil.d("发生丢步 ------ $missStepList");
      _lastIndex = index;
      _missStepIndexList.addAll(missStepList);
      _handleLostSteps();
    }
  }

  void _afterSuccess(int index) {
    if (_lastIndex == index) return;

    if (_lastIndex == 255) {
      _lastIndex = 0;
    } else {
      _lastIndex++;
    }

    List<int> missStepList = [];
    if (index != _lastIndex) {
      int total = index - _lastIndex;
      if (total < 0) {
        for (int i = 0; i < index; i++) {
          missStepList.add(i);
        }
        if (255 - _lastIndex >= 0) {
          for (int i = _lastIndex; i <= 255; i++) {
            missStepList.add(i);
          }
        }
      } else {
        for (int i = _lastIndex; i <= index; i++) {
          missStepList.add(i);
        }
      }
      LogUtil.d("发生丢步 ------ $missStepList");
      _lastIndex = index;
      _missStepIndexList.addAll(missStepList);
      _handleLostSteps();
    } else {}
  }
}
