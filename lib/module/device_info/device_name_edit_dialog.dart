import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';

class DeviceNameHandler {
  static DeviceNameHandler? _instance;

  DeviceNameHandler._internal() {
    _instance = this;
  }

  factory DeviceNameHandler() => _instance ?? DeviceNameHandler._internal();

  String deviceName(BluetoothDevice device) {
    final remoteId = device.remoteId.str;
    final userId = Global.userId;
    var name = device.localName;
    var data = GetStorage().read("user_custom_device_name");
    if (data == null) return name;
    if (data.containsKey(userId)) {
      final devicesCustomNames = data[userId] as Map;
      if (devicesCustomNames.containsKey(remoteId)) {
        final cusName = devicesCustomNames[remoteId];
        name = cusName;
      }
    }

    return name;
  }

  void customDeviceName(BluetoothDevice device, String customName) {
    final userId = Global.userId;
    final remoteId = FindDeviceHandler().deviceInfoModel.device!.remoteId.str;
    final data = {}.val("user_custom_device_name");
    final copyData = Map.from(data.val);

    if (copyData.containsKey(userId)) {
      final devicesCustomNames = copyData[userId] as Map;
      if (devicesCustomNames.containsKey(remoteId)) {
        devicesCustomNames[remoteId] = customName;
      } else {
        final newCustomNames = {remoteId: customName};
        devicesCustomNames.addAll(newCustomNames);
      }
    } else {
      final newCustomNews = {remoteId: customName};
      final userDeviceNames = {userId: newCustomNews};
      copyData.addAll(userDeviceNames);
    }
    data.val = copyData;
    FindDeviceHandler().deviceInfoModel.deviceName.value = customName;
    Fluttertoast.showToast(msg: S.Devicenamemodifiedsuccessfully.tr);
  }
}
