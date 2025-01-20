import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_share.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/dialog_util.dart';
import 'package:huaroad/util/images_animation_util.dart';
import 'package:huaroad/util/time_util.dart';

class HrdCover extends StatelessWidget {
  const HrdCover({
    Key? key,
    required this.game,
  }) : super(key: key);
  final Game game;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - ui_page_padding * 2;
    return Obx(
      () => Visibility(
        visible: game.state.value == GameState.fail || game.state.value == GameState.success,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              height: (width - ui_board_padding * 2) / 4 * 5 + 48,
              width: width - ui_board_padding * 2,
              alignment: Alignment.center,
              color: Colors.white.withOpacity(0.8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 100,
                        color: game.state.value == GameState.fail
                            ? Colors.white.withOpacity(0.6)
                            : const Color(0xffFF9126).withOpacity(0.2),
                      ),
                      Positioned(
                        top: -80,
                        child: Column(
                          children: [
                            ImagesAnimation(
                              w: 120,
                              h: 120,
                              durationMilliseconds: 1500,
                              entry: ImagesAnimationEntry(lowIndex: 1, highIndex: 20),
                              animationPngName:
                                  "lib/assets/png/state_animation/${game.state.value == GameState.fail ? "fail" : "well_done"}",
                            ),
                            Image.asset(
                              "lib/assets/png/icon_cover_${game.state.value == GameState.fail ? "you_fail" : "well_done"}.png",
                              height: 23,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: game.state.value == GameState.success && game.mode.value != GameMode.rank,
                    child: Column(
                      children: [
                        const SizedBox(height: 37),
                        Text(
                          TimeUtil.transformMilliSeconds(game.getTotalTime()),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 40,
                            fontFamily: "BebasNeue",
                            shadows: [Shadow(color: Color(0xffE1F035), offset: Offset(2, 2), blurRadius: 0)],
                          ),
                        ),
                        Text(
                          game.history.totalCount.toString() + S.Move.tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 60),
                        CommonTextButton(
                          title: S.ShareScore,
                          onTap: () async {
                            try {
                              final data = await GameShare.getShareData(game);
                              NativeFlutterPlugin.instance.openSharePage(data);
                            } catch (e) {}
                          },
                          isBorder: false,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: game.state.value == GameState.success && game.mode.value == GameMode.rank,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        S.waitfortocompletethegame.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
