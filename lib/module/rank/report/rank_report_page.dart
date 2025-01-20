import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/rank/match/rank_match_controller.dart';
import 'package:huaroad/module/rank/report/rank_report_controller.dart';
import 'package:huaroad/protos/battle.pb.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/time_util.dart';

class RankReportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RankReportController>(() => RankReportController());
  }
}

class RankReportPage extends GetView<RankReportController> {
  const RankReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/png/rank/rank_bg.png'), fit: BoxFit.fill)),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: Text(S.ChallengeSettlement.tr, style: const TextStyle(color: Colors.white)),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leadingWidth: 40,
                leading: SoundGestureDetector(
                  onTap: () => Get.back(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Image.asset(
                      "lib/assets/png/rank/rank_icon_back.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 150,
                height: 31,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(255, 255, 255, 0.5)),
                child: Text(
                  TimeUtil.formatDateTime(controller.reportModel.finishTime!),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(height: 64),
              Stack(
                alignment: AlignmentDirectional.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    child: Image.asset(
                      'lib/assets/png/rank/rank_result_bg.png',
                      width: Get.width,
                    ),
                  ),
                  Positioned(
                    top: -20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _reportCard(true, controller.reportModel.blueResult!),
                        Container(
                          margin: const EdgeInsets.only(top: 22),
                          child: Image.asset(
                            'lib/assets/png/rank/rank_vs.png',
                            height: 27,
                            width: 35,
                          ),
                        ),
                        _reportCard(false, controller.reportModel.redResult!),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              if (controller.reportModel.owner!) _oneMoreRound(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reportCard(bool left, msg_player_battle_result result) {
    return Container(
      width: Get.width / 2,
      padding: left ? const EdgeInsets.only(left: 20) : const EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: left ? const EdgeInsets.only(right: 10) : const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              textDirection: left ? TextDirection.ltr : TextDirection.rtl,
              children: [
                Column(
                  crossAxisAlignment: left ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    result.result.result == 1
                        ? Image.asset(
                            'lib/assets/png/rank/rank_win.png',
                            height: 44.h,
                            width: 60.w,
                          )
                        : Image.asset(
                            'lib/assets/png/rank/rank_lose.png',
                            height: 44.h,
                            width: 80.w,
                          ),
                    SizedBox(height: 2.h),
                    Text(result.player.nickName),
                  ],
                ),
                SizedBox(width: 10.w),
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    SoundGestureDetector(
                      onTap: () => left ? null : Get.find<RankMatchController>().onTapRivalAvatar(),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: color_main,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(width: 2.w)),
                        child: result.player.avatar.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  result.player.avatar,
                                  errorBuilder: (context, error, stackTrace) => Image.asset(
                                    'lib/assets/png/rank/rank_avatar.png',
                                  ),
                                ))
                            : Image.asset(
                                'lib/assets/png/rank/rank_avatar.png',
                              ),
                      ),
                    ),
                    Visibility(
                      visible: result.result.result == 1,
                      child: Positioned(
                          top: -40.w,
                          child: Image.asset('lib/assets/png/level/animation/crown_1.png',
                              width: 60.w, height: 60.w)),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 42.h),
          Padding(
              padding: left ? const EdgeInsets.only(left: 10) : const EdgeInsets.only(right: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.time.tr,
                          style: const TextStyle(
                            fontSize: 13,
                            color: color_minor_text,
                          )),
                      result.result.time == 0
                          ? Text(
                              S.Donotfinished.tr,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: color_main_text,
                                  fontWeight: FontWeight.w600),
                            )
                          : Text(
                              TimeUtil.transformMilliSeconds(result.result.time),
                              style: const TextStyle(
                                fontSize: 24,
                                color: color_main_text,
                                fontFamily: "BebasNeue",
                              ),
                            ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.solvemoves.tr,
                          style: const TextStyle(
                            fontSize: 13,
                            color: color_minor_text,
                          )),
                      Text(
                        result.result.step.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          color: color_main_text,
                          fontFamily: "BebasNeue",
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          customButton: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('TPS',
                                  style: TextStyle(fontSize: 13, color: color_minor_text)),
                              const SizedBox(width: 3),
                              Image.asset("lib/assets/png/icon_?.png", width: 12),
                            ],
                          ),
                          items: ['TPS:', S.Thenumberofslidespersecond]
                              .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  enabled: false,
                                  child: Text(
                                    item.tr,
                                    style: const TextStyle(fontSize: 16, color: color_main_text),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  )))
                              .toList(),
                          onChanged: (value) {},
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 124,
                            width: 300,
                            elevation: 24,
                            offset: const Offset(-7, -10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 4),
                                      blurRadius: 20,
                                      color: Color.fromRGBO(155, 167, 21, 0.3))
                                ]),
                          ),
                        ),
                      ),
                      Text(
                        (result.result.step / result.result.time * 1000).toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 24,
                          color: color_main_text,
                          fontFamily: "BebasNeue",
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          SizedBox(height: 30.h),
          Offstage(
            offstage: result.result.reviewId == 0,
            child: SoundGestureDetector(
              onTap: () => controller.toReplayPage(result),
              child: Image.asset(
                'lib/assets/png/rank/rank_icon_video.png',
                width: 60.w,
                height: 46.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _oneMoreRound() {
    return SoundGestureDetector(
      onTap: controller.onMoreRound,
      child: Container(
        alignment: Alignment.center,
        width: Get.width * 0.8,
        height: 48,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/png/rank/rank_button_yellow_big.png'),
                fit: BoxFit.fill)),
        child: Text(
          S.Playagain.tr,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 16, color: color_main_text, height: 1.0),
        ),
      ),
    );
  }
}
