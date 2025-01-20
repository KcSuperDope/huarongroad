import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/appliction/application_controller.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/module/hrd/hrd_device.dart';

class ApplicationDeviceWidget extends StatelessWidget {
  ApplicationDeviceWidget({
    Key? key,
    required this.onTapDeviceName,
  }) : super(key: key);

  final c = Get.find<ApplicationController>();
  final VoidCallback onTapDeviceName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Obx(
        () => FindDeviceHandler().deviceConnected.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: SoundGestureDetector(
                      onTap: () => onTapDeviceName(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset("lib/assets/png/icon_record_device.png", width: 24, height: 24),
                          const SizedBox(width: 4),
                          Text(
                            FindDeviceHandler().deviceInfoModel.deviceName.value,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => onTapDeviceName(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const BatteryWidget(),
                          Image.asset("lib/assets/png/icon_back_right.png", width: 24, height: 24),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset("lib/assets/png/icon_link.png", width: 24, height: 24),
                      const SizedBox(width: 6),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 190),
                        child: Text(
                          S.Devicenotconnected.tr,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
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
                          Padding(
                            padding: const EdgeInsets.only(right: 4, bottom: 4),
                            child: Text(
                              S.Connect.tr,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
