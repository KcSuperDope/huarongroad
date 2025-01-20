import 'package:flutter/material.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';

class CreateGameButton extends StatelessWidget {
  final String? icon;
  final String title;
  final VoidCallback onTap;
  final bool? available;

  const CreateGameButton({
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
        height: 59,
        width: 164,
        alignment: Alignment.center,
        child: Stack(
          clipBehavior: Clip.none,
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
            Positioned(top: -13, left: -14, child: Image.asset("lib/assets/png/create.png", height: 59, width: 155)),
            Positioned(
              left: 63,
              top: 7,
              child: SizedBox(
                  width: 90,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
