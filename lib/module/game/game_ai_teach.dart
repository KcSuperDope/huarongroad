import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/module/game/game_my_step.dart';
import 'package:huaroad/module/game/game_teach_model.dart';
import 'package:huaroad/module/piece/piece.dart';
import 'package:huaroad/module/piece/piece_model.dart';

class AITeach {
  final teachModel = PieceModel().obs;
  final animationValue = 1.0.obs;
  AnimationController? teachAnimationController;

  // 匹配教学
  void matchingNextTeachStep(List<TeachModel> teachModels, List<PieceModel> pieceList, String tag) {
    if (teachModels.isNotEmpty) {
      MyStep step = MyStep();
      step = teachModels.first.step;
      for (var element in pieceList) {
        if (element.dx == step.moves.first.x && element.dy == step.moves.first.y) {
          int toX = step.moves.first.toX;
          int toY = step.moves.first.toY;
          if (toX > 0) {
            element.arrowDirection = Direction.right;
            element.arrowAngle = 0.5;
          }
          if (toX < 0) {
            element.arrowDirection = Direction.left;
            element.arrowAngle = 1.5;
          }
          if (toY > 0) {
            element.arrowDirection = Direction.down;
            element.arrowAngle = 1.0;
          }
          if (toY < 0) {
            element.arrowDirection = Direction.up;
            element.arrowAngle = 0.0;
          }

          PieceModel tm = element.clone();
          tm.tox = step.moves.first.toX;
          tm.toy = step.moves.first.toY;
          tm.arrowPositionTop = 0.25 + _getTop(tm);
          tm.arrowPositionLeft = 0.25 + _getLeft(tm);
          teachModel.value = tm;
          teachAnimationController!.reset();
          teachAnimationController!.forward();
          teachAnimationController!.addListener(() {
            animationValue.value = teachAnimationController!.value;
          });
          Get.find<HRPieceController>(tag: tag).update();
        }
      }
    }
  }

  double _getTop(PieceModel piece) {
    double a = 0.0;
    if (piece.kind == 3 || piece.kind == 4) {
      if (piece.arrowDirection == Direction.left || piece.arrowDirection == Direction.right) {
        a = 0.5;
      }
      if (piece.arrowDirection == Direction.down) {
        a = 1.0;
      }
    }
    return a;
  }

  double _getLeft(PieceModel piece) {
    double a = 0.0;
    if (piece.kind == 2 || piece.kind == 4) {
      if (piece.arrowDirection == Direction.up || piece.arrowDirection == Direction.down) {
        a = 0.5;
      }
      if (piece.arrowDirection == Direction.right) {
        a = 1.0;
      }
    }
    return a;
  }
}
