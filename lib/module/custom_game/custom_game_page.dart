import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/app_bar.dart';
import 'package:huaroad/common/button.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/custom_game/custom_game_controller.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/hrd/hrd_board_bg.dart';
import 'package:huaroad/module/piece/piece.dart';
import 'package:huaroad/module/piece/piece_model.dart';
import 'package:huaroad/styles/styles.dart';

class CustomGamePage extends StatelessWidget {
  CustomGamePage({Key? key}) : super(key: key);
  final c = Get.put((CustomGameController()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: S.Customchessgame.tr),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              _buildBoard(),
              const SizedBox(height: 5),
              Text(S.Doubleclickchesstoremove.tr, style: const TextStyle(fontSize: 13, color: color_minor_text)),
              const SizedBox(height: 22),
              Row(
                  mainAxisAlignment:
                      c.gameType == GameType.hrd ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                  children: c.bottomList.map((element) => DragItem(model: element)).toList()),
              const SizedBox(height: 46),
              Row(
                children: [
                  SoundGestureDetector(
                    onTap: () => c.onResetBoard(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: Text(
                        S.reset.tr,
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 19),
                  Expanded(
                    child: Stack(
                      children: [
                        Obx(() => c.isBoardFinish.value
                            ? CommonButton(
                                title: S.SyncCompleted,
                                onTap: () => c.onSyncBoard(),
                                available: true,
                              )
                            : Container(
                                alignment: Alignment.center,
                                height: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.0),
                                  color: color_line,
                                ),
                                child: Text(
                                  "完成",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: color_main_text.withOpacity(0.2)),
                                ),
                              ))
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoard() {
    final width = c.size * 4 + ui_board_padding * 2;
    final height = width * 5 / 4;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          key: c.boardKey,
          height: height,
          width: width,
          alignment: Alignment.center,
          child: Obx(
            () => Stack(
              children: [
                HrdBoardBackground(width: width, game: Game()),
                Visibility(
                  visible: c.currentX.value >= 0 && c.currentY.value >= 0,
                  child: Positioned(
                    left: c.currentX.value * c.size + ui_board_padding,
                    top: c.currentY.value * c.size + ui_board_padding,
                    child: Container(
                      width: c.size * c.currentPiece.value.width!,
                      height: c.size * c.currentPiece.value.height!,
                      decoration: BoxDecoration(
                        color: c.currentPiece.value.color!.withOpacity(0.3),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(24.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(ui_board_padding),
                  child: Stack(
                    children: c.acceptList
                        .map((e) => Piece(
                              model: e,
                              size: c.size,
                              onDoubleTap: (model) => c.onDoubleTap(model),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: c.currentBoardState.value == BoardState.analysis ||
                  c.currentBoardState.value == BoardState.noSolution ||
                  c.currentBoardState.value == BoardState.success,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(22)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    width: width - ui_board_padding * 2,
                    height: height - ui_board_padding * 2,
                    color: Colors.white.withOpacity(0.8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(c.currentBoardImage.value, width: 120, height: 120),
                        const SizedBox(height: 15),
                        Text(
                          c.currentBoardString.value,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}

class BottomPieceController extends GetxController {}

class DragItem extends StatelessWidget {
  final PieceModel model;

  DragItem({Key? key, required this.model}) : super(key: key);
  final c = Get.put((CustomGameController()));
  final size = (Get.width - 16 * 2 - 20 * 3) / 4;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: BottomPieceController(),
        id: model.id,
        builder: (bottomC) {
          return Draggable(
            feedback: model.available!
                ? SizedBox(
                    key: c.anchorKey,
                    width: model.width! * c.size,
                    height: model.height! * c.size,
                    child: PieceWidget(model: model, size: c.size),
                  )
                : const SizedBox(),
            child: Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              child: PieceWidget(
                model: model,
                size: model.isNumber != null && model.isNumber! ? size : size / 2,
              ),
            ),
            onDragUpdate: (DragUpdateDetails details) => c.onDragUpdate(details, model),
            onDragEnd: (DraggableDetails details) => c.onDragEnd(details, model, bottomC),
            onDragStarted: () => c.onDragStart(model),
          );
        });
  }
}
