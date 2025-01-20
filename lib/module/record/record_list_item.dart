import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/record/record_list_item_title.dart';
import 'package:huaroad/module/record/record_model.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/time_util.dart';

class RecordListItem extends StatelessWidget {
  final int index;
  final RecordModel item;
  final void Function(RecordModel) onTap;

  const RecordListItem({super.key, required this.item, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (item.gameMode == GameMode.rank) {
      return _vsRecordListItem();
    }
    return SoundGestureDetector(
      onTap: () => onTap(item),
      child: Container(
        width: Get.width,
        height: 60,
        color: index % 2 == 0 ? Colors.white : color_bg,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "lib/assets/png/icon_record_${item.device == 1 ? "device" : "mobile"}.png",
              width: 24,
              height: 24,
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    item.gameMode == GameMode.freedom
                        ? (item.gameType == GameType.hrd
                            ? (item.stageId! <= 13 ? "${S.Stage.tr}${item.stageId}" : S.infinite.tr)
                            : (item.opening?.length == 17 ? "3x3" : "4x4"))
                        : RecordListItemTitle.handle(item).tr,
                    style: const TextStyle(fontSize: 14, color: color_main_text),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    TimeUtil.formatTimeMillis(item.startTime!),
                    style: const TextStyle(
                      fontSize: 11,
                      color: color_minor_text,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "${item.stepLength}${S.Move.tr}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: color_main_text,
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Text(
                  item.result == 0 ? TimeUtil.transformMilliSeconds(item.time!) : "DNF",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "VonwaonBitmap",
                  ),
                )),
            SizedBox(
              width: 24,
              child: item.result == 0
                  ? Image.asset("lib/assets/png/icon_next.png", width: 6, height: 10)
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vsRecordListItem() {
    return SoundGestureDetector(
      onTap: () => onTap(item),
      child: Container(
        width: Get.width,
        height: 60,
        color: index % 2 == 0 ? Colors.white : color_bg,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AvatarView(avatarUrl: item.blueResult?.player.avatar ?? ""),
                        const Padding(
                          padding: EdgeInsets.only(left: 5, right: 4),
                          child: Text(
                            'VS',
                            style: TextStyle(
                                color: color_main_text, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        AvatarView(avatarUrl: item.redResult?.player.avatar ?? ""),
                      ],
                    ),
                  ),
                  Text(
                    TimeUtil.formatTimeMillis(item.startTime!),
                    style: const TextStyle(
                      fontSize: 11,
                      color: color_minor_text,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                "${item.stepLength}${S.Move.tr}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: color_main_text,
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child: Text(
                  TimeUtil.transformMilliSeconds(item.time!),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "VonwaonBitmap",
                  ),
                )),
            Expanded(
              flex: 2,
              child: Image.asset(
                'lib/assets/png/rank/${item.result == 1 ? 'rank_icon_win' : 'rank_icon_lose'}.png',
                width: 38,
                height: 26,
              ),
            ),
            Expanded(
                flex: 1,
                child: Image.asset(
                  "lib/assets/png/icon_next.png",
                  width: 6,
                  height: 10,
                  alignment: Alignment.centerRight,
                ))
          ],
        ),
      ),
    );
  }
}

class AvatarView extends StatelessWidget {
  final String avatarUrl;
  final double? size;

  const AvatarView({super.key, required this.avatarUrl, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 20,
      height: size ?? 20,
      decoration:
          BoxDecoration(color: color_main, borderRadius: BorderRadius.circular((size ?? 20) / 2)),
      child: avatarUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular((size ?? 20) / 2),
              child: Image.network(
                avatarUrl,
                width: size ?? 20,
                height: size ?? 20,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'lib/assets/png/rank/rank_avatar.png',
                  width: size ?? 20,
                  height: size ?? 20,
                ),
              ))
          : Image.asset(
              'lib/assets/png/rank/rank_avatar.png',
              width: size ?? 20,
              height: size ?? 20,
            ),
    );
  }
}
