import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/util/dialog_util.dart';

// 带背景和主图的dialog
class BgDialog extends StatelessWidget {
  final String title;
  final String? leftText;
  final String? rightText;
  VoidCallback? onTapRight;
  int? extraArgs;

  BgDialog({
    Key? key,
    required this.title,
    this.leftText,
    this.rightText,
    this.onTapRight,
    this.extraArgs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            insetPadding: const EdgeInsets.all(32),
            contentPadding: const EdgeInsets.all(0.0),
            content: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  child: SizedBox(child: Image.asset("lib/assets/png/1.0.7/dialog_bg.png", width: Get.width - 64)),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: Get.width - 64,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(extraArgs != null ? title.trArgs(["$extraArgs"]) : title.tr,
                            style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 36),
                      _buildButtons(),
                    ],
                  ),
                ),
                Positioned(top: -65, child: Image.asset("lib/assets/png/1.0.5/game_success_fg.png", width: 120)),
                Positioned(
                  right: 8,
                  top: 16,
                  child: SoundGestureDetector(
                    onTap: () {
                      Get.back();
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8, right: 16, bottom: 16),
                      child: Image.asset("lib/assets/png/close_small.png", width: 16, height: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: CommonTextButton(
            title: (leftText ?? "").tr,
            isBorder: true,
            onTap: () {
              Get.back();
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CommonTextButton(
            title: (rightText ?? "").tr,
            isBorder: false,
            onTap: () {
              Get.back();
              onTapRight != null ? onTapRight!() : null;
            },
          ),
        ),
      ],
    );

    // return SizedBox();
  }
}
