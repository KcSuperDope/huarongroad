import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/dialog_util.dart';

class LevelSyncDialog extends StatelessWidget {
  final void Function(bool isSelectDevice)? onLeftTap;
  final void Function(bool isSelectDevice)? onRightTap;
  final int appLevel;
  final int deviceLevel;

  LevelSyncDialog({
    Key? key,
    required this.onLeftTap,
    required this.onRightTap,
    required this.appLevel,
    required this.deviceLevel,
  }) : super(key: key);

  final isSelectDevice = true.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CommonDialogWidget(
        title: S.PleaseselecttheStageyouwanttosync,
        showClose: true,
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => isSelectDevice.value = !isSelectDevice.value,
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                border: Border.all(
                  width: isSelectDevice.value ? 0 : 1,
                  color: color_line,
                ),
                image: isSelectDevice.value
                    ? const DecorationImage(
                        image: ExactAssetImage("lib/assets/png/select_bg.png"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Image.asset(
                    "lib/assets/png/icon_equipment.png",
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    S.GANKlotski.tr + S.stageprogress.tr,
                    style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                  const Spacer(),
                  Text(
                    S.Lv.trArgs(['$deviceLevel']),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => isSelectDevice.value = !isSelectDevice.value,
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                border: Border.all(
                  width: isSelectDevice.value ? 0 : 1,
                  color: color_line,
                ),
                image: !isSelectDevice.value
                    ? const DecorationImage(
                        image: ExactAssetImage("lib/assets/png/select_bg.png"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Image.asset(
                    "lib/assets/png/icon_equipment.png",
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "APP" + S.stageprogress.tr,
                    style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                  const Spacer(),
                  Text(
                    S.Lv.trArgs([appLevel.toString()]),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            S.stageprogresoverwrittenunlockedlevel.trArgs(
                [isSelectDevice.value ? "APP" : S.GANKlotski.tr, '${isSelectDevice.value ? deviceLevel : appLevel}']),
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
          ),
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: CommonTextButton(
                  title: S.Cancel,
                  isBorder: true,
                  onTap: () => Get.back(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CommonTextButton(
                  title: S.Sync,
                  isBorder: false,
                  onTap: () {
                    Get.back();
                    if (onRightTap != null) {
                      onRightTap!(isSelectDevice.value);
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
