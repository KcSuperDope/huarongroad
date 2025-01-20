import 'dart:async';

import 'package:get/get.dart';
import 'package:huaroad/module/game/game_my_step.dart';
import 'package:huaroad/module/piece/piece.dart';
import 'package:huaroad/module/piece/piece_model.dart';

class LongTimeGuide {
  final maxGuideCount = 10;
  final lastSolutionCount = 5;
  final double _firstDuration = 10;
  final double _duration = 1.0;
  final isInGuiding = false.obs;

  Timer? _timer;

  int currentStepX = -1;
  int currentStepY = -1;

  List<PieceModel> pieceList = [];
  Future Function()? getSolution;
  String getControllerTag = "";
  bool _isInAI = false;
  int _guideCount = 0;
  bool _isFirst = true;

  void refreshTime() {
    if (_isInAI) return;
    if (_guideCount >= maxGuideCount) return;

    _cancel();
    _startTimer();
  }

  void listen(bool isInAI) {
    _isInAI = isInAI;
    if (_isInAI) exit();
  }

  void reset() {
    _isFirst = true;
    exit(isFinish: true);
  }

  void exit({bool isFinish = false}) {
    isInGuiding.value = false;
    currentStepY = -1;
    currentStepX = -1;
    if (isFinish) {
      _guideCount = 0;
      _cancel();
    }
  }

  void _startTimer() {
    _timer = Timer((_isFirst ? _firstDuration : _duration).seconds, () => _enter());
  }

  void _cancel() {
    _timer?.cancel();
  }

  // 进入指引模式
  void _enter() async {
    if (_isInAI) return;
    if (_guideCount >= maxGuideCount) return;
    final models = await getSolution!();
    if ((models as List).length < lastSolutionCount) return;
    if (models.isNotEmpty) {
      MyStep step = models.first.step;
      currentStepX = step.moves.first.x;
      currentStepY = step.moves.first.y;
      for (var element in pieceList) {
        if (element.dx == currentStepX && element.dy == currentStepY) {
          int toX = step.moves.first.toX;
          int toY = step.moves.first.toY;
          if (toX > 0) {
            element.arrowDirection = Direction.right;
            element.arrowAngle = 0;
            element.arrowPositionTop = element.kind == 3 || element.kind == 4 ? 0.5 : 0;
            element.arrowPositionLeft = element.kind == 2 || element.kind == 4 ? 1 : 0;
          }
          if (toX < 0) {
            element.arrowDirection = Direction.left;
            element.arrowAngle = 2.0;
            element.arrowPositionTop = element.kind == 3 || element.kind == 4 ? 0.5 : 0;
            element.arrowPositionLeft = -1;
          }

          if (toY > 0) {
            element.arrowDirection = Direction.down;
            element.arrowAngle = 1.5;
            element.arrowPositionTop = element.kind == 3 || element.kind == 4 ? 1 : 0;
            element.arrowPositionLeft = element.kind == 2 || element.kind == 4 ? 0.5 : 0;
          }
          if (toY < 0) {
            element.arrowDirection = Direction.up;
            element.arrowAngle = 0.5;
            element.arrowPositionTop = -1;
            element.arrowPositionLeft = element.kind == 2 || element.kind == 4 ? 0.5 : 0;
          }

          isInGuiding.value = true;
          _guideCount++;
          _isFirst = false;
          Get.find<HRPieceController>(tag: getControllerTag).update([element.id!]);
        }
      }
    }
  }
}
