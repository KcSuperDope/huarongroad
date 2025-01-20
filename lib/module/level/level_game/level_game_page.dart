import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/ai_solution_button.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/hrd/hrd.dart';
import 'package:huaroad/module/level/level_game/level_game_controller.dart';
import 'package:huaroad/styles/styles.dart';

class LevelGamePage extends StatelessWidget {
  LevelGamePage({Key? key}) : super(key: key);
  final LevelGameController c = Get.put(
    LevelGameController(),
    tag: "_level_${Get.arguments.type == GameType.hrd ? "hrd" : "num"}_${Get.arguments.index}",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "lib/assets/png/application_title_bg.png",
            repeat: ImageRepeat.repeat,
            fit: BoxFit.contain,
            height: Get.height / 2,
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: Obx(
                    () => SingleChildScrollView(
                      physics:
                          c.allowScroll.value ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildStars(),
                          const SizedBox(height: 27),
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
                                game: c.game,
                                onAllowScroll: (allowScroll) => c.allowScroll.value = allowScroll,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                c.game.state.value == GameState.onGoing
                                    ? AISolutionButton(
                                        onTap: c.onAITap, isInTeaching: c.game.isInAI.value, type: c.game.type.value)
                                    : const SizedBox(height: 30)
                              ],
                            ),
                          ),
                          Container(height: 16),
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
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(S.Lv.trArgs([c.index.toString()]), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
            Row(
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStars() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Image.asset(
                "lib/assets/png/star_big_${c.starNum.value >= 1 ? "s" : "n"}.png",
                width: 48,
              ),
              const SizedBox(height: 2),
              Text(S.Win.tr, style: const TextStyle(fontSize: 13, color: color_main_text)),
            ],
          ),
          const SizedBox(width: 44),
          Column(
            children: [
              Image.asset("lib/assets/png/star_big_${c.starNum.value >= 2 ? "s" : "n"}.png", width: 48),
              const SizedBox(height: 2),
              const Text("120s", style: TextStyle(fontSize: 13, color: color_main_text)),
            ],
          ),
          const SizedBox(width: 44),
          Column(
            children: [
              Image.asset("lib/assets/png/star_big_${c.starNum.value >= 3 ? "s" : "n"}.png", width: 48),
              const SizedBox(height: 2),
              const Text("60s", style: TextStyle(fontSize: 13, color: color_main_text)),
            ],
          ),
        ],
      ),
    );
  }
}
