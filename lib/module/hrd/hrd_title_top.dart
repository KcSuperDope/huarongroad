import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/game/game.dart';

class HrdTitleTop extends StatelessWidget {
  final Game game;

  const HrdTitleTop({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: game.state.value == GameState.error || game.state.value == GameState.pressOk
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "lib/assets/png/board_title_top_bg.png",
                    width: 254,
                    height: 22,
                  ),
                  Visibility(
                    visible: game.state.value == GameState.error,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.Placementisabnormalpleaserearrange.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: game.state.value == GameState.pressOk,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "点击",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                        Image.asset(
                          "lib/assets/png/icon_OK.png",
                          width: 16,
                          height: 16,
                        ),
                        const Text(
                          "键继续",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const SizedBox(
                height: 22,
              ),
      ),
    );
  }
}
