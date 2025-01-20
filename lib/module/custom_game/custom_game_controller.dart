import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/custom_game/custom_game_page.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_engine.dart';
import 'package:huaroad/module/game/game_teach_model.dart';
import 'package:huaroad/module/game/hrd_game/hrd_game.dart';
import 'package:huaroad/module/game/num_game/num_game.dart';
import 'package:huaroad/module/home/free_controller.dart';
import 'package:huaroad/module/piece/piece_handler.dart';
import 'package:huaroad/module/piece/piece_model.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/logger.dart';

enum BoardState { error, noSolution, success, normal, analysis }

class CustomGameController extends GetxController {
  double boardX = 0;
  double boardY = 0;
  GlobalKey anchorKey = GlobalKey();
  GlobalKey boardKey = GlobalKey();
  final size = (Get.width - ui_page_padding * 2 - ui_board_padding * 2) / 4;
  final currentX = (-1).obs;
  final currentY = (-1).obs;
  final currentPiece = PieceModel().obs;
  final bottomList = <PieceModel>[].obs;
  final acceptList = <PieceModel>[].obs;
  final currentMatrixString = "".obs;
  final gameType = Get.arguments ?? GameType.hrd;
  final isBoardFinish = false.obs;
  var successNumBoard = [];
  int edgeX = 4;
  int edgeY = 5;
  int maxNumber = 19;
  int startNumber = 1;
  final currentBoardState = BoardState.normal.obs;
  final currentBoardString = "".obs;
  final currentBoardImage = "".obs;
  var totalNumberList = [];

  @override
  void onInit() {
    super.onInit();
    bottomList.value = gameType == GameType.hrd
        ? [
            PieceModel(
                id: 3,
                dx: -1,
                dy: -1,
                width: 2.0,
                height: 2.0,
                color: color_9CBD00,
                kind: 4,
                image: "lib/assets/png/piece/piece_4.png",
                limitCount: 1),
            PieceModel(
                id: 2,
                dx: -1,
                dy: -1,
                width: 1.0,
                height: 2.0,
                color: color_9CBD00,
                kind: 3,
                image: "lib/assets/png/piece/piece_3.png",
                limitCount: 4),
            PieceModel(
                id: 0,
                dx: -1,
                dy: -1,
                width: 1.0,
                height: 1.0,
                color: color_9CBD00,
                kind: 1,
                image: "lib/assets/png/piece/piece_1.png",
                limitCount: 8),
            PieceModel(
                id: 1,
                dx: -1,
                dy: -1,
                width: 2.0,
                height: 1.0,
                color: color_9CBD00,
                kind: 2,
                image: "lib/assets/png/piece/piece_2.png",
                limitCount: 4),
          ]
        : [
            PieceModel(
                id: 1,
                dx: -1,
                dy: -1,
                width: 1.0,
                height: 1.0,
                kind: 1,
                color: color_9CBD00,
                limitCount: maxNumber,
                isNumber: true,
                image: "lib/assets/png/piece/piece_num_empty.png",
                number: startNumber),
          ];
    currentPiece.value = bottomList.first;
    if (gameType == GameType.number3x3) {
      edgeX = 3;
      edgeY = 3;
      maxNumber = 8;
    } else if (gameType == GameType.number4x4) {
      edgeY = 4;
      maxNumber = 15;
    }
    acceptList.addAll(PieceHandler().createLockList(gameType));
    totalNumberList = List.generate(maxNumber, (index) => index + 1);
    successNumBoard = List.generate(maxNumber, (index) => index + 1);
    successNumBoard.add(0);
  }

  bool check() {
    if (gameType != GameType.hrd) {
      int index = 0;
      for (var value in acceptList) {
        if (value.kind! > 0) index++;
      }
      return index == maxNumber;
    }

    List<int> list = List.filled(20, 0);
    int fourNum = 0;
    for (var piece in acceptList) {
      if (piece.kind! < 0) continue;
      if (piece.kind! == 4) fourNum++;
      var places = piece.place(4);
      for (var idx in places) {
        list[idx] = piece.kind!;
      }
    }
    int index = 0;
    for (int val in list) {
      if (val == 0) index++;
    }
    if (index != 2) {
      return false;
    }
    if (fourNum != 1) {
      return false;
    }
    return true;
  }

  void onSyncBoard() async {
    updateBoardState(BoardState.analysis);
    if (!check()) {
      updateBoardState(BoardState.error);
      return;
    }

    if (gameType != GameType.hrd) {
      final list = List.generate(maxNumber + 1, (index) => 0);
      for (var piece in acceptList) {
        if (piece.kind! > 0) {
          list[piece.place(edgeX).first] = piece.number!;
        }
      }
      if (list.toString() == successNumBoard.toString()) {
        updateBoardState(BoardState.success);
        return;
      } else if (!GameEngine().hasSolution(list)) {
        updateBoardState(BoardState.noSolution);
        return;
      } else {
        NumGame game = NumGame.fromData(list.join(" "));
        Future.delayed(const Duration(milliseconds: 1500), () {
          Get.find<FreeController>().game.value = game;
          Get.find<FreeController>().connectGame(
            isConnected: FindDeviceHandler().deviceConnected.value,
          );
          Get.back();
        });
      }
      return;
    }

    for (var piece in acceptList) {
      if (piece.kind! == 4) {
        if (piece.dy == 3 && piece.dx == 1) {
          updateBoardState(BoardState.success);
          return;
        }
      }
    }

    HrdGame game = HrdGame.fromData(getCurrentMatrixString());
    game.pieceList.value = PieceHandler().createModelList(game.openingMatrix, GameType.hrd);
    final List<TeachModel> sol = await game.getSolutionModel();
    if (sol.isEmpty) {
      updateBoardState(BoardState.noSolution);
    } else {
      Future.delayed(const Duration(milliseconds: 1500), () {
        Get.find<FreeController>().game.value = game;
        Get.find<FreeController>().connectGame(
          isConnected: FindDeviceHandler().deviceConnected.value,
        );
        Get.back();
      });
    }
  }

  void updateBoardState(BoardState state) {
    currentBoardState.value = state;
    switch (state) {
      case BoardState.analysis:
        currentBoardImage.value = "lib/assets/png/tip_loading.png";
        currentBoardString.value = "棋局解析中...";
        break;
      case BoardState.noSolution:
        currentBoardImage.value = "lib/assets/png/tip_fail.png";
        currentBoardString.value = S.Thischessgamehasnosolutionpleaserearrangethepieces;
        break;
      case BoardState.success:
        currentBoardImage.value = "lib/assets/png/tip_fail.png";
        currentBoardString.value = S.Thischessgameiscompletedpleaserearrange;
        break;
      case BoardState.error:
        // TODO: Handle this case.
        break;
      case BoardState.normal:
        // TODO: Handle this case.
        break;
    }
  }

  String getCurrentMatrixString() {
    String res = "";
    List<int> list = List.filled(20, 0);
    for (var piece in acceptList) {
      if (piece.kind! < 0) continue;
      var places = piece.place(4);
      for (var idx in places) {
        list[idx] = piece.kind!;
      }
    }
    for (int val in list) {
      res += val.toString();
    }
    return res;
  }

  void onDragStart(PieceModel model) {
    if (!model.available!) return;
    currentPiece.value = model;
    if (boardX != 0 || boardY != 0) return;
    RenderBox box = boardKey.currentContext?.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(Offset.zero);
    boardX = offset.dx;
    boardY = offset.dy;
  }

  void onDragUpdate(DragUpdateDetails details, PieceModel model) {
    if (!model.available!) return;
    if (anchorKey.currentContext?.findRenderObject() == null) return;
    RenderBox box = anchorKey.currentContext?.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(Offset.zero);
    double dx = offset.dx - boardX;
    double dy = offset.dy - boardY;
    int x = (dx + size / 2) ~/ size;
    int y = (dy + size / 2) ~/ size;
    // 越界
    if (dx < 0 ||
        dy < 0 ||
        dx > size * edgeX ||
        dy > size * edgeY ||
        (x + model.width!) > edgeX ||
        (y + model.height!) > edgeY) {
      currentX.value = -1;
      currentY.value = -1;
      return;
    }
    PieceModel tempModel = model.clone();
    tempModel.dx = x;
    tempModel.dy = y;
    if (acceptList.any((element) => element.overlaps(tempModel))) {
      currentX.value = -1;
      currentY.value = -1;
    } else {
      currentX.value = x;
      currentY.value = y;
    }
  }

  void onDragEnd(DraggableDetails details, PieceModel model, GetxController c) {
    if (!model.available!) return;
    if (currentX.value == -1 || currentY.value == -1) return;
    PieceModel cloneModel = model.clone();
    cloneModel.dx = currentX.value;
    cloneModel.dy = currentY.value;
    if (!acceptList.any((element) => element.overlaps(cloneModel))) {
      acceptList.add(cloneModel);
      if (model.isNumber!) {
        totalNumberList.removeWhere((element) => element == model.number);
        model.available = totalNumberList.isNotEmpty;
        if (totalNumberList.isNotEmpty) {
          model.number = totalNumberList.first;
        } else {
          model.number = maxNumber + 1;
        }
      } else {
        model.limitCount = model.limitCount! - 1;
        model.available = model.limitCount! > 0;
      }
      c.update([model.id!]);
      isBoardFinish.value = check();
      if (isBoardFinish.value) {
        for (var element in bottomList) {
          element.available = false;
        }
        Get.find<BottomPieceController>().update([0, 1, 2, 3]);
      }
    }
    currentX.value = -1;
    currentY.value = -1;
  }

  void onResetBoard() {
    acceptList.clear();
    acceptList.addAll(PieceHandler().createLockList(gameType));
    currentBoardState.value = BoardState.normal;
    totalNumberList = List.generate(maxNumber, (index) => index + 1);
    for (var element in bottomList) {
      if (element.kind == 1) element.limitCount = 8;
      if (element.kind == 2) element.limitCount = 4;
      if (element.kind == 3) element.limitCount = 4;
      if (element.kind == 4) element.limitCount = 1;
      if (element.isNumber!) element.number = startNumber;
      element.available = true;
    }
    isBoardFinish.value = false;
    Get.find<BottomPieceController>().update([0, 1, 2, 3]);
  }

  void onDoubleTap(PieceModel model) {
    if (model.kind! < 0) return;
    acceptList.remove(model);
    if (model.isNumber!) {
      totalNumberList.insert(0, model.number!);
      bottomList.first.number = totalNumberList.first;
      bottomList.first.available = totalNumberList.isNotEmpty;
      Get.find<BottomPieceController>().update([model.id!]);
    } else {
      try {
        PieceModel bottomM = bottomList.firstWhere((element) => element.id == model.id);
        bottomM.limitCount = bottomM.limitCount! + 1;
        bottomM.available = bottomM.limitCount! > 0;
        Get.find<BottomPieceController>().update([bottomM.id!]);
      } catch (e) {
        LogUtil.d(e);
      }
    }
  }
}
