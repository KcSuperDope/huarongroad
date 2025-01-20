import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/module/game/game.dart';

class HrdBoardBackground extends StatelessWidget {
  final Game game;
  final double width;

  const HrdBoardBackground({
    Key? key,
    required this.width,
    required this.game,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String boardBg = game.opening.isNotEmpty
        ? game.mode.value == GameMode.rank
            ? "lib/assets/png/board_rank.png"
            : "lib/assets/png/board_bg.png"
        : "lib/assets/png/board_bg_radius.png";
    String boardBgError = "lib/assets/png/board_error.png";
    String boardBgAI = "lib/assets/png/board_ai.png";
    return Obx(
      () => Image.asset(
        game.state.value == GameState.error ? boardBgError : (game.isInAI.value ? boardBgAI : boardBg),
        width: width,
        fit: BoxFit.fill,
      ),
    );
  }
}
