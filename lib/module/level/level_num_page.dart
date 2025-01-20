import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/level/level_num_controller.dart';
import 'package:huaroad/module/level/model/level_model.dart';
import 'package:huaroad/module/level/widgets/level_app_bar.dart';
import 'package:huaroad/module/level/widgets/level_tree.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LevelNumPage extends StatelessWidget {
  final LevelNumController c = Get.put(LevelNumController());

  LevelNumPage({super.key});

  final double padding = 28.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_bg_level_num,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 44 + 34),
            child: MediaQuery.removePadding(
              removeBottom: true,
              removeTop: true,
              context: context,
              child: ScrollablePositionedList.builder(
                shrinkWrap: true,
                itemCount: c.treeList.length,
                itemScrollController: c.itemScrollController,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) => LevelTree(
                  index: index,
                  model: c.treeList[index],
                  gameType: c.gameType.value,
                  onTap: (LevelItemModel item) => c.onTapLevelItem(item: item),
                ),
              ),
            ),
          ),
          Positioned(
            top: -(48 - MediaQuery.of(context).padding.top),
            child: Image.asset(
              "lib/assets/png/level/level_title_bg_num.png",
              width: Get.width,
              height: 124 * Get.width / 375,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: LevelAppBar(
              gameType: c.gameType.value,
              title: c.gameType.value == GameType.number3x3 ? S.stage3x3.tr : S.stage4x4.tr,
            ),
          ),
        ],
      ),
    );
  }
}
