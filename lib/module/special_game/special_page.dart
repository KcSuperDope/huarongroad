import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/app_bar.dart';
import 'package:huaroad/common/image_text_button_vertical.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/hrd_game/hrd_game.dart';
import 'package:huaroad/module/hrd/hrd_board.dart';
import 'package:huaroad/module/special_game/specail_game_data.dart';
import 'package:huaroad/module/special_game/special_controller.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/styles/styles.dart';

class SpecialPage extends StatelessWidget {
  SpecialPage({Key? key}) : super(key: key);

  final c = Get.put(SpecialController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: S.Classic.tr,
        right: ImageTextButtonVertical(
            onTap: () => Get.toNamed(Routes.record_page, arguments: {"type": GameType.hrd, "mode": GameMode.famous}),
            imagePath: "lib/assets/png/icon_record.png",
            imageSize: 24,
            text: S.Records),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: c.games.length,
                itemBuilder: (context, index) {
                  final item = c.games[index];
                  return GestureDetector(
                    onTap: () => Get.toNamed(Routes.special_game_page, arguments: item),
                    child: SpecialListWidget(item: item, isSelected: false),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpecialListWidget extends StatelessWidget {
  final SpecialListItem item;
  final bool isSelected;

  const SpecialListWidget({
    Key? key,
    required this.item,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color_bg,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: isSelected ? Border.all(color: color_piece_green, width: 4) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 64 + 4,
            height: (64 + 4) / 4 * 5,
            decoration: BoxDecoration(
              color: color_minor_text,
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(width: 2, color: color_piece_green),
            ),
            child: HrdPieceList(size: 64 / 4, pieceSpace: 0, game: HrdGame.fromData(item.opening!)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (item.title ?? "").tr,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const SizedBox(width: 100),
                Stack(
                  children: [
                    Visibility(
                      visible: item.showNewHand ?? false,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                            border: Border.all(color: Colors.blue)),
                        child: Text(
                          S.Forbeginners.tr,
                          style: const TextStyle(color: Colors.blue, fontSize: 11),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: item.showMiddle ?? false,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                            border: Border.all(color: color_FF9126)),
                        child: Text(
                          S.Advancedstage.tr,
                          style: const TextStyle(color: color_FF9126, fontSize: 11),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: item.showHigh ?? false,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                            border: Border.all(color: Colors.red)),
                        child: Text(
                          S.ultimatechallenge.tr,
                          style: const TextStyle(color: Colors.red, fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 80,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: color_main,
                        borderRadius: BorderRadius.all(Radius.circular(ui_button_radius)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        S.StartChallenge.tr,
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Obx(() => Container(
                //       alignment: Alignment.bottomCenter,
                //       padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 7),
                //       decoration: const BoxDecoration(
                //         color: color_FAFDE1,
                //         borderRadius: BorderRadius.all(Radius.circular(6)),
                //       ),
                //       child: item.scoreStepLength.value > 0
                //           ? Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Column(
                //                   children: [
                //                     Text(
                //                       TimeUtil.transformMilliSeconds(item.scoreTime.value),
                //                       style: const TextStyle(
                //                           color: Colors.black,
                //                           fontSize: 14,
                //                           fontWeight: FontWeight.w400,
                //                           fontFamily: "VonwaonBitmap"),
                //                     ),
                //                     const SizedBox(height: 2),
                //                     Text(
                //                       S.Score.tr,
                //                       style: const TextStyle(
                //                         color: color_minor_text,
                //                         fontSize: 11,
                //                         fontWeight: FontWeight.w400,
                //                       ),
                //                     )
                //                   ],
                //                 ),
                //                 Column(
                //                   children: [
                //                     Text(
                //                       "${item.scoreStepLength.value}",
                //                       style: const TextStyle(
                //                           color: Colors.black,
                //                           fontSize: 14,
                //                           fontWeight: FontWeight.w400,
                //                           fontFamily: "VonwaonBitmap"),
                //                     ),
                //                     const SizedBox(height: 2),
                //                     Text(
                //                       S.moves.tr,
                //                       style: const TextStyle(
                //                         color: color_minor_text,
                //                         fontSize: 11,
                //                         fontWeight: FontWeight.w400,
                //                       ),
                //                     )
                //                   ],
                //                 ),
                //               ],
                //             )
                //           : Column(
                //               children: [
                //                 const Text("--", style: TextStyle(fontSize: 14)),
                //                 const SizedBox(height: 2),
                //                 Text(
                //                   S.Noscore.tr,
                //                   style: const TextStyle(
                //                     color: color_minor_text,
                //                     fontSize: 11,
                //                     fontWeight: FontWeight.w400,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //     ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
