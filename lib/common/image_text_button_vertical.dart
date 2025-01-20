import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/styles/styles.dart';

class ImageTextButtonVertical extends StatelessWidget {
  const ImageTextButtonVertical({
    Key? key,
    this.onTap,
    this.textColor,
    required this.text,
    required this.imagePath,
    required this.imageSize,
  }) : super(key: key);

  final String text;
  final Color? textColor;
  final double imageSize;
  final String imagePath;
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
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: imageSize,
              height: imageSize,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 60),
              child: Text(
                text.tr,
                style: TextStyle(
                  color: textColor ?? color_main_text,
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
