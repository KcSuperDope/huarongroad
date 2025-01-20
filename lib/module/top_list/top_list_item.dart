import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/record/record_list_item.dart';
import 'package:huaroad/module/top_list/top_list_model.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/time_util.dart';

class TopListItem extends StatelessWidget {
  const TopListItem({super.key, required this.item, required this.index, this.bgColor});

  final TopListModel item;
  final int index;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return SoundGestureDetector(
      child: Container(
        width: Get.width,
        height: 69,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          image: item.rank.value > 0 && item.rank.value <= 3
              ? DecorationImage(
                  image: ExactAssetImage("lib/assets/png/famous/icon_no_${item.rank}_bg.png"),
                  fit: BoxFit.fill)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: item.rank.value > 0 && item.rank.value <= 3
                  ? Image.asset("lib/assets/png/famous/icon_no_${item.rank}.png",
                      width: 24, height: 24)
                  : Text(
                      "${item.rank.value == 0 ? S.Notonlist.tr : item.rank}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: item.rank.value == 0 ? 11 : 16, fontWeight: FontWeight.w600),
                    ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () =>
                          NativeFlutterPlugin.instance.openUserHomePage(item.appUserId ?? ''),
                      child: AvatarView(avatarUrl: item.avatar ?? "", size: 30)),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      item.nickname ?? "--",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: color_main_text,
                        fontWeight: FontWeight.w600,
                        shadows: item.shadowColor != null
                            ? [
                                Shadow(
                                    color: item.shadowColor!, blurRadius: 0, offset: Offset(1, 1))
                              ]
                            : [],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "${item.step.value}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: color_main_text),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                TimeUtil.transformMilliSeconds(item.duration.value ?? 0),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: "VonwaonBitmap",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
