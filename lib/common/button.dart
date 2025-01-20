import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';

class CommonButton extends StatelessWidget {
  final String? icon;
  final String title;
  final VoidCallback onTap;
  final bool? available;
  const CommonButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.available = true,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SoundGestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 46,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("lib/assets/png/btn_bg_left.png"),
                  Expanded(
                    child: Image.asset("lib/assets/png/btn_bg_center.png", fit: BoxFit.fill),
                  ),
                  Image.asset("lib/assets/png/btn_bg_right.png"),
                ],
              ),
            ),
            Positioned(
              top: 10,
              child:
                  Text(title.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
            Visibility(
              visible: !available!,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
