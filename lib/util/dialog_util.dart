import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/styles/styles.dart';

class CommonDialogWidget extends StatelessWidget {
  final String title;
  final bool showClose;
  final VoidCallback? onTapClose;
  final List<Widget> children;
  final Color? titleColor;

  const CommonDialogWidget({
    Key? key,
    this.onTapClose,
    required this.title,
    required this.showClose,
    required this.children,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SizedBox(
          width: Get.width - 40,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 30),
                  Expanded(
                    child: Text(
                      title.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: titleColor ?? Colors.black,
                      ),
                    ),
                  ),
                  showClose
                      ? SoundGestureDetector(
                          onTap: () {
                            Get.back();
                            if (onTapClose != null) {
                              onTapClose!();
                            }
                          },
                          child: Image.asset("lib/assets/png/close_small.png", width: 16, height: 16),
                        )
                      : const SizedBox(width: 30),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CommonTextButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool isBorder;

  const CommonTextButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.isBorder,
  });

  @override
  Widget build(BuildContext context) {
    return SoundGestureDetector(
      onTap: () => onTap(),
      child: Container(
        alignment: Alignment.center,
        width: (Get.width - 16 * 2 - 12 - 4.0) / 2,
        height: 40,
        decoration: BoxDecoration(
            color: isBorder ? Colors.white : color_main,
            borderRadius: const BorderRadius.all(Radius.circular(ui_button_radius)),
            border: isBorder ? Border.all(color: color_line, width: 2) : null),
        child: Text(
          title.tr,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class DialogUtils {
  static void showAlert(
      {String title = '',
      String content = '',
      String textLeft = S.Cancel,
      String? textRight = S.OK,
      String? singleText = S.OK,
      VoidCallback? onTapLeft,
      VoidCallback? onTapRight,
      VoidCallback? onTapClose,
      VoidCallback? onTapSingle,
      bool? isSingleButton = false,
      bool afterTapDismiss = true,
      bool showClose = true,
      Widget? bottomWidget}) {
    Get.dialog(
      barrierDismissible: false,
      CommonDialogWidget(
        title: title,
        showClose: showClose,
        onTapClose: onTapClose,
        children: [
          const SizedBox(height: 24),
          Text(
            content.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: color_mid_text,
            ),
          ),
          const SizedBox(height: 24),
          dialogButtonWidget(
            textRight: textRight,
            textLeft: textLeft,
            onLeftTap: onTapLeft,
            onRightTap: onTapRight,
            isSingleButton: isSingleButton,
            singleText: singleText,
            onSingleTap: onTapSingle,
          ),
          if (bottomWidget != null) bottomWidget,
        ],
      ),
    );
  }

  /// title + 图片 + 单个按钮
  static showTitleImageDialog({
    String title = '',
    String image = '',
    String buttonTitle = '',
    VoidCallback? onTap,
  }) {
    Get.dialog(
      barrierDismissible: false,
      CommonDialogWidget(title: title, showClose: true, children: [
        const SizedBox(height: 24),
        Image.asset(image, width: 115, height: 115),
        const SizedBox(height: 24),
        SoundGestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap();
            }
            Get.back();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            width: 165,
            height: 40,
            decoration: const BoxDecoration(
              color: color_main,
              borderRadius: BorderRadius.all(Radius.circular(ui_button_radius)),
            ),
            child: Text(
              buttonTitle,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  /// title + 图片 + content + 双按钮
  static showImageAlert({
    String title = '',
    Color? titleColor,
    String image = '',
    String content = '',
    String textLeft = S.Cancel,
    String? textRight = S.OK,
    VoidCallback? onTapLeft,
    VoidCallback? onTapRight,
  }) {
    Get.dialog(
      CommonDialogWidget(title: title, titleColor: titleColor, showClose: true, children: [
        Image.asset(image, width: 120, height: 120),
        const SizedBox(height: 3),
        Text(
          content.tr,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: color_mid_text,
          ),
        ),
        const SizedBox(height: 22),
        dialogButtonWidget(
          textRight: textRight,
          textLeft: textLeft,
          onLeftTap: onTapLeft,
          onRightTap: onTapRight,
        ),
      ]),
    );
  }

  /// 中间title
  static showTitleDialog({
    required String title,
    String textLeft = S.Cancel,
    String? textRight = S.OK,
    String? singleText = S.OK,
    VoidCallback? onLeftTap,
    VoidCallback? onRightTap,
    VoidCallback? onSingleTap,
    VoidCallback? onTapClose,
    bool? isSingleButton = false,
    bool showClose = true,
    bool afterTapDismiss = true,
  }) {
    Get.dialog(
      barrierDismissible: false,
      CommonDialogWidget(
        title: "",
        showClose: showClose,
        onTapClose: onTapClose,
        children: [
          Text(
            title.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 35),
          dialogButtonWidget(
            textRight: textRight,
            textLeft: textLeft,
            onLeftTap: onLeftTap,
            onRightTap: onRightTap,
            isSingleButton: isSingleButton,
            singleText: singleText,
            onSingleTap: onSingleTap,
            afterTapDismiss: afterTapDismiss,
          ),
        ],
      ),
    );
  }

  static Widget dialogButtonWidget({
    String textLeft = S.Cancel,
    String? textRight = S.OK,
    String? singleText = S.OK,
    VoidCallback? onLeftTap,
    VoidCallback? onRightTap,
    VoidCallback? onSingleTap,
    bool? isSingleButton = false,
    bool afterTapDismiss = true,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: isSingleButton!
          ? [
              Expanded(
                child: CommonTextButton(
                  title: singleText!,
                  isBorder: false,
                  onTap: () {
                    if (afterTapDismiss) Get.back();
                    if (onSingleTap != null) {
                      onSingleTap();
                    }
                  },
                ),
              ),
            ]
          : [
              Expanded(
                child: CommonTextButton(
                  title: textLeft,
                  isBorder: true,
                  onTap: () {
                    if (onLeftTap != null) {
                      onLeftTap();
                    }
                    Get.back();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CommonTextButton(
                  title: textRight!,
                  isBorder: false,
                  onTap: () {
                    if (afterTapDismiss) Get.back();
                    if (onRightTap != null) {
                      onRightTap();
                    }
                  },
                ),
              ),
            ],
    );
  }

  /// 进度条
  static Widget progress({String title = 'title', String content = 'content', int progress = 0}) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CommonDialogWidget(
        title: title,
        showClose: false,
        children: [
          const SizedBox(height: 24),
          Image.asset("lib/assets/png/tip_loading.png", width: 219, height: 73),
          const SizedBox(height: 11),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 24.0,
                width: 260,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(width: 2, color: color_main_text),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  child: LinearProgressIndicator(
                    value: progress.toDouble() / 100,
                    backgroundColor: Colors.white,
                    color: color_main,
                  ),
                ),
              ),
              Text(
                '$progress%',
                style: const TextStyle(
                  color: color_main_text,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
