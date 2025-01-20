import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/app_bar.dart';
import 'package:huaroad/common/select_option.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/module/hrd/hrd.dart';
import 'package:huaroad/module/record/record_replay_controller.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/time_util.dart';

class RecordReplayPage extends StatelessWidget {
  RecordReplayPage({super.key});

  final c = Get.put(RecordReplayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: S.replayplayback),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                const SizedBox(height: 15),
                Hrd(
                  game: c.game!,
                  titleWidget: _buildBoardTop(),
                  bottomWidget: _buildBoardBottom(),
                  showTitleTop: false,
                  isShowRecordPlay: true,
                  boardRadius: 28,
                  boardBackgroundColor: color_bg,
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      c.timerString.value,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        fontFamily: "BebasNeue",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          Obx(() => SelectOption(
                                values: c.videoSpeedList,
                                currentValue: c.videoSpeed.value,
                                onSelect: (str, index) {
                                  c.videoSpeed.value = str;
                                },
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Obx(
                  () => SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 10,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                    ),
                    child: Slider(
                      inactiveColor: color_bg,
                      activeColor: color_piece_green,
                      value: c.sliderValue.value,
                      onChanged: (v) => c.sliderValue.value = v,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SoundGestureDetector(
                      onTap: () => c.decreaseVideoSpeed(),
                      child: Image.asset(
                        "lib/assets/png/icon_video_play_left.png",
                        width: 22,
                        height: 20,
                      ),
                    ),
                    const SizedBox(width: 30),
                    SoundGestureDetector(
                      onTap: () => c.play(),
                      child: Image.asset(
                        "lib/assets/png/icon_video_${c.isPlaying.value ? "play" : "pause"}.png",
                        width: 60,
                        height: 46,
                      ),
                    ),
                    const SizedBox(width: 30),
                    SoundGestureDetector(
                      onTap: () => c.addVideoSpeed(),
                      child: Image.asset(
                        "lib/assets/png/icon_video_play_right.png",
                        width: 22,
                        height: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBoardTop() {
    return Container(
      height: 48,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(image: boardTitleImageDecoration),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => NativeFlutterPlugin.instance.openUserHomePage(
                    c.recordModel!.userId != null ? c.recordModel!.userId! : Global.userId),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: c.recordModel!.avatar != null
                        ? c.recordModel!.avatar!.isNotEmpty
                            ? Image.network(c.recordModel!.avatar!,
                                width: 30,
                                height: 30,
                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                    'lib/assets/png/rank/rank_avatar.png',
                                    width: 30,
                                    height: 30))
                            : Image.asset('lib/assets/png/rank/rank_avatar.png',
                                width: 30, height: 30)
                        : Global.userAvatar.isNotEmpty
                            ? Image.network(Global.userAvatar,
                                width: 30,
                                height: 30,
                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                    'lib/assets/png/rank/rank_avatar.png',
                                    width: 30,
                                    height: 30))
                            : Image.asset('lib/assets/png/rank/rank_avatar.png',
                                width: 30, height: 30)),
              ),
              const SizedBox(width: 6),
              Text(
                c.recordModel?.name ?? Global.userNickName,
                style: const TextStyle(
                    fontSize: 16, color: color_main_text, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            TimeUtil.formatTimeMillisV2(c.game!.startTime, doubleLine: false).tr,
            style: const TextStyle(
              fontSize: 13,
              color: color_main_text,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBoardBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => c.preStep(),
            child: Row(
              children: [
                Image.asset(
                  "lib/assets/png/icon_pre.png",
                  width: 6,
                  height: 10,
                  color: color_minor_text,
                ),
                const SizedBox(width: 4),
                Text(
                  S.PreviousStep.tr,
                  style: const TextStyle(
                    fontSize: 13,
                    color: color_main_text,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                "${c.currentPieceMove.value}",
                style: const TextStyle(
                  fontSize: 16,
                  color: color_main_text,
                ),
              ),
              Text(
                "/${c.game!.history.totalCount.value}",
                style: const TextStyle(
                  fontSize: 16,
                  color: color_minor_text,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => c.nextStep(),
            child: Row(
              children: [
                Text(
                  S.Next.tr,
                  style: const TextStyle(
                    fontSize: 13,
                    color: color_main_text,
                  ),
                ),
                const SizedBox(width: 4),
                Image.asset(
                  "lib/assets/png/icon_next.png",
                  width: 6,
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
