import 'package:flutter/material.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/hrd/hrd_board.dart';
import 'package:huaroad/module/hrd/hrd_title.dart';
import 'package:huaroad/module/hrd/hrd_title_top.dart';
import 'package:huaroad/styles/styles.dart';

class Hrd extends StatelessWidget {
  final Game game;
  final double? pieceSpace;
  final bool? showTitleTop;
  final Widget? bottomWidget;
  final Widget? titleWidget;
  final void Function(bool)? onAllowScroll;
  final bool? isShowRecordPlay;
  final Color? boardBackgroundColor;
  final double? boardRadius;

  const Hrd({
    Key? key,
    required this.game,
    this.onAllowScroll,
    this.showTitleTop = true,
    this.pieceSpace,
    this.bottomWidget,
    this.titleWidget,
    this.isShowRecordPlay = false,
    this.boardBackgroundColor,
    this.boardRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: ui_page_padding, right: ui_page_padding),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(44.0)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Visibility(visible: showTitleTop!, child: HrdTitleTop(game: game)),
          Container(
            decoration: BoxDecoration(
              color: boardBackgroundColor ?? Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(boardRadius ?? 0.0)),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        titleWidget ?? HrdTitle(game: game),
                        HrdBoardWidget(
                          game: game,
                          pieceSpace: pieceSpace,
                          isShowRecordPlay: isShowRecordPlay,
                          onAllowScroll: (allowScroll) {
                            if (onAllowScroll != null) {
                              onAllowScroll!(allowScroll);
                            }
                          },
                        ),
                      ],
                    ),
                    // HrdCover(game: game),
                  ],
                ),
                bottomWidget ?? const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
