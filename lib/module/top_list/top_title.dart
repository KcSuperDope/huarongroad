import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/styles/styles.dart';

class TopListTitle extends StatelessWidget {
  const TopListTitle({super.key, required this.gameMode, required this.gameType});

  final GameMode gameMode;
  final GameType gameType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(44)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 3,
            child: Text(
              S.Username.tr,
              style: const TextStyle(fontSize: 13, color: color_minor_text),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              S.moves.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: color_minor_text),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              S.Score.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: color_minor_text),
            ),
          ),
        ],
      ),
    );
  }
}
