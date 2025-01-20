import 'package:flutter/material.dart';

class LevelItemStarWidget extends StatelessWidget {
  final int num;

  const LevelItemStarWidget({Key? key, required this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 4,
            left: 0,
            child: Image.asset(
              "lib/assets/png/level/star_small_${num >= 1 ? "s" : "n"}.png",
              width: 26,
            ),
          ),
          Positioned(
            top: 0,
            left: 21,
            child: Image.asset(
              "lib/assets/png/level/star_small_${num >= 2 ? "s" : "n"}.png",
              width: 26,
            ),
          ),
          Positioned(
            top: 4,
            right: 0,
            child: Image.asset(
              "lib/assets/png/level/star_small_${num >= 3 ? "s" : "n"}.png",
              width: 26,
            ),
          ),
        ],
      ),
    );
  }
}
