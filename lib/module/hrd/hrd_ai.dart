import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/piece/piece_model.dart';
import 'package:huaroad/styles/styles.dart';

class HrdAi extends StatelessWidget {
  final Game game;
  final double size;
  final PieceModel piece;

  const HrdAi({
    Key? key,
    required this.game,
    required this.size,
    required this.piece,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: game.isInAI.value,
        child: piece.dx != null
            ? Positioned(
                left: ui_board_padding + (piece.dx! + game.aiTeach.animationValue.value * piece.tox!) * size,
                top: ui_board_padding + (piece.dy! + game.aiTeach.animationValue.value * piece.toy!) * size,
                child: Opacity(
                  opacity: 0.20,
                  child: Container(
                    width: piece.width! * size,
                    height: piece.height! * size,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Image.asset(
                          "lib/assets/png/piece/piece_${piece.isNumber! ? "num" : piece.kind ?? ""}_empty.png",
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                          top: size * piece.arrowPositionTop!,
                          left: size * piece.arrowPositionLeft!,
                          child: Transform.rotate(
                            angle: pi * piece.arrowAngle!,
                            child: Image.asset(
                              "lib/assets/png/icon_run.png",
                              width: size / 2,
                              height: size / 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
