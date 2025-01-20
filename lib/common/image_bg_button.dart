import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';

class ImageBgButton extends StatelessWidget {
  ImageBgButton({
    Key? key,
    this.onTap,
    required this.text,
    required this.isSelected,
  }) : super(key: key);

  final String text;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SoundGestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        width: 160,
        height: 46,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage("lib/assets/png/1.0.7/button_bg${isSelected ? "_select" : ""}.png"),
          ),
        ),
        child: Text(text.tr, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20)),
      ),
    );
  }
}
