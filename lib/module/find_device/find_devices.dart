// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/app_bar.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/device_info/device_name_edit_dialog.dart';
import 'package:huaroad/module/find_device/find_device_controller.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/styles/styles.dart';

class FindDevicesPage extends StatelessWidget {
  final bool? dialogMode;

  FindDevicesPage({Key? key, this.dialogMode}) : super(key: key);
  final FindDevicesController controller = Get.put(FindDevicesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: S.Devices,
        customBack: () {
          controller.cancelScan();
          Get.back();
        },
        showBack: dialogMode == null,
        right: dialogMode != null
            ? SoundGestureDetector(
                onTap: () {
                  controller.cancelScan();
                  Get.back();
                },
                child: Image.asset("lib/assets/png/close.png", width: 24, height: 24),
              )
            : SizedBox(),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            StreamBuilder<List<BluetoothDevice>>(
              stream: Stream.periodic(const Duration(milliseconds: 200))
                  .asyncMap((_) => FindDeviceHandler().checkDevices()),
              initialData: const [],
              builder: (c, snapshot) => snapshot.data!.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(S.Connected.tr, style: const TextStyle(fontSize: 13)),
                        ),
                        _scanDeviceItem(device: snapshot.data!.first, isConnected: true),
                        Container(height: 15, color: color_F6F6F6),
                      ],
                    )
                  : const SizedBox(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<List<ScanResult>>(
                    stream: FlutterBluePlus.scanResults,
                    initialData: const [],
                    builder: (c, snapshot) {
                      final list = snapshot.data
                          ?.where((element) => element.device.localName.startsWith(FindDeviceHandler().bleLocalName))
                          .toList();
                      return Obx(
                        () => !controller.isScanning.value && (list == null || list.isEmpty)
                            ? Center(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 153),
                                    Image.asset("lib/assets/png/1.0.7/empty_device.png", width: 200, height: 200),
                                    const SizedBox(height: 14),
                                    Text(S.Devicenotfound.tr, style: TextStyle(fontSize: 16, color: color_main_text))
                                  ],
                                ),
                              )
                            : Column(
                                children: list
                                        ?.map((r) =>
                                            r.device.remoteId.toString() != FindDeviceHandler().connectedDeviceId.value
                                                ? _scanDeviceItem(device: r.device, isConnected: false)
                                                : const SizedBox())
                                        .toList() ??
                                    [],
                              ),
                      );
                    }),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [scanButton()]),
            const SizedBox(height: 44),
          ],
        ),
      ),
    );
  }

  Widget scanButton() {
    return StreamBuilder<bool>(
      stream: FlutterBluePlus.isScanning,
      initialData: false,
      builder: (c, snapshot) {
        return SoundGestureDetector(
          onTap: () => snapshot.data! ? null : controller.startScan(),
          child: Container(
            alignment: Alignment.center,
            width: Get.width - 51 * 2,
            height: 40,
            decoration: BoxDecoration(
                color: snapshot.data! ? Colors.white : color_main,
                borderRadius: const BorderRadius.all(Radius.circular(ui_button_radius)),
                border: snapshot.data! ? Border.all(color: color_line, width: 1) : null),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                snapshot.data!
                    ? Obx(
                        () => Text(
                          '${S.Searching.tr}(${controller.countTime.value}s)',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : Text(
                        S.Searchagain.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _scanDeviceItem({required BluetoothDevice device, required bool isConnected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: 59,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "lib/assets/png/icon_${isConnected ? "link" : "bluetooth"}.png",
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DeviceNameHandler().deviceName(device),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SoundGestureDetector(
                  onTap: () {
                    isConnected ? controller.disconnect(device) : controller.onTapConnect(device);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                        color: isConnected ? Colors.white : color_main,
                        borderRadius: const BorderRadius.all(Radius.circular(ui_button_radius)),
                        border: isConnected ? Border.all(color: color_line, width: 1) : null),
                    child: Text(isConnected ? S.Disconnect.tr : S.Connect.tr, style: const TextStyle(fontSize: 13)),
                  ),
                )
              ],
            ),
          ),
          if (!isConnected) Container(height: 1, color: color_line)
        ],
      ),
    );
  }
}
