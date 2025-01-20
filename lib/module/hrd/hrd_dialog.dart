import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_share.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/dialog_util.dart';
import 'package:huaroad/util/time_util.dart';

class HrdCommonDialog extends StatelessWidget {
  final Game game;
  final int starNum;
  final bool? newRecord;
  final bool? userCancel;
  final double? tps;
  final String? title;
  final String? leftText;
  final String? rightText;
  final String imageName;
  final int? lastStepCount;

  const HrdCommonDialog({
    Key? key,
    this.tps,
    this.title,
    this.leftText,
    this.rightText,
    this.userCancel = false,
    this.newRecord = false,
    this.imageName = "success",
    this.lastStepCount,
    required this.starNum,
    required this.game,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          _buildBg(),
          Positioned(
            top: 110,
            child: Visibility(
              visible: game.state.value == GameState.success && !game.useAI.value,
              child: Image.asset(
                "lib/assets/png/1.0.7/game_success_star_bg.png",
                width: Get.width - 64,
              ),
            ),
          ),
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            insetPadding: const EdgeInsets.all(32),
            contentPadding: const EdgeInsets.all(0.0),
            content: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: SizedBox(
                      child: Image.asset(
                    "lib/assets/png/1.0.5/game_${imageName}_alert_bg.png",
                    width: Get.width - 64,
                  )),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: Get.width - 64,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 68),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          title ?? "",
                          style: const TextStyle(fontSize: 14, color: color_mid_text),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 21),
                      game.state.value == GameState.success && game.useAI.value
                          ? Text(
                              S.Congratulationsonsolvingthechessgame.tr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, color: color_mid_text),
                            )
                          : Column(children: [
                              _buildTimeOrStarOrTips(),
                              const SizedBox(height: 16),
                              if (!userCancel!) _buildGameInfo(),
                            ]),
                      SizedBox(height: !userCancel! ? 40 : 0),
                      _buildButtons(),
                    ],
                  ),
                ),
                _buildMainImage(),
                _buildBigTitle(),
                Positioned(top: -65, child: Image.asset("lib/assets/png/1.0.5/game_${imageName}_fg.png", width: 120)),
                Positioned(
                  right: 8,
                  top: 16,
                  child: SoundGestureDetector(
                    onTap: () {
                      Get.back();
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8, right: 16, bottom: 16),
                      child: Image.asset(
                          "lib/assets/png/close_${game.state.value == GameState.success && !game.useAI.value ? "orange" : "small"}.png",
                          width: 16,
                          height: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildShare(),
        ],
      ),
    );
  }

  Widget _buildBigTitle() {
    String title = "";
    Color titleColor = Colors.yellowAccent;
    if (game.state.value == GameState.success) {
      return Positioned(
        top: 54,
        child: Image.asset(
          "lib/assets/png/1.0.5/game_${newRecord != null && newRecord! ? "new_record" : "well_done"}.png",
          height: 23,
        ),
      );
    }

    if (game.state.value == GameState.fail) {
      if (game.failReason.value == GameFailReason.timeOut) title = S.Timehasrunout;
      if (game.failReason.value == GameFailReason.stepCountOut) title = S.Outofmoves;
      if (game.failReason.value == GameFailReason.userCancel) title = S.Challengefailed;
      titleColor = Colors.black;
    }

    return Positioned(
      top: 52,
      child: SizedBox(
        width: Get.width - 72,
        child: Text(
          title.tr,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26, color: titleColor),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTimeOrStarOrTips() {
    if (game.state.value == GameState.fail && game.failReason.value == GameFailReason.timeOut) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: color_main.withOpacity(0.15),
        ),
        child: Text(
          S.OnlyNstepsawayfromsolving.trArgs(["${lastStepCount ?? 0}"]),
          style: const TextStyle(fontSize: 14),
        ),
      );
    }

    if (game.state.value == GameState.success) {
      if (game.mode.value == GameMode.level) {
        return StarWidget(num: starNum);
      }

      return Text(
        TimeUtil.transformMilliSeconds(game.getTotalTime()),
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 40,
          fontFamily: "BebasNeue",
          shadows: [Shadow(color: Color(0xffE1F035), offset: Offset(2, 2), blurRadius: 0)],
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildMainImage() {
    return Positioned(
      top: 0,
      child: Visibility(
        visible: game.state.value == GameState.success && !game.useAI.value,
        child: Image.asset(
          "lib/assets/png/1.0.5/game_${imageName}_main.png",
          width: (Get.width - 64) / 6 * 7,
          height: 164,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildButtons() {
    if (game.state.value == GameState.success) {
      if (game.useAI.value) {
        return Row(
          children: [
            Expanded(
              child: CommonTextButton(
                title: S.restart,
                isBorder: false,
                onTap: () {
                  game.playAgain();
                  Get.back();
                },
              ),
            ),
          ],
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: CommonTextButton(
              title: S.restart,
              isBorder: true,
              onTap: () {
                game.playAgain();
                Get.back();
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CommonTextButton(
              title: game.mode.value == GameMode.freedom ? S.Random : S.next,
              isBorder: false,
              onTap: () {
                Get.back();
                if (game.mode.value == GameMode.freedom) {
                  game.randomAction != null ? game.randomAction!() : () {};
                } else {
                  game.nextAction != null ? game.nextAction!() : () {};
                }
              },
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: CommonTextButton(
            title: S.LookTeach.tr,
            isBorder: true,
            onTap: () {
              game.lookTeach();
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CommonTextButton(
            title: S.restart,
            isBorder: false,
            onTap: () {
              Get.back();
              game.playAgain();
            },
          ),
        ),
      ],
    );

    // return SizedBox();
  }

  Widget _buildGameInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              "${game.history.totalCount}",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              S.moves.tr,
              style: const TextStyle(fontSize: 14, color: color_mid_text),
            ),
          ],
        ),
        const SizedBox(width: 30),
        Container(width: 1, height: 30, color: color_line),
        Row(
          children: [
            const SizedBox(width: 20),
            Column(
              children: [
                Text(
                  game.timerWatch.timerString.value,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Text(
                  S.Time.tr,
                  style: const TextStyle(fontSize: 14, color: color_mid_text),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Container(width: 1, height: 30, color: color_line),
          ],
        ),
        const SizedBox(width: 30),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                Text(
                  game.tps.toStringAsFixed(2),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const Text("TPS", style: TextStyle(fontSize: 14, color: color_mid_text)),
              ],
            ),
            if (tps != null && tps! > 0)
              Positioned(
                right: -54,
                child: Row(
                  children: [
                    Image.asset("lib/assets/png/1.0.5/game_tps_up.png", width: 16, height: 16),
                    Text(tps!.toStringAsFixed(2), style: const TextStyle(color: Colors.green)),
                  ],
                ),
              )
          ],
        ),
      ],
    );
  }

  Widget _buildBg() {
    return Positioned(
      top: game.state.value == GameState.fail || (game.state.value == GameState.success && game.useAI.value) ? 100 : 20,
      child: Stack(
        children: [
          Image.asset(
            "lib/assets/png/1.0.5/game_${imageName}_bg.png",
            width: Get.width,
          ),
        ],
      ),
    );
  }

  Widget _buildShare() {
    return Visibility(
      visible: game.state.value == GameState.success && !game.useAI.value,
      child: Positioned(
        top: 0,
        right: 0,
        child: SoundGestureDetector(
          onTap: () async {
            try {
              final data = await GameShare.getShareData(game);
              NativeFlutterPlugin.instance.openSharePage(data);
            } catch (e) {}
            // onCloseTap();
          },
          child: Container(
            decoration: const BoxDecoration(
              color: color_main,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 26),
              child: Image.asset("lib/assets/png/icon_share.png", width: 16, height: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class StarWidget extends StatelessWidget {
  final int num;

  const StarWidget({Key? key, required this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "lib/assets/png/star_big_${num >= 1 ? "s" : "n"}.png",
          width: 48,
        ),
        const SizedBox(width: 10),
        Image.asset(
          "lib/assets/png/star_big_${num >= 2 ? "s" : "n"}.png",
          width: 48,
        ),
        const SizedBox(width: 10),
        Image.asset(
          "lib/assets/png/star_big_${num >= 3 ? "s" : "n"}.png",
          width: 48,
        ),
      ],
    );
  }
}
