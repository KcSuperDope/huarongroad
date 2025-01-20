import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/hrd/hrd.dart';
import 'package:huaroad/module/rank/battle/rank_vs_controller.dart';
import 'package:huaroad/module/rank/match/rank_match_controller.dart';
import 'package:huaroad/styles/styles.dart';

class RankVsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RankVsController>(() => RankVsController());
  }
}

class RankVsPage extends GetView<RankVsController> {
  const RankVsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.onTapBack();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              "lib/assets/png/rank/rank_vs_bg.png",
              fit: BoxFit.fill,
            ),
            SafeArea(
              child: Obx(() => SingleChildScrollView(
                    physics: controller.allowScroll.value
                        ? const ClampingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAppBar(),
                        const SizedBox(height: 50),
                        _vsPlayerView(),
                        const SizedBox(height: 46),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Hrd(
                              game: controller.game,
                              onAllowScroll: (allowScroll) =>
                                  controller.allowScroll.value = allowScroll,
                            ),
                            Positioned(
                              top: -43,
                              right: 0,
                              child: Image.asset(
                                "lib/assets/png/icon_angle.png",
                                width: 44,
                                height: 44,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 40,
      leading: SoundGestureDetector(
        onTap: controller.onTapBack,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset(
            "lib/assets/png/rank/rank_icon_back.png",
            width: 24,
            height: 24,
          ),
        ),
      ),
      title: Text(S.VS.tr, style: TextStyle(color: Colors.white)),
      centerTitle: true,
    );
  }

  Widget _vsPlayerView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Obx(() =>
            _avatarView(controller.vsStartModel.myInfo?.avatar ?? '', controller.myState.value)),
        Column(
          children: [
            Obx(() => Text(
                  controller.timerString.value,
                  style: const TextStyle(
                    color: color_main_text,
                    fontSize: 40,
                    fontWeight: FontWeight.normal,
                    fontFamily: "BebasNeue",
                    fontFeatures: [FontFeature.tabularFigures()],
                    shadows: [
                      Shadow(color: color_main, offset: Offset(2, 2), blurRadius: 0),
                    ],
                  ),
                )),
            Obx(() => Text(
                  controller.myState.value == S.solving && !controller.startCountDown
                      ? "${controller.game.history.totalCount.value}${S.Move.tr}"
                      : controller.stateString.value.tr,
                  style: const TextStyle(
                    color: color_main_text,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(color: color_main, offset: Offset(1, 1), blurRadius: 0),
                    ],
                  ),
                )),
          ],
        ),
        SoundGestureDetector(
            onTap: Get.find<RankMatchController>().onTapRivalAvatar,
            child: Obx(() => _avatarView(
                controller.vsStartModel.rivalInfo?.avatar ?? '', controller.rivalState.value))),
      ],
    );
  }

  Widget _avatarView(String avatar, String state) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: color_main,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                      width: 2,
                      color: state == S.Completed
                          ? color_27F22F
                          : state == S.Challengefailed
                              ? color_F13C3C
                              : Colors.black)),
              child: avatar.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(avatar,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                              'lib/assets/png/rank/rank_avatar.png',
                              width: 50,
                              height: 50)))
                  : Image.asset(
                      'lib/assets/png/rank/rank_avatar.png',
                      width: 50,
                      height: 50,
                    ),
            ),
            Visibility(
                visible: state == S.Challengefailed,
                child: Positioned(
                  bottom: -5,
                  right: -5,
                  child: Image.asset(
                    'lib/assets/png/rank/rank_icon_fail.png',
                    width: 26,
                    height: 26,
                  ),
                )),
            Visibility(
              visible: state == S.Completed,
              child: Positioned(
                bottom: -5,
                right: -5,
                child: Image.asset(
                  'lib/assets/png/rank/rank_icon_finish.png',
                  width: 26,
                  height: 26,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 9),
        Text(
          state.tr,
          style: const TextStyle(
            color: color_main_text,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
        )
      ],
    );
  }
}
