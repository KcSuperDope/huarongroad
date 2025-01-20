import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_share.dart';
import 'package:huaroad/module/hrd/hrd_ai.dart';
import 'package:huaroad/module/hrd/hrd_board_bg.dart';
import 'package:huaroad/module/piece/piece.dart';
import 'package:huaroad/styles/styles.dart';

class HrdBoardWidget extends StatelessWidget {
  final Game game;
  final double? width;
  final double? pieceSpace;
  final bool? showBoardBg;
  final Color? boardBgColor;
  final double? boardRadius;
  final bool? isShowRecordPlay;

  final void Function(bool)? onAllowScroll;

  const HrdBoardWidget({
    Key? key,
    this.width,
    this.onAllowScroll,
    this.showBoardBg,
    this.boardBgColor,
    this.boardRadius,
    this.pieceSpace,
    this.isShowRecordPlay = false,
    required this.game,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = width ?? (MediaQuery.of(context).size.width - ui_page_padding * 2);
    final h = w / 4 * 5;
    final pieceW = w - ui_board_padding * 2;
    final size = pieceW / 4;
    return Listener(
      onPointerDown: (p) {
        if (onAllowScroll != null) {
          onAllowScroll!(false);
        }
      },
      onPointerUp: (p) {
        if (onAllowScroll != null) {
          onAllowScroll!(true);
        }
      },
      child: isShowRecordPlay!
          ? SizedBox(
              width: w,
              height: h,
              child: Obx(
                () => Stack(
                  children: [
                    Visibility(visible: showBoardBg ?? true, child: HrdBoardBackground(width: w, game: game)),
                    HrdAi(game: game, size: size, piece: game.aiTeach.teachModel.value),
                    Padding(
                      padding: const EdgeInsets.all(ui_board_padding),
                      child: HrdPieceList(game: game, size: size, pieceSpace: pieceSpace),
                    ),
                  ],
                ),
              ),
            )
          : RepaintBoundary(
              key: GameShare.shareBoardKey,
              child: SizedBox(
                width: w,
                height: h,
                child: Obx(
                  () => Stack(
                    children: [
                      Visibility(visible: showBoardBg ?? true, child: HrdBoardBackground(width: w, game: game)),
                      HrdAi(game: game, size: size, piece: game.aiTeach.teachModel.value),
                      Padding(
                        padding: const EdgeInsets.all(ui_board_padding),
                        child: HrdPieceList(game: game, size: size, pieceSpace: pieceSpace),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class HrdPieceList extends StatelessWidget {
  const HrdPieceList({
    super.key,
    this.pieceSpace,
    required this.game,
    required this.size,
  });

  final Game game;
  final double? pieceSpace;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: game.pieceList.map((e) => Piece(model: e, size: size, game: game, pieceSpace: pieceSpace)).toList(),
        ));
  }
}
