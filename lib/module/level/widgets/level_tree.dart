import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/level/model/level_model.dart';
import 'package:huaroad/module/level/widgets/level_item.dart';

class LevelTree extends StatelessWidget {
  final int index;
  final GameType gameType;
  final LevelTreeModel model;
  final void Function(LevelItemModel item) onTap;

  const LevelTree({
    Key? key,
    required this.model,
    required this.index,
    required this.onTap,
    required this.gameType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return model.isLastBottom
        ? Stack(
            children: [
              Image.asset(model.bgName, width: Get.width),
              Image.asset("lib/assets/png/level/level_bottom_bg_num.png", width: Get.width),
            ],
          )
        : model.items.isNotEmpty
            ? Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: Get.width,
                    height: model.height,
                    child: Stack(
                      alignment: AlignmentDirectional.topStart,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      children: [
                        Image.asset(model.bgName, width: Get.width),
                        Visibility(
                          visible: model.showCartoon,
                          child: Image.asset(model.cartoonName, width: Get.width),
                        ),
                        Positioned(
                          bottom: (gameType == GameType.hrd ? (model.isEnd ? 60 : 30) : 25),
                          child: Container(
                            width: Get.width,
                            padding: const EdgeInsets.symmetric(horizontal: 29),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:
                                  model.items.map((e) => LevelItem(item: e, onTap: (item) => onTap(item))).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const SizedBox();
  }
}
