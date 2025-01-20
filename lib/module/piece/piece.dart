import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/audio_palyer.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_step.dart';
import 'package:huaroad/module/hrd/hrd_guide.dart';
import 'package:huaroad/module/piece/piece_model.dart';
import 'package:huaroad/styles/styles.dart' '';

enum CCDirection { both, x, y }

class HRPieceController extends GetxController {
  int movingId = -1;
}

class Piece extends StatelessWidget {
  final double size;
  final Game? game;
  final PieceModel model;
  final double? pieceSpace;
  final void Function(PieceModel model)? onDoubleTap;

  Piece({
    Key? key,
    this.game,
    this.onDoubleTap,
    this.pieceSpace,
    required this.model,
    required this.size,
  }) : super(key: key);

  var _dx = 0.0;
  var _dy = 0.0;
  var _dir = "";

  bool _canMoveLeft = false;
  bool _canMoveRight = false;
  bool _canMoveUp = false;
  bool _canMoveDown = false;
  bool _canMoveLeftTwo = false;
  bool _canMoveRightTwo = false;
  bool _canMoveUpTwo = false;
  bool _canMoveDownTwo = false;

  bool _canMoveLeftUp = false;
  bool _canMoveLeftDown = false;
  bool _canMoveRightUp = false;
  bool _canMoveRightDown = false;
  bool _canMoveUpLeft = false;
  bool _canMoveUpRight = false;
  bool _canMoveDownLeft = false;
  bool _canMoveDownRight = false;

  double _diffX = 0.0;
  double _diffY = 0.0;

  final threshold = 0.15;
  final curveThreshold = 0.25;

  double _maxLeft = 0.0;
  double _maxRight = 0.0;
  double _maxUp = 0.0;
  double _maxDown = 0.0;

  CCDirection _ccDirection = CCDirection.both;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HRPieceController>(
      id: model.id,
      init: HRPieceController(),
      tag: game != null ? game!.tag : "tag",
      initState: (_) {},
      builder: (c) {
        return AnimatedPositioned(
          left: (model.dx! + _dx) * size,
          top: (model.dy! + _dy) * size,
          duration: Duration(milliseconds: game == null ? 0 : game!.animationDuration.value),
          child: GestureDetector(
            onPanStart: (details) {
              if (model.kind! < 0) return;
              if (game == null) return;
              if (game!.allowPlay.value == false) return;
              if (game!.isConnected.value) {
                Fluttertoast.showToast(msg: S.Pleaseoperatesmartdevice.tr);
                return;
              }

              game?.guide.exit();

              if (c.movingId >= 0) return;
              c.movingId = model.id!;

              _canMoveLeft = false;
              _canMoveRight = false;
              _canMoveUp = false;
              _canMoveDown = false;

              _canMoveLeftTwo = false;
              _canMoveRightTwo = false;
              _canMoveUpTwo = false;
              _canMoveDownTwo = false;

              _canMoveLeftUp = false;
              _canMoveLeftDown = false;
              _canMoveRightUp = false;
              _canMoveRightDown = false;
              _canMoveUpLeft = false;
              _canMoveUpRight = false;
              _canMoveDownLeft = false;
              _canMoveDownRight = false;

              _ccDirection = CCDirection.both;

              _maxUp = 0.0;
              _maxDown = 0.0;
              _maxLeft = 0.0;
              _maxRight = 0.0;

              _dx = 0.0;
              _dy = 0.0;
              final x = model.dx!;
              final y = model.dy!;

              _canMoveDown = game!.canMove(model, x, y + 1);
              _canMoveUp = game!.canMove(model, x, y - 1);
              _canMoveLeft = game!.canMove(model, x - 1, y);
              _canMoveRight = game!.canMove(model, x + 1, y);

              if (_canMoveDown) {
                _canMoveDownTwo = game!.canMove(model, x, y + 2);
                if (!_canMoveDownTwo) {
                  _canMoveDownLeft = game!.canMove(model, x - 1, y + 1);
                  if (!_canMoveDownLeft) _canMoveDownRight = game!.canMove(model, x + 1, y + 1);
                }
              }
              if (_canMoveUp) {
                _canMoveUpTwo = game!.canMove(model, x, y - 2);
                if (!_canMoveUpTwo) {
                  _canMoveUpLeft = game!.canMove(model, x - 1, y - 1);
                  if (!_canMoveUpLeft) _canMoveUpRight = game!.canMove(model, x + 1, y - 1);
                }
              }
              if (_canMoveLeft) {
                _canMoveLeftTwo = game!.canMove(model, x - 2, y);
                if (!_canMoveLeftTwo) {
                  _canMoveLeftUp = game!.canMove(model, x - 1, y - 1);
                  if (!_canMoveLeftUp) _canMoveLeftDown = game!.canMove(model, x - 1, y + 1);
                }
              }
              if (_canMoveRight) {
                _canMoveRightTwo = game!.canMove(model, x + 2, y);
                if (!_canMoveRightTwo) {
                  _canMoveRightUp = game!.canMove(model, x + 1, y - 1);
                  if (!_canMoveRightUp) _canMoveRightDown = game!.canMove(model, x + 1, y + 1);
                }
              }

              if (_canMoveRight || _canMoveRightTwo) {
                _maxRight = _canMoveRightTwo ? 2.0 : 1.0;
                if (_canMoveRightUp) {
                  _maxUp = -1.0;
                }
                if (_canMoveRightDown) {
                  _maxDown = 1.0;
                }
              }

              if (_canMoveLeft || _canMoveLeftTwo) {
                _maxLeft = _canMoveLeftTwo ? -2.0 : -1.0;
                if (_canMoveLeftUp) {
                  _maxUp = -1.0;
                }
                if (_canMoveLeftDown) {
                  _maxDown = 1.0;
                }
              }

              if (_canMoveUp || _canMoveUpTwo) {
                _maxUp = _canMoveUpTwo ? -2.0 : -1.0;
                if (_canMoveUpRight) {
                  _maxRight = 1.0;
                }
                if (_canMoveUpLeft) {
                  _maxLeft = -1.0;
                }
              }

              if (_canMoveDown || _canMoveDownTwo) {
                _maxDown = _canMoveDownTwo ? 2.0 : 1.0;
                if (_canMoveDownRight) {
                  _maxRight = 1.0;
                }
                if (_canMoveDownLeft) {
                  _maxLeft = -1.0;
                }
              }
            },
            onPanUpdate: (details) {
              if (model.kind! < 0) return;
              if (game == null) return;
              if (game!.isConnected.value) return;
              if (game!.allowPlay.value == false) return;
              if (c.movingId != model.id) return;

              final ddx = details.delta.dx;
              final ddy = details.delta.dy;

              _diffX += ddx / size;
              _diffY += ddy / size;

              if (_diffX < _maxLeft) _diffX = _maxLeft;
              if (_diffX > _maxRight) _diffX = _maxRight;
              if (_diffY < _maxUp) _diffY = _maxUp;
              if (_diffY > _maxDown) _diffY = _maxDown;

              if ((_canMoveUp && _canMoveLeft) ||
                  (_canMoveUp && _canMoveRight) ||
                  (_canMoveDown && _canMoveLeft) ||
                  (_canMoveDown && _canMoveRight)) {
                /// 同时具有x和y轴方向上的移动
                if (_diffX.abs() <= 0.1 && _diffY.abs() <= 0.1) {
                  _ccDirection = CCDirection.both;
                }

                if (_ccDirection == CCDirection.both) {
                  if (ddx.abs() > ddy.abs()) {
                    _ccDirection = CCDirection.x;
                  }
                  if (ddy.abs() > ddx.abs()) {
                    _ccDirection = CCDirection.y;
                  }
                }
                if (_ccDirection == CCDirection.x) {
                  _dx = _diffX;
                  _diffY = 0;
                  _dy = 0;
                }
                if (_ccDirection == CCDirection.y) {
                  _dy = _diffY;
                  _diffX = 0;
                  _dx = 0;
                }
              } else {
                _dx = _diffX;
                _dy = _diffY;

                /// distance 大于1.0 表示已经拐弯
                final distance = math.sqrt(_dx * _dx + _dy * _dy);

                if (_canMoveDownLeft || _canMoveDownRight || _canMoveUpLeft || _canMoveUpRight) {
                  if (distance < 1.0 && _dy.abs() < 1.0) {
                    _dx = 0;
                    _diffX = 0.0;
                  }

                  /// 消除掉 y 轴的影响
                  if (distance > 1.0 && _diffY != _maxUp && _diffY != _maxDown) {
                    _diffY -= ddy / size;
                    _dy = _diffY;
                  }
                }

                if (_canMoveLeftUp || _canMoveLeftDown || _canMoveRightUp || _canMoveRightDown) {
                  if (distance < 1.0 && _dx.abs() < 1.0) {
                    _dy = 0;
                    _diffY = 0.0;
                  }

                  /// 消除掉 x 轴的影响
                  if (distance > 1.0 && _diffX != _maxLeft && _diffX != _maxRight) {
                    _diffX -= ddx / size;
                    _dx = _diffX;
                  }
                }
              }

              final currentX = (model.dx! + _dx) * size;
              final currentY = (model.dy! + _dy) * size;
              bool isCollision = game!.pieceList.any((element) => (element != model &&
                  isPieceCollision(
                      Offset(currentX, currentY),
                      Size(model.width! * size, model.height! * size),
                      Offset(element.dx! * size, element.dy! * size),
                      Size(element.width! * size, element.height! * size))));

              if (isCollision) return;

              c.update([model.id!]);
            },
            onPanEnd: (details) {
              if (game!.allowPlay.value == false) return;
              if (c.movingId != model.id) return;

              int moveCount = 0;
              String pieceMoveInfo = "";
              if (_canMoveRight && _dx > threshold) {
                _dir = "R";
                moveCount = 1;
                pieceMoveInfo = "${model.id!}$_dir";
                if (_canMoveRightTwo && _dx.abs() > 1 + threshold) {
                  moveCount = 2;
                  pieceMoveInfo += "${model.id!}$_dir";
                }
                if ((_canMoveRightUp || _canMoveRightDown) && _dy.abs() > curveThreshold) {
                  moveCount = 2;
                  pieceMoveInfo += "${model.id!}${_canMoveRightUp ? "U" : "D"}";
                }
              } else if (_canMoveLeft && _dx < -threshold) {
                _dir = "L";
                moveCount = 1;
                pieceMoveInfo = "${model.id!}$_dir";
                if (_canMoveLeftTwo && _dx.abs() > 1 + threshold) {
                  moveCount = 2;
                  pieceMoveInfo += "${model.id!}$_dir";
                }
                if ((_canMoveLeftUp || _canMoveLeftDown) && _dy.abs() > curveThreshold) {
                  moveCount = 2;
                  pieceMoveInfo += "${model.id!}${_canMoveLeftUp ? "U" : "D"}";
                }
              } else if (_canMoveDown && _dy > threshold) {
                _dir = "D";
                moveCount = 1;
                pieceMoveInfo = "${model.id!}$_dir";
                if (_canMoveDownTwo && _dy > (1 + threshold)) {
                  moveCount = 2;
                  pieceMoveInfo += "${model.id!}$_dir";
                }
                if ((_canMoveDownLeft || _canMoveDownRight) && _dx.abs() > curveThreshold) {
                  moveCount = 2;
                  pieceMoveInfo += "${model.id!}${_canMoveDownLeft ? "L" : "R"}";
                }
              } else if (_canMoveUp && _dy < -threshold) {
                _dir = "U";
                moveCount = 1;
                pieceMoveInfo = "${model.id!}$_dir";
                if (_canMoveUpTwo && _dy.abs() > 1 + threshold) {
                  moveCount = 2;
                  pieceMoveInfo += "${model.id!}$_dir";
                }
                if ((_canMoveUpLeft || _canMoveUpRight) && _dx.abs() > curveThreshold) {
                  moveCount = 2;
                  pieceMoveInfo += "${model.id!}${_canMoveUpLeft ? "L" : "R"}";
                }
              }

              if (moveCount > 0) {
                GameStep step = GameStep();
                step.timestamp = game!.timerWatch.elapsedMilliseconds;
                step.pieceMoveCount = moveCount;
                step.addPieceMoveInfo(info: pieceMoveInfo);
                step.index = game!.history.steps.length;
                game!.receiveStep(step);

                HRAudioPlayer().playPieceMove();
              }

              c.movingId = -1;
            },
            onDoubleTap: () {
              if (onDoubleTap != null) {
                onDoubleTap!(model);
              }
            },
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                PieceWidget(model: model, size: size, pieceSpace: pieceSpace),
                if (model.kind! > 0) HrdGuide(game: game!, size: size, model: model)
              ],
            ),
          ),
        );
      },
    );
  }

  bool isPieceCollision(Offset a, Size aSize, Offset b, Size bSize) {
    if (a.dx + aSize.width <= b.dx || b.dx + bSize.width <= a.dx) return false;
    if (a.dy + aSize.height <= b.dy || b.dy + bSize.height <= a.dy) return false;
    return true;
  }
}

class PieceWidget extends StatelessWidget {
  final double size;
  final double? pieceSpace;
  final PieceModel model;

  const PieceWidget({
    Key? key,
    required this.model,
    required this.size,
    this.pieceSpace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Opacity(
          opacity: (model.state == PieceState.empty || (model.available != null && !model.available!)) ? 0.4 : 1.0,
          child: Container(
            width: model.width! * size,
            height: model.height! * size,
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(pieceSpace ?? 1.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  color: model.isLock != null && model.isLock! ? color_D1DADF : Colors.transparent),
              child: model.isLock != null && model.isLock!
                  ? Image.asset("lib/assets/png/piece/piece_lock.png", width: 30, height: 30)
                  : model.image != null
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(model.image!, fit: BoxFit.cover),
                            if (model.isNumber!)
                              Image.asset(
                                "lib/assets/png/piece/number_${model.number!}.png",
                                color: model.numberColor,
                              ),
                          ],
                        )
                      : const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}
