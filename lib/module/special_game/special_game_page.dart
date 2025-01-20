import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/ai_solution_button.dart';
import 'package:huaroad/common/image_text_button_vertical.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/hrd/hrd.dart';
import 'package:huaroad/module/special_game/special_game_controller.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/route/routes.dart';
import 'package:marquee/marquee.dart';

class SpecialGamePage extends StatelessWidget {
  SpecialGamePage({Key? key}) : super(key: key);
  final c = Get.put(SpecialGameController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (c.game.value.state.value == GameState.onGoing) {
          c.onTapBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              "lib/assets/png/application_title_bg.png",
              repeat: ImageRepeat.repeat,
              fit: BoxFit.contain,
              height: Get.height / 2,
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildAppBar(),
                  Obx(
                    () => Expanded(
                      child: SingleChildScrollView(
                        physics:
                            c.allowScroll.value ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 34),
                            Row(
                              children: [
                                Image.asset(
                                  "lib/assets/png/special_title_bg_left.png",
                                  fit: BoxFit.fill,
                                  width: (MediaQuery.of(context).size.width - 212) / 2,
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  height: 40,
                                  width: 200,
                                  alignment: Alignment.center,
                                  child: c.boundingTextWidth((c.gameItem.value.title ?? "").tr) > 200
                                      ? Marquee(
                                          key: const Key("Mar"),
                                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                                          text: (c.gameItem.value.title ?? "").tr,
                                          pauseAfterRound: const Duration(seconds: 1),
                                          velocity: 50,
                                          blankSpace: 20,
                                        )
                                      : Text(
                                          (c.gameItem.value.title ?? "").tr,
                                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                ),
                                const SizedBox(width: 6),
                                Image.asset(
                                  "lib/assets/png/special_title_bg_right.png",
                                  fit: BoxFit.fill,
                                  width: (MediaQuery.of(context).size.width - 212) / 2,
                                ),
                              ],
                            ),
                            const SizedBox(height: 42),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: -44,
                                  right: 0,
                                  child: Image.asset(
                                    "lib/assets/png/icon_angle.png",
                                    width: 44,
                                    height: 44,
                                  ),
                                ),
                                Hrd(
                                  game: c.game.value,
                                  onAllowScroll: (allowScroll) => c.allowScroll.value = allowScroll,
                                ),
                              ],
                            ),
                            const SizedBox(height: 9),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  c.game.value.state.value == GameState.onGoing
                                      ? AISolutionButton(
                                          onTap: c.onAITap,
                                          isInTeaching: c.game.value.isInAI.value,
                                          type: c.game.value.type.value)
                                      : const SizedBox(height: 30)
                                ],
                              ),
                            ),
                            const SizedBox(height: 44),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            SoundGestureDetector(
              onTap: () => c.onTapBack(),
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(top: 8, right: 16, bottom: 8),
                child: Image.asset("lib/assets/png/back.png", width: 24, height: 24),
              ),
            ),
            Row(
              children: [
                ImageTextButtonVertical(
                  onTap: () => NativeFlutterPlugin.instance.openOfficialTopic(),
                  imagePath: "lib/assets/png/icon_social_comment.png",
                  imageSize: 24,
                  text: S.Joindiscussion,
                ),
                const SizedBox(width: 12),
                ImageTextButtonVertical(
                  onTap: () => Get.toNamed(
                    Routes.top_list_page,
                    arguments: {
                      "mode": GameMode.famous,
                      "type": GameType.hrd,
                      "id": c.game.value.id,
                      "name": (c.gameItem.value.title ?? "").tr,
                    },
                  ),
                  imagePath: "lib/assets/png/icon_top_list.png",
                  imageSize: 24,
                  text: S.rankinglist,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
