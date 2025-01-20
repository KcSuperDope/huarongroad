import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/styles/styles.dart';

class BottomCustomSheet {
  static show({
    required BuildContext context,
    required List<Widget> children,
    bool isDismissible = true,
    title = '',
  }) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: isDismissible,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 200),
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
                              title,
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
                Column(children: children),
              ],
            ),
          );
        });
  }
}
