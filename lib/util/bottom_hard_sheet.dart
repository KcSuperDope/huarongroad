import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/level/level_hard_handler.dart';
import 'package:huaroad/styles/styles.dart';

class BottomActionSheet {
  static show({
    required BuildContext context,
    required List<BottomSheetModel> actions,
    required int current,
    required Function onSelect,
    required int lastHardIndex,
    GameType? type,
    bool isDismissible = true,
    SheetPage page = SheetPage.home,
    RankPlayerModel? rankPlayerModel,
  }) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            textDirection: TextDirection.ltr,
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: color_FFFFFF,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    height: 52.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 30),
                        Expanded(
                          child: Text(
                            S.Selectstage.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SoundGestureDetector(
                          onTap: () => Get.back(),
                          child: Image.asset("lib/assets/png/close.png", width: 24, height: 24),
                        ),
                      ],
                    ),
                  ),
                  Container(width: Get.width, height: 1, color: color_line),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      (type == GameType.hrd && (page == SheetPage.home || page == SheetPage.rank))
                          ? actions.length - 1
                          : actions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = actions[index];
                    Widget subTitle = const SizedBox();
                    if (type == GameType.hrd) {
                      if (index == 0) {
                        subTitle = _subTitleView(S.Forbeginners);
                      }
                      if (index == 4) {
                        subTitle = _subTitleView(S.Advancedstage);
                      }
                      if (index == 9) {
                        subTitle = _subTitleView(S.ultimatechallenge);
                      }
                    }
                    return Column(
                      children: [
                        subTitle,
                        page == SheetPage.rank
                            ? _rankItem(
                                item, current, onSelect, lastHardIndex, rankPlayerModel, index)
                            : _normalItem(
                                item: item,
                                current: current,
                                onSelect: onSelect,
                                page: page,
                                lastHardIndex: lastHardIndex,
                                rankPlayerModel: rankPlayerModel,
                              )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _normalItem({
    required BottomSheetModel item,
    required int current,
    required Function onSelect,
    required int lastHardIndex,
    SheetPage page = SheetPage.home,
    RankPlayerModel? rankPlayerModel,
  }) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          height: 60,
          color: item.index == current ? color_main.withOpacity(0.2) : Colors.white,
          child: InkWell(
            onTap: () {
              onSelect(item);
              Get.back();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.left,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Stack(
                      children: [
                        Visibility(
                          visible: page == SheetPage.level &&
                              !(item.index <= lastHardIndex && page == SheetPage.home),
                          child: Row(
                            children: [
                              item.showStar
                                  ? RichText(
                                      text: TextSpan(
                                          text: "${item.starNum}",
                                          style:
                                              const TextStyle(color: color_FF9126, fontSize: 16.0),
                                          children: [
                                            TextSpan(
                                              text: "/${item.totalStarNum}",
                                              style: const TextStyle(
                                                  color: color_minor_text, fontSize: 16.0),
                                            )
                                          ]),
                                    )
                                  : Text(
                                      item.right,
                                      style: const TextStyle(
                                        color: color_minor_text,
                                        fontSize: 16.0,
                                      ),
                                    ),
                              const SizedBox(width: 7),
                              Image.asset(item.rightImage, width: 24),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: page == SheetPage.home,
                          child: Text(
                            item.hardDesc,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: color_minor_text,
                            ),
                          ),
                        ),
                        Visibility(
                            visible: page == SheetPage.rank,
                            child: Row(
                              children: [
                                if (rankPlayerModel?.rivalLevel == lastHardIndex)
                                  _sameLastHardView(
                                    rankPlayerModel?.myAvatar != null &&
                                            rankPlayerModel?.myAvatar != ''
                                        ? rankPlayerModel!.myAvatar!
                                        : '',
                                    rankPlayerModel?.rivalAvatar != null &&
                                            rankPlayerModel?.rivalAvatar != ''
                                        ? rankPlayerModel!.rivalAvatar!
                                        : '',
                                  ),
                                if (item.index == lastHardIndex &&
                                    (rankPlayerModel?.rivalLevel != lastHardIndex))
                                  _lastHardView(rankPlayerModel?.myAvatar != null &&
                                          rankPlayerModel?.myAvatar != ''
                                      ? rankPlayerModel!.myAvatar!
                                      : ''),
                                if (item.index == rankPlayerModel?.rivalLevel &&
                                    (rankPlayerModel?.rivalLevel != lastHardIndex))
                                  _lastHardView(rankPlayerModel?.rivalAvatar != null &&
                                          rankPlayerModel?.rivalAvatar != ''
                                      ? rankPlayerModel!.rivalAvatar!
                                      : ''),
                                Container(
                                  width: 58,
                                  alignment: Alignment.centerRight,
                                  child: Visibility(
                                    visible: item.index == current,
                                    child: Image.asset(
                                      "lib/assets/png/rank/rank_icon_choose.png",
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                )
                              ],
                            ))
                      ],
                    )
                  ],
                ),
                Visibility(
                  visible: page == SheetPage.level,
                  child: Text(
                    item.center,
                    style: const TextStyle(
                      color: color_minor_text,
                      fontSize: 13.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(width: Get.width - 16.0, height: 1, color: color_line),
      ],
    );
  }

  static Widget _lastHardView(String avatar) {
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      clipBehavior: Clip.none,
      children: [
        UnconstrainedBox(
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 5, 7, 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: color_main),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              S.stageprogress.tr,
              style: const TextStyle(color: color_minor_text, fontSize: 11),
            ),
          ),
        ),
        Positioned(
          left: -20,
          child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: color_main)),
              child: avatar.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(avatar,
                          width: 30,
                          height: 30,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                              'lib/assets/png/rank/rank_avatar.png',
                              width: 30,
                              height: 30)))
                  : Image.asset(
                      'lib/assets/png/rank/rank_avatar.png',
                      width: 30,
                      height: 30,
                    )),
        ),
      ],
    );
  }

  static Widget _rankItem(BottomSheetModel item, int current, Function onSelect, int lastHardIndex,
      RankPlayerModel? rankPlayerModel, int index) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          height: 60,
          color: item.index == current ? color_main.withOpacity(0.2) : Colors.white,
          child: InkWell(
            onTap: () {
              onSelect(item);
              Get.back();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.left,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Stack(
                  children: [
                    Row(
                      children: [
                        if (item.index == lastHardIndex &&
                            rankPlayerModel?.rivalLevel == lastHardIndex)
                          _sameLastHardView(
                            rankPlayerModel?.myAvatar != null && rankPlayerModel?.myAvatar != ''
                                ? rankPlayerModel!.myAvatar!
                                : '',
                            rankPlayerModel?.rivalAvatar != null &&
                                    rankPlayerModel?.rivalAvatar != ''
                                ? rankPlayerModel!.rivalAvatar!
                                : '',
                          ),
                        if (item.index == lastHardIndex &&
                            (rankPlayerModel?.rivalLevel != lastHardIndex))
                          _lastHardView(
                              rankPlayerModel?.myAvatar != null && rankPlayerModel?.myAvatar != ''
                                  ? rankPlayerModel!.myAvatar!
                                  : ''),
                        if (item.index == rankPlayerModel?.rivalLevel &&
                            (rankPlayerModel?.rivalLevel != lastHardIndex))
                          _lastHardView(rankPlayerModel?.rivalAvatar != null &&
                                  rankPlayerModel?.rivalAvatar != ''
                              ? rankPlayerModel!.rivalAvatar!
                              : ''),
                        Container(
                          width: 58,
                          alignment: Alignment.centerRight,
                          child: Visibility(
                            visible: item.index == current,
                            child: Image.asset(
                              "lib/assets/png/rank/rank_icon_choose.png",
                              width: 30,
                              height: 30,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Container(width: Get.width - 16.0, height: 1, color: color_line),
      ],
    );
  }

  static Widget _sameLastHardView(String myAvatar, String rivalAvatar) {
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      clipBehavior: Clip.none,
      children: [
        _lastHardView(myAvatar),
        Positioned(
          left: -35,
          child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: color_main)),
              child: rivalAvatar.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(rivalAvatar,
                          width: 30,
                          height: 30,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                              'lib/assets/png/rank/rank_avatar.png',
                              width: 30,
                              height: 30)))
                  : Image.asset(
                      'lib/assets/png/rank/rank_avatar.png',
                      width: 30,
                      height: 30,
                    )),
        ),
      ],
    );
  }

  static Widget _subTitleView(String text) {
    return Container(
      color: color_bg,
      height: 39,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        text.tr,
        style: const TextStyle(
          color: color_mid_text,
          fontSize: 13.0,
        ),
      ),
    );
  }
}
