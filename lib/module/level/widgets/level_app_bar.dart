import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/image_text_button_vertical.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/level/level_hard_handler.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/styles/styles.dart';

class LevelAppBar extends StatelessWidget {
  final GameType gameType;
  final String title;

  final int? hardIndex;
  final String? hard;
  final void Function(BottomSheetModel model)? onSelect;

  LevelAppBar({
    Key? key,
    required this.gameType,
    required this.title,
    this.hardIndex,
    this.hard,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SoundGestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(top: 8, right: 10, bottom: 8),
                        child: Image.asset("lib/assets/png/back.png", width: 24, height: 24),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      title.tr,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 10),
                    Visibility(
                      visible: gameType == GameType.hrd,
                      child: SoundGestureDetector(
                        onTap: () => LevelHardHandler().show(
                          type: gameType,
                          page: SheetPage.level,
                          onSelect: (i) => onSelect!(i),
                          current: hardIndex!,
                        ),
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(ui_button_radius)),
                              border: Border.all(color: color_mid_text, width: 1),
                              color: color_F7FFA1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (hard ?? "").tr,
                                style: const TextStyle(
                                  color: color_mid_text,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Image.asset(
                                "lib/assets/png/triangle_grey.png",
                                width: 10,
                                height: 6,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                ImageTextButtonVertical(
                  onTap: () => Get.toNamed(Routes.record_page, arguments: {"type": gameType, "mode": GameMode.level}),
                  imagePath: "lib/assets/png/icon_record_black.png",
                  imageSize: 24,
                  text: S.Records,
                )
              ],
            ),
          ),
          // Stack(
          //   alignment: Alignment.center,
          //   clipBehavior: Clip.none,
          //   children: [
          //     Image.asset("lib/assets/png/level/level_title_bottom_bg.png"),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 9),
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           const Text("获得",
          //               style: TextStyle(color: color_mid_text, fontSize: 11)),
          //           Image.asset("lib/assets/png/level/star_small_s.png",
          //               width: 17),
          //           Obx(
          //             () => Text(
          //               "${LevelHardHandler().totalStarNum}个",
          //               style: const TextStyle(
          //                   color: color_mid_text, fontSize: 11),
          //             ),
          //           ),
          //           const SizedBox(width: 13),
          //           Container(height: 24, width: 1, color: color_line),
          //           const SizedBox(width: 13),
          //           Obx(
          //             () => Text(
          //               "完成到${LevelHardHandler().lastLevel.value}关",
          //               style: const TextStyle(
          //                   color: color_mid_text, fontSize: 11),
          //             ),
          //           ),
          //         ],
          //       ),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
