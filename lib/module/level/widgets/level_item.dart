import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/level/level_hard_handler.dart';
import 'package:huaroad/module/level/model/level_model.dart';
import 'package:huaroad/module/level/widgets/level_item_star.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/images_animation_util.dart';

class LevelItem extends StatelessWidget {
  final LevelItemModel item;
  final void Function(LevelItemModel item) onTap;

  LevelItem({Key? key, required this.item, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SoundGestureDetector(
      onTap: () => onTap(item),
      child: item.empty
          ? Container(width: item.isBoss ? 0 : item.width)
          : Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                item.isBoss ? LevelBigItem(item: item) : LevelSmallItem(item: item),
                Obx(
                  () => Visibility(
                    visible: item.index == LevelHardHandler().lastLevel.value,
                    child: Positioned(
                      top: -50,
                      child: ImagesAnimation(
                        w: 80,
                        h: 80,
                        durationMilliseconds: 1500,
                        entry: ImagesAnimationEntry(lowIndex: 1, highIndex: 15),
                        animationPngName:
                            "lib/assets/png/level/animation/${item.type == GameType.hrd ? "crown" : "swim"}",
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}

class LevelSmallItem extends StatelessWidget {
  const LevelSmallItem({Key? key, required this.item}) : super(key: key);
  final LevelItemModel item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: item.width,
      height: item.isLevelLast ? 100 : item.height,
      child: Obx(() => Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Image.asset(item.pngName, width: 80),
              Positioned(
                top: 14,
                child: item.index <= LevelHardHandler().lastLevel.value
                    ? LevelItemStarWidget(num: item.starNum.value)
                    : Image.asset("lib/assets/png/level/level_lock.png", width: 28),
              ),
              Positioned(
                bottom: -8,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("lib/assets/png/level/level_item_title_bg.png", width: 52),
                    Text(
                      '${item.index}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: item.index <= LevelHardHandler().lastLevel.value ? color_main : color_gray_1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class LevelBigItem extends StatelessWidget {
  const LevelBigItem({Key? key, required this.item}) : super(key: key);
  final LevelItemModel item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 162,
      height: 162,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(item.pngName, width: 162),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: item.index != LevelHardHandler().lastLevel.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "lib/assets/png/level/level_big_town_rainbow.png",
                        width: 121,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                item.index <= LevelHardHandler().lastLevel.value
                    ? Padding(
                        padding: const EdgeInsets.only(left: 42),
                        child: LevelItemStarWidget(num: item.starNum.value),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 63),
                        child: Image.asset("lib/assets/png/level/level_lock.png", width: 28),
                      ),
                const Spacer(),
              ],
            ),
          ),
          Positioned(
            left: 50,
            bottom: -8,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "lib/assets/png/level/level_item_title_bg.png",
                  width: 52,
                ),
                Text(
                  '${item.index}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: item.index <= LevelHardHandler().lastLevel.value ? color_main : color_gray_1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
