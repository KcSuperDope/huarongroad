import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/common/time_watch_widget.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/dialog_util.dart';

class HrdTitle extends StatelessWidget {
  const HrdTitle({
    Key? key,
    required this.game,
  }) : super(key: key);
  final Game game;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(image: _buildBoardTitleImage(game)),
        height: 48,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Visibility(
          visible: game.state.value != GameState.success,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLeft(game),
                  _buildRight(game),
                ],
              ),
              _buildCenter(game),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeft(Game game) {
    Widget child = const SizedBox(width: 24);

    if (game.state.value == GameState.onGoing && game.mode.value == GameMode.rank) {
      return child;
    }

    if (game.state.value == GameState.prepare) {
      child = Image.asset("lib/assets/png/icon_lock.png", width: 24, height: 24);
    }

    if (game.isInAI.value || game.state.value == GameState.onGoing || game.state.value == GameState.success) {
      child = Row(
        children: [
          Visibility(
            visible: game.isInAI.value,
            child: Text(
              S.remaining.tr,
              style: const TextStyle(
                fontSize: 14,
                color: color_minor_text,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Obx(() => Text(
                "${game.isInAI.value ? game.teachModels.length : game.history.totalCount.value}",
                style: const TextStyle(
                  fontSize: 14,
                  color: color_main_text,
                  fontWeight: FontWeight.w400,
                ),
              )),
          Text(
            S.Move.tr,
            style: const TextStyle(
              fontSize: 14,
              color: color_minor_text,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }

    return child;
  }

  Widget _buildCenter(Game game) {
    Widget child = const SizedBox();

    if (game.isInAI.value ||
        game.state.value == GameState.prepare ||
        game.state.value == GameState.ready ||
        (game.state.value == GameState.onGoing && game.mode.value == GameMode.rank)) {
      child = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24 + 6),
        child: Text(
          _title(game).tr,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else {
      child = TimeWatchWidget(timer: game.timerWatch.timerString);
    }

    return child;
  }

  String _title(Game game) {
    String res = "";

    if (game.isInAI.value) {
      return S.AITutorial;
    }

    switch (game.state.value) {
      case GameState.prepare:
        res = S.pressOKafterplacingthepieces;
        break;
      case GameState.ready:
        res = S.SlideTime;
        break;
      case GameState.onGoing:
        res = S.solving;
        break;
    }
    return res;
  }

  Widget _buildRight(Game game) {
    if (game.state.value == GameState.onGoing && game.mode.value == GameMode.rank) {
      return const SizedBox(width: 24);
    }

    if (game.isInAI.value) {
      return GestureDetector(
        onTap: () => game.switchAIMode(),
        child: Image.asset("lib/assets/png/close_ai.png", width: 16, height: 16),
      );
    }
    if (game.state.value == GameState.onGoing) {
      return SoundGestureDetector(
        onTap: () {
          DialogUtils.showAlert(
            title: S.Giveupchallenge,
            content: S.failurewithoutfinishStillquit,
            showClose: false,
            onTapRight: () => game.fail(playAudio: true, userCancel: true),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
              border: Border.all(color: color_main_text, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          child: Text(S.quit.tr, style: const TextStyle(fontSize: 14, color: Colors.red)),
        ),
      );
    }
    return const SizedBox(width: 24);
  }

  DecorationImage _buildBoardTitleImage(Game game) {
    String titleImage =
        game.mode.value == GameMode.rank ? "lib/assets/png/board_title_rank.png" : "lib/assets/png/board_title.png";
    if (game.state.value == GameState.error) {
      titleImage = "lib/assets/png/board_title_error.png";
    }
    if (game.isInAI.value) {
      titleImage = "lib/assets/png/board_title_ai.png";
    }
    return DecorationImage(image: ExactAssetImage(titleImage), fit: BoxFit.fill, alignment: Alignment.topCenter);
  }
}
