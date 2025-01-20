import 'package:flutter/material.dart';

class ImagesAnimation extends StatefulWidget {
  final double w;
  final double h;
  final int durationMilliseconds;
  final ImagesAnimationEntry entry;
  final String animationPngName;

  const ImagesAnimation({
    Key? key,
    this.w = 80,
    this.h = 80,
    this.durationMilliseconds = 3,
    required this.entry,
    required this.animationPngName,
  }) : super(key: key);

  @override
  ImagesAnimationState createState() => ImagesAnimationState();
}

class ImagesAnimationState extends State<ImagesAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.durationMilliseconds))
      ..repeat();
    _animation = IntTween(begin: widget.entry.lowIndex, end: widget.entry.highIndex).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        String frame = _animation.value.toString();
        return Image.asset(
          "${widget.animationPngName}_$frame.png",
          gaplessPlayback: true,
          width: widget.w,
          height: widget.h,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ImagesAnimationEntry {
  int lowIndex = 0;
  int highIndex = 0;

  ImagesAnimationEntry({required this.lowIndex, required this.highIndex});
}
