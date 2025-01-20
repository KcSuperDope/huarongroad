import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/ble/ble_data_handler.dart';
import 'package:huaroad/module/device_info/device_name_edit_dialog.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';

class FindDevicesController extends GetxController {
  Timer? _timer;
  final int _timeout = 10;
  var countTime = 0.obs;
  final isScanning = false.obs;

  @override
  void onInit() async {
    BleDataHandler().onInit();
    await startScan();
    super.onInit();
  }

  @override
  void onClose() async {
    _timer?.cancel();
    _timer = null;
    await FlutterBluePlus.stopScan();
    super.onClose();
  }

  void cancelScan() async {
    await FlutterBluePlus.stopScan();
    _timer?.cancel();
    _timer = null;
  }

  Future startScan() async {
    countTime.value = _timeout;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (countTime <= 0) {
        timer.cancel();
        isScanning.value = false;
        await FlutterBluePlus.stopScan();
        return;
      }
      countTime--;
    });
    isScanning.value = true;
    await FlutterBluePlus.startScan(timeout: Duration(seconds: _timeout));
  }

  void onTapConnect(BluetoothDevice device) async {
    List<BluetoothDevice> connectedDevices = await FindDeviceHandler().checkDevices();
    if (connectedDevices.isNotEmpty) {
      Fluttertoast.showToast(msg: S.disconnectotherdevicesfirst.tr);
    } else {
      connect(device);
    }
  }

  void connect(BluetoothDevice device) async {
    _timer?.cancel();
    countTime.value = 0;
    await FlutterBluePlus.stopScan();
    Fluttertoast.showToast(msg: S.Connecting.tr);
    try {
      await device.connect(autoConnect: false, timeout: const Duration(seconds: 5));
      FindDeviceHandler().reportEvent(DeviceNameHandler().deviceName(device), 100,
          device.remoteId.toString(), '', 1, await device.readRssi());
    } catch (e) {
      FindDeviceHandler().reportEvent(DeviceNameHandler().deviceName(device), 100,
          device.remoteId.toString(), '', 3, await device.readRssi());
    }
    FindDeviceHandler().addDeviceStateListener(device);
  }

  void disconnect(BluetoothDevice device) async {
    await device.disconnect();
  }
}
