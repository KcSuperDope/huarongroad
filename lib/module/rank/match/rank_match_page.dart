import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/image_text_button_vertical.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/module/rank/match/rank_match_controller.dart';
import 'package:huaroad/net/env/env_config.dart';
import 'package:huaroad/styles/styles.dart';

class RankMatchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RankMatchController>(() => RankMatchController());
  }
}

class RankMatchPage extends GetView<RankMatchController> {
  const RankMatchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (controller.matching.value) {
            controller.onTapBack();
            return false;
          }
          return true;
        },
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/assets/png/rank/rank_bg.png'), fit: BoxFit.fill)),
            child: SafeArea(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leadingWidth: 40,
                    leading: SoundGestureDetector(
                      onTap: () {
                        if (controller.matching.value) {
                          controller.onTapBack();
                        } else {
                          Get.back();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Image.asset(
                          "lib/assets/png/rank/rank_icon_back.png",
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                    actions: [
                      ImageTextButtonVertical(
                        text: S.Records.tr,
                        imagePath: 'lib/assets/png/rank/rank_icon_record.png',
                        imageSize: 24,
                        onTap: controller.toRecord,
                        textColor: color_FFFFFF,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 8.0),
                      //   child: ImageTextButtonVertical(
                      //     text: S.Settings.tr,
                      //     imagePath: 'lib/assets/png/rank/rank_icon_set.png',
                      //     imageSize: 24,
                      //     onTap: () => Get.bottomSheet(_vsSettingBottomSheet()),
                      //     textColor: color_FFFFFF,
                      //   ),
                      // ),
                      _deviceConnectButton()
                    ],
                  ),
                  _titleView(),
                  SizedBox(height: 80.h),
                  _vsPlayerView(),
                  SizedBox(height: 80.h),
                  Obx(() => Offstage(
                      offstage: controller.matching.value || controller.inviteSuccess.value,
                      child: _matchButton())),
                  SizedBox(height: 20.h),
                  Obx(() => Offstage(
                      offstage: controller.matching.value || controller.inviteSuccess.value,
                      child: _inviteButton())),
                  Obx(() => Visibility(
                      visible: controller.inviteSuccess.value && controller.owner.value,
                      child: _battleButton())),
                  Obx(() => Visibility(
                      visible: controller.inviteSuccess.value && !controller.owner.value,
                      child: _waitingView())),
                  Obx(() => Visibility(visible: controller.matching.value, child: _matchingView())),
                  const Spacer(),
                  if (EnvConfig.env == Env.dev || EnvConfig.env == Env.test) testView()
                ],
              ),
            ),
          ),
        ));
  }

  Widget _titleView() {
    return Container(
        height: Get.height * 0.28.h,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/png/rank/rank_title.png'), fit: BoxFit.fitWidth)),
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.07.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/png/rank/rank_union_right.png',
                  width: 12.w,
                  height: 12.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  S.VS.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    shadows: [
                      Shadow(
                          color: Color.fromRGBO(132, 169, 25, 0.5),
                          offset: Offset(2, 2),
                          blurRadius: 0),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Image.asset(
                  'lib/assets/png/rank/rank_union_left.png',
                  width: 12.w,
                  height: 12.w,
                )
              ],
            ),
            SizedBox(height: Get.height * 0.07.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SoundGestureDetector(
                    onTap: controller.selectHard,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      decoration:
                          BoxDecoration(color: color_main, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => Text(
                              controller.currentHard.value.tr,
                              style: const TextStyle(
                                color: color_main_text,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Image.asset("lib/assets/png/triangle.png", width: 10.w, height: 6.h),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: Get.width * 0.16,
                          child: Column(
                            children: [
                              Obx(() => Text(
                                    "${controller.winNumber.value}",
                                    style: const TextStyle(
                                      color: color_FFFFFF,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 24,
                                      fontFamily: "VonwaonBitmap",
                                    ),
                                  )),
                              Text(
                                S.Numberofvictories.tr,
                                style: const TextStyle(
                                  color: color_FFFFFF,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            ],
                          )),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        height: 18.5,
                        width: 1,
                        color: color_FFFFFF,
                      ),
                      SizedBox(
                        width: Get.width * 0.16,
                        child: Column(
                          children: [
                            Obx(() => Text(
                                  "${controller.winRate.value}%",
                                  style: const TextStyle(
                                    color: color_FFFFFF,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 24,
                                    fontFamily: "VonwaonBitmap",
                                  ),
                                )),
                            Text(
                              S.Winrate.tr,
                              style: const TextStyle(
                                color: color_FFFFFF,
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget _matchButton() {
    return SoundGestureDetector(
      onTap: controller.startMatch,
      child: Container(
        alignment: Alignment.center,
        width: Get.width * 0.45,
        height: 42,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/png/rank/rank_button_yellow_small.png'),
                fit: BoxFit.fill)),
        child: Text(
          S.automatching.tr,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 16, color: color_main_text, height: 1.0),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _inviteButton() {
    return SoundGestureDetector(
      onTap: controller.getFriends,
      child: Container(
        alignment: Alignment.center,
        width: Get.width * 0.45,
        height: 38,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/png/rank/rank_button_white.png'), fit: BoxFit.fill)),
        child: Text(
          S.Invitation.tr,
          style: const TextStyle(
              fontWeight: FontWeight.normal, fontSize: 16, color: color_main_text, height: 1.0),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _battleButton() {
    return Column(
      children: [
        Obx(() => Text(
              controller.ready.value ? '' : S.Waitingforfriendtoready.tr,
              style: const TextStyle(
                  color: color_main_text, fontSize: 11, fontWeight: FontWeight.normal),
            )),
        const SizedBox(height: 10),
        Obx(
          () => controller.ready.value
              ? SoundGestureDetector(
                  onTap: controller.startBattle,
                  child: Container(
                      alignment: Alignment.center,
                      width: Get.width * 0.8,
                      height: 48,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('lib/assets/png/rank/rank_button_yellow_big.png'),
                              fit: BoxFit.fill)),
                      child: Text(
                        S.Start.tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: color_main_text,
                            height: 1.0),
                      )))
              : Container(
                  alignment: Alignment.center,
                  width: Get.width * 0.8,
                  height: 48,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('lib/assets/png/rank/rank_button_grey_big.png'),
                          fit: BoxFit.fill)),
                  child: Text(
                    S.Start.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color(0xFFABABAB),
                        height: 1.0),
                  )),
        ),
      ],
    );
  }

  Widget _waitingView() {
    return Column(
      children: [
        Obx(() => Text(
              controller.ready.value ? S.Waitingforfriendtostart.tr : '',
              style: const TextStyle(
                  color: color_main_text, fontSize: 11, fontWeight: FontWeight.normal),
            )),
        const SizedBox(height: 10),
        SoundGestureDetector(
          onTap: controller.onTapReady,
          child: Obx(() => controller.ready.value
              ? Container(
                  alignment: Alignment.center,
                  width: Get.width * 0.8,
                  height: 48,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('lib/assets/png/rank/rank_button_grey_big.png'),
                          fit: BoxFit.fill)),
                  child: Text(
                    S.Ready.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color(0xFFABABAB),
                        height: 1.0),
                  ))
              : Container(
                  alignment: Alignment.center,
                  width: Get.width * 0.8,
                  height: 48,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('lib/assets/png/rank/rank_button_yellow_big.png'),
                          fit: BoxFit.fill)),
                  child: Text(
                    S.Prepare.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: color_main_text,
                        height: 1.0),
                  ))),
        ),
      ],
    );
  }

  Widget _matchingView() {
    return Container(
      height: 75,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(255, 255, 255, 0),
        Color.fromRGBO(255, 255, 255, 0.5),
        Color.fromRGBO(255, 255, 255, 0),
      ])),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text(
                    controller.matchTitle.value.tr,
                    style: const TextStyle(
                        color: color_main_text, fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(height: 7),
              Obx(() => Text(
                    controller.matchSubtitle.value.tr,
                    style: const TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.normal),
                  )),
            ],
          ),
          Positioned(
            right: 18,
            child: SoundGestureDetector(
              onTap: controller.quitMatch,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(ui_button_radius)),
                  border: Border.all(color: color_main_text, width: 1),
                ),
                child: Text(
                  S.Cancel.tr,
                  style: const TextStyle(
                    color: color_mid_text,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vsPlayerView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: color_main,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(width: 2)),
              child: Global.userAvatar.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        Global.userAvatar,
                        width: 60,
                        height: 60,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                            'lib/assets/png/rank/rank_avatar.png',
                            width: 60,
                            height: 60),
                      ))
                  : Image.asset('lib/assets/png/rank/rank_avatar.png', width: 60, height: 60),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 60,
              child: Text(
                Global.userNickName,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: color_main_text,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(
                height: 24,
                child: Offstage(
                    offstage: true,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: _devicePlayerLabel(),
                    )))
          ],
        ),
        Container(
            alignment: Alignment.center,
            width: Get.width * 0.24,
            margin: const EdgeInsets.only(bottom: 44),
            child: Obx(() => controller.matching.value
                ? Text(
                    controller.timerString.value,
                    style: const TextStyle(
                      color: color_main_text,
                      fontSize: 32,
                      fontWeight: FontWeight.normal,
                      fontFamily: "BebasNeue",
                      shadows: [
                        Shadow(color: color_main, offset: Offset(2, 2), blurRadius: 0),
                      ],
                    ),
                  )
                : Image.asset('lib/assets/png/rank/rank_icon_vs.png', height: 27, width: 63))),
        Column(
          children: [
            _rivalInfoView(),
            SizedBox(
              height: 24,
              child: Offstage(
                  offstage: true,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: _devicePlayerLabel(),
                  )),
            )
          ],
        )
      ],
    );
  }

  Widget _rivalInfoView() {
    return Obx(() {
      if (controller.matching.value && controller.matchTitle.value.contains(S.Matching)) {
        return Column(
          children: [
            Image.asset(
              'lib/assets/png/rank/rank_who.png',
              width: 60,
              height: 60,
            ),
            const SizedBox(height: 6),
            const Text(
              '',
              style: TextStyle(
                color: color_main_text,
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        );
      }

      if (controller.matching.value || controller.inviteSuccess.value) {
        return Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                SoundGestureDetector(
                  onTap: controller.onTapRivalAvatar,
                  child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: color_main,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(width: 2)),
                      child: controller.rivalInfo != null &&
                              controller.rivalInfo!.avatar != null &&
                              controller.rivalInfo!.avatar != ''
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(controller.rivalInfo!.avatar!,
                                  width: 60,
                                  height: 60,
                                  errorBuilder: (context, error, stackTrace) => Image.asset(
                                      'lib/assets/png/rank/rank_avatar.png',
                                      width: 60,
                                      height: 60)))
                          : Image.asset('lib/assets/png/rank/rank_avatar.png',
                              width: 60, height: 60)),
                ),
                Visibility(
                    visible: controller.inviteSuccess.value && controller.owner.value,
                    child: SoundGestureDetector(
                      onTap: controller.kickOut,
                      child: Image.asset(
                        'lib/assets/png/rank/rank_icon_close.png',
                        width: 26,
                        height: 26,
                      ),
                    ))
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 60,
              child: Text(
                controller.rivalInfo?.nickName ?? '对方的昵称',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: color_main_text,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      }

      return Column(
        children: [
          SoundGestureDetector(
            onTap: controller.getFriends,
            child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: color_main,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 2)),
                child: Center(
                  child:
                      Image.asset('lib/assets/png/rank/rank_icon_add.png', width: 20, height: 20),
                )),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 60,
            child: Text(
              S.Invitation.tr,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: color_main_text,
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        ],
      );
    });
  }

  Widget testView() {
    return Obx(() => Text('Grpc连接状态:${controller.grpcConnect.value ? '已连接' : '断开'}'));
  }

  Widget _devicePlayerLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 0.6), borderRadius: BorderRadius.circular(3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("lib/assets/png/icon_record_device.png", width: 14.w, height: 14.h),
          SizedBox(width: 1.w),
          Text(
            S.Smartdeviceplayer.tr,
            style: const TextStyle(
              color: color_mid_text,
              fontWeight: FontWeight.w400,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _deviceConnectButton() {
    return UnconstrainedBox(
        child: Container(
            margin: const EdgeInsets.only(left: 14),
            child: SoundGestureDetector(
              onTap: controller.connectDevice,
              child: Obx(
                () => FindDeviceHandler().deviceConnected.value
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                        decoration: const BoxDecoration(
                            border: Border(
                                left: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.5)),
                                top: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.5)),
                                bottom: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.5)),
                                right: BorderSide(
                                    color: Color.fromRGBO(255, 255, 255, 0.5), width: 0)),
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(10))),
                        child: Row(
                          children: [
                            Obx(
                              () => Image.asset(
                                "lib/assets/png/rank/rank_battery_${FindDeviceHandler().deviceInfoModel.power.value >= 66 ? 3 : FindDeviceHandler().deviceInfoModel.power.value < 33 ? 1 : 2}.png",
                                width: 24,
                                height: 24,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              S.DeviceConnected.tr,
                              style: const TextStyle(
                                color: color_FFFFFF,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ))
                    : Container(
                        padding: const EdgeInsets.fromLTRB(14, 6, 8, 6),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.2),
                            border: Border(
                                left: BorderSide(color: color_FFFFFF),
                                top: BorderSide(color: color_FFFFFF),
                                bottom: BorderSide(color: color_FFFFFF),
                                right: BorderSide(color: color_FFFFFF, width: 0)),
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(10))),
                        child: Text(
                          S.ConnectKlotski.tr,
                          style: const TextStyle(
                            color: color_FFFFFF,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        )),
              ),
            )));
  }

  Widget _vsSettingBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        textDirection: TextDirection.ltr,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 60.0,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 30),
                Expanded(
                  child: Text(
                    S.VSSettings.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SoundGestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset("lib/assets/png/close.png", width: 24, height: 24),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 59,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.MatchSmartdeviceplayer.tr,
                  style: const TextStyle(
                      color: color_main_text, fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                SoundGestureDetector(
                  onTap: () =>
                      controller.onlyDevicePlayer.value = !controller.onlyDevicePlayer.value,
                  child: Obx(
                    () => Image.asset(
                        'lib/assets/png/rank/rank_button_${controller.onlyDevicePlayer.value ? 'on' : 'off'}.png',
                        height: 26),
                  ),
                )
              ],
            ),
          ),
          Container(
              width: Get.width,
              height: 1,
              color: color_line,
              margin: const EdgeInsets.symmetric(horizontal: 16)),
        ],
      ),
    );
  }
}
