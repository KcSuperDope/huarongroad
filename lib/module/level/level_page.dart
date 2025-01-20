import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/auto_size.dart';
import 'package:huaroad/module/level/level_controller.dart';
import 'package:huaroad/module/level/widgets/level_app_bar.dart';
import 'package:huaroad/module/level/widgets/level_tree.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LevelPage extends StatelessWidget {
  final LevelController c = Get.put(LevelController());

  LevelPage({super.key});

  final double padding = 28.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_main,
      body: Stack(
        children: [
          Image.asset("lib/assets/png/level/level_title_bg.png"),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Obx(
                  () => LevelAppBar(
                    gameType: c.gameType.value,
                    title: S.Klotski.tr,
                    hard: c.currentHard.value,
                    hardIndex: c.currentHardIndex.value,
                    onSelect: (item) => c.changeLevel(item),
                  ),
                ),
                SizedBox(height: 12.s),
                Expanded(
                  child: Obx(
                    () => ScrollablePositionedList.builder(
                      shrinkWrap: true,
                      itemScrollController: c.itemScrollController,
                      itemCount: c.treeList.length,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) => LevelTree(
                        index: index,
                        model: c.treeList[index],
                        gameType: c.gameType.value,
                        onTap: (item) => c.onTapLevelItem(item: item),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
