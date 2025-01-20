import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? right;
  final bool? showBack;
  final VoidCallback? customBack;

  const CommonAppBar({
    Key? key,
    required this.title,
    this.right,
    this.customBack,
    this.showBack = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      leading: Visibility(
        visible: showBack!,
        child: SoundGestureDetector(
          onTap: () {
            if (customBack != null) {
              customBack!();
            } else {
              Get.back();
            }
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
            child: Image.asset("lib/assets/png/back.png", width: 24, height: 24),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: right ?? const SizedBox(width: 24),
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(48);
}
