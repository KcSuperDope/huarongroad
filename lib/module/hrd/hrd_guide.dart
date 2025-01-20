import 'package:flutter/material.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/piece/piece_model.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:lottie/lottie.dart';

class HrdGuide extends StatelessWidget {
  final Game game;
  final double size;
  final PieceModel model;

  HrdGuide({Key? key, required this.game, required this.size, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (game.state.value == GameState.fail || game.state.value == GameState.success) return const SizedBox();
    if (model.arrowPositionLeft == null && model.arrowPositionTop == null) return SizedBox();
    String direction = "left";
    if (model.arrowDirection == Direction.right) direction = "right";
    if (model.arrowDirection == Direction.up) direction = "up";
    if (model.arrowDirection == Direction.down) direction = "down";
    if (game.guide.isInGuiding.value && game.guide.currentStepX == model.dx && game.guide.currentStepY == model.dy) {
      return SizedBox(
        height: size * ((model.arrowDirection == Direction.up || model.arrowDirection == Direction.down) ? 2 : 1),
        width: size * ((model.arrowDirection == Direction.left || model.arrowDirection == Direction.right) ? 2 : 1),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: ui_board_padding + size * model.arrowPositionLeft!,
              top: size * model.arrowPositionTop!,
              child: Lottie.asset("lib/assets/lottie/animation_arrow_$direction.json"),
            ),
            Positioned(
              left: ui_board_padding + size * model.arrowPositionLeft!,
              top: size * model.arrowPositionTop!,
              child: Lottie.asset("lib/assets/lottie/animation_finger_$direction.json"),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
