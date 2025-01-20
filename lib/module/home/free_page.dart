import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/ai_solution_button.dart';
import 'package:huaroad/common/image_text_button_vertical.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/home/free_controller.dart';
import 'package:huaroad/module/home/free_widgets.dart';
import 'package:huaroad/module/hrd/hrd.dart';
import 'package:huaroad/module/level/level_hard_handler.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/styles/styles.dart';

class FreePage extends StatelessWidget {
  FreePage({Key? key}) : super(key: key);
  final FreeController c = Get.put(FreeController());

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
        body: Obx(
          () => Stack(
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
                    Expanded(
                      child: SingleChildScrollView(
                        physics:
                            c.allowScroll.value ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topRight,
                              children: [
                                Positioned(
                                  top: -44,
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
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(width: 12),
                                  c.game.value.state.value == GameState.onGoing
                                      ? AISolutionButton(
                                          onTap: c.onAITap,
                                          isInTeaching: c.game.value.isInAI.value,
                                          type: c.game.value.type.value,
                                        )
                                      : const SizedBox(height: 30)
                                ],
                              ),
                            ),
                            Container(height: 32),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => SoundGestureDetector(
                                      onTap: () => LevelHardHandler().show(
                                        type: c.gameType,
                                        page: SheetPage.home,
                                        onSelect: (i) => c.changeLevel(i),
                                        current: c.currentHardIndex.value,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 6,
                                        ),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(ui_button_radius)),
                                          border: Border.all(color: color_line, width: 1),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              c.currentHard.value,
                                              style: const TextStyle(
                                                color: color_minor_text,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Image.asset(
                                              "lib/assets/png/triangle_grey.png",
                                              width: 10,
                                              height: 6,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  CreateGameButton(title: S.Random.tr, onTap: () => c.onTapCreateGame()),
                                ],
                              ),
                            ),
                            const SizedBox(height: 44),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            S.Practice.tr,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SoundGestureDetector(
                onTap: () => c.onTapBack(),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(top: 8, right: 16, bottom: 8),
                  child: Image.asset("lib/assets/png/back.png", width: 24, height: 24),
                ),
              ),
              ImageTextButtonVertical(
                onTap: () => Get.toNamed(Routes.record_page, arguments: {"type": c.gameType, "mode": GameMode.freedom}),
                imagePath: "lib/assets/png/icon_record.png",
                imageSize: 24,
                text: S.Records,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
