import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/appliction/application_controller.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/module/hrd/hrd_device.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/styles/styles.dart';

class DeviceNameWidget extends StatelessWidget {
  DeviceNameWidget({Key? key, required this.onTapDeviceName}) : super(key: key);

  final c = Get.find<ApplicationController>();
  final VoidCallback onTapDeviceName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(color: color_bg, borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Obx(
        () => FindDeviceHandler().deviceConnected.value
            ? Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: SoundGestureDetector(
                      onTap: () => onTapDeviceName(),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                          left: 14,
                          top: 16,
                          bottom: 13,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("lib/assets/png/swift_block_logo.png", width: 82, height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset("lib/assets/png/icon_edit.png", width: 24, height: 24),
                                const SizedBox(width: 4),
                                Text(
                                  FindDeviceHandler().deviceInfoModel.deviceName.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${S.Battery.tr}: ",
                                  style: const TextStyle(color: color_minor_text, fontSize: 13),
                                ),
                                const BatteryWidget(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(width: 1, height: 110, color: color_line),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => Get.toNamed(Routes.find_device_page),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("lib/assets/png/icon_change.png", width: 26, height: 26),
                          const SizedBox(height: 4),
                          Text(
                            S.Switch.tr,
                            style: const TextStyle(fontSize: 14, color: color_mid_text),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1, height: 48, color: color_line),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => c.onTapDisconnect(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("lib/assets/png/icon_power.png", width: 26, height: 26),
                          const SizedBox(height: 4),
                          Text(
                            S.Dis.tr,
                            style: const TextStyle(fontSize: 14, color: color_mid_text),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("lib/assets/png/swift_block_logo.png", width: 82, height: 16),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            Image.asset("lib/assets/png/icon_equipment.png", width: 24, height: 24),
                            const SizedBox(width: 6),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 190),
                              child: Text(
                                S.Devicenotconnected.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SoundGestureDetector(
                      onTap: () => FindDeviceHandler().onTapConnectDevice(),
                      child: Container(
                        height: 46,
                        width: 88,
                        alignment: Alignment.center,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: AlignmentDirectional.center,
                          children: [
                            SizedBox(
                              height: 46,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset("lib/assets/png/btn_bg_left.png"),
                                  Expanded(child: Image.asset("lib/assets/png/btn_bg_center.png", fit: BoxFit.fill)),
                                  Image.asset("lib/assets/png/btn_bg_right.png"),
                                ],
                              ),
                            ),
                            Text(
                              S.Connect.tr,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
