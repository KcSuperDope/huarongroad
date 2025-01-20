import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/ai_use_util.dart';

class AISolutionButton extends StatelessWidget {
  const AISolutionButton({
    Key? key,
    required this.onTap,
    required this.isInTeaching,
    required this.type,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool isInTeaching;
  final GameType type;

  @override
  Widget build(BuildContext context) {
    return SoundGestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(ui_button_radius)),
            border: Border.all(color: color_main_text.withOpacity(0.4), width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isInTeaching ? S.closeTutorial.tr : S.AITutorial.tr,
              style: TextStyle(fontSize: 14, color: color_main_text.withOpacity(0.7)),
            ),
            const SizedBox(width: 4),
            isInTeaching
                ? Image.asset("lib/assets/png/close_small.png", width: 12, height: 12)
                : Obx(() => Text(
                      "x${AIUseUtils().lastAICount.value}",
                      style: TextStyle(color: color_main_text.withOpacity(0.7), fontSize: 14),
                    )),
          ],
        ),
      ),
    );
  }
}
