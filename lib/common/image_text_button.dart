import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/styles/styles.dart';

class ImageTextButton extends StatelessWidget {
  const ImageTextButton({
    Key? key,
    this.onTap,
    required this.text,
    required this.imagePath,
    required this.imageSize,
  }) : super(key: key);

  final String text;
  final String imagePath;
  final double imageSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SoundGestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        height: 30,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(ui_button_radius)),
          border: Border.all(color: color_main_text.withOpacity(0.4), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text.tr,
              style: TextStyle(
                color: color_main_text.withOpacity(0.7),
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            Image.asset(
              imagePath,
              width: imageSize,
              height: imageSize,
            ),
          ],
        ),
      ),
    );
  }
}
