import 'package:flutter/material.dart';
import 'package:huaroad/common/audio_palyer.dart';

class SoundGestureDetector extends StatelessWidget {
  const SoundGestureDetector({
    Key? key,
    required this.child,
    this.onTap,
    this.onPanStart,
    this.onPanUpdate,
    this.onDoubleTap,
  }) : super(key: key);

  final Widget child;
  final GestureTapCallback? onTap;
  final GestureDragStartCallback? onPanStart;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureTapCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onTapDown: (g) {
        if (onTap == null) return;
        HRAudioPlayer().playClick();
      },
      onTap: () {
        if (onTap == null) return;
        onTap!();
      },
    );
  }
}
