import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';

class BatteryWidget extends StatelessWidget {
  const BatteryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Image.asset(
        "lib/assets/png/battery_${FindDeviceHandler().deviceInfoModel.power.value >= 66 ? 3 : FindDeviceHandler().deviceInfoModel.power.value < 33 ? 1 : 2}.png",
        width: 24,
        height: 24,
      ),
    );
  }
}
