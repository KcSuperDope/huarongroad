import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_share.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/util/dialog_util.dart';
import 'package:huaroad/util/time_util.dart';

class LevelSuccessDialog extends StatelessWidget {
  final Game game;
  final int starNum;
  final bool? newRecord;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;

  const LevelSuccessDialog({
    Key? key,
    this.newRecord = false,
    required this.starNum,
    required this.onLeftTap,
    required this.onRightTap,
    required this.game,
    // required this.onCloseTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Image.asset("lib/assets/png/dialog_bg_success.png"),
            Positioned(
              top: -60,
              child: Image.asset("lib/assets/png/tip_success.png", width: 119, height: 119),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: SoundGestureDetector(
                onTap: () async {
                  try {
                    final data = await GameShare.getShareData(game);
                    NativeFlutterPlugin.instance.openSharePage(data);
                    Get.back();
                  } catch (e) {
                    Get.back();
                  }
                  // onCloseTap();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 16),
                  child: Image.asset("lib/assets/png/icon_share.png", width: 16, height: 16),
                ),
              ),
            ),
            Visibility(
              visible: newRecord!,
              child: Positioned(
                top: 67,
                left: 11,
                child: Image.asset("lib/assets/png/icon_new_record.png", width: 52, height: 47),
              ),
            ),
            SizedBox(
              width: Get.width - 40,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 52),
                    Image.asset("lib/assets/png/icon_well_done.png", height: 23),
                    const SizedBox(height: 24),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 56), child: StarWidget(num: starNum)),
                    const SizedBox(height: 10),
                    Text(
                      "${game.history.totalCount}${S.Move.tr}",
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      TimeUtil.transformMilliSeconds(game.getTotalTime()),
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 40,
                        fontFamily: "BebasNeue",
                        shadows: [Shadow(color: Color(0xffE1F035), offset: Offset(2, 2), blurRadius: 0)],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: CommonTextButton(
                            title: S.Quitgame,
                            isBorder: true,
                            onTap: () {
                              Get.back();
                              onLeftTap();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CommonTextButton(
                            title: S.next,
                            isBorder: false,
                            onTap: () {
                              Get.back();
                              onRightTap();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarWidget extends StatelessWidget {
  final int num;

  const StarWidget({Key? key, required this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          "lib/assets/png/star_big_${num >= 1 ? "s" : "n"}.png",
          width: 48,
        ),
        Image.asset(
          "lib/assets/png/star_big_${num >= 2 ? "s" : "n"}.png",
          width: 48,
        ),
        Image.asset(
          "lib/assets/png/star_big_${num >= 3 ? "s" : "n"}.png",
          width: 48,
        ),
      ],
    );
  }
}
