import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/util/dialog_util.dart';
import 'package:nordic_dfu/nordic_dfu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceDfuUtil {
  final ota_file_path_key = "ota_file_path";

  static DeviceDfuUtil? _instance;

  DeviceDfuUtil._internal() {
    _instance = this;
  }

  factory DeviceDfuUtil() => _instance ?? DeviceDfuUtil._internal();

  final _dfuProgress = 0.obs;
  BluetoothCharacteristic? _writeCharacteristic;

  Future<void> doDfu({String? filePath}) async {
    if (filePath == null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final savePath = prefs.getString(ota_file_path_key);
      if (savePath == null) return;
      filePath = savePath;
    }

    _dfuProgress.value = 0;
    String deviceId = FindDeviceHandler().deviceInfoModel.deviceId;
    Get.dialog(
      Obx(() =>
          DialogUtils.progress(title: S.FirmwareupgradingPleasedonotclosetheapp.tr, progress: _dfuProgress.value)),
      barrierDismissible: false,
    );

    try {
      await NordicDfu().startDfu(deviceId, filePath, fileInAsset: false, onError: (
        String address,
        int error,
        int errorType,
        String message,
      ) {
        if (Get.isDialogOpen!) {
          Get.back();
        }
        Fluttertoast.showToast(msg: S.Failed.tr);
      }, onProgressChanged: (deviceAddress, percent, speed, avgSpeed, currentPart, partsTotal) {
        _dfuProgress.value = percent;
      }, onDfuCompleted: (string) {
        Get.back();
        Fluttertoast.showToast(msg: S.FirmwareUpdateSuccessfully.tr);
      });
    } catch (e) {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      Fluttertoast.showToast(msg: S.Failed.tr);
    }
  }

  // 进入dfu模式
  Future<void> handle() async {
    Completer completer = Completer();
    List<BluetoothDevice> connectedDevices = await FindDeviceHandler().checkDevices();
    if (connectedDevices.isNotEmpty) {
      BluetoothDevice device = connectedDevices.first;
      List<BluetoothService> services = await device.discoverServices();
      BluetoothService service = services.firstWhere((s) => s.uuid.toString().toUpperCase().substring(4, 8) == 'FE59');
      List<BluetoothCharacteristic> characteristics = service.characteristics;
      _writeCharacteristic =
          characteristics.firstWhere((c) => c.uuid.toString().toUpperCase().substring(4, 8) == '0003');
      if (_writeCharacteristic != null) {
        _writeCharacteristic!.setNotifyValue(true);
        _writeCharacteristic!.write([0x01]);
        completer.complete();
      } else {
        completer.completeError("未找到服务");
      }
    } else {
      completer.completeError("未找到设备");
    }
  }

  void saveOtaFilePath(String filePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ota_file_path_key, filePath);
  }
}
