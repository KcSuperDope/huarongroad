import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/styles/styles.dart';

class BottomActionSheet {
  static show({
    required String title,
    required BuildContext context,
    required List<dynamic> actions,
    required dynamic current,
    required Function onSelect,
  }) {
    showModalBottomSheet(
      isDismissible: true,
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
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                    ),
                    height: 52.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 30),
                        Expanded(
                          child: Text(
                            title.tr,
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
                  itemCount: actions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = actions[index];
                    return Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.center,
                          height: 60,
                          color: item == current ? color_main.withOpacity(0.2) : Colors.white,
                          child: InkWell(
                            onTap: () {
                              onSelect(item);
                              Get.back();
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(item.contentText, style: const TextStyle(color: Colors.black, fontSize: 16.0)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(width: Get.width - 16.0, height: 1, color: color_line),
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
}
