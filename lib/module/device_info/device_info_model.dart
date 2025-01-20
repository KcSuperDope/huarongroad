import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class DeviceInfoModel {
  BluetoothDevice? device;

  final deviceName = 'N/A'.obs;
  String deviceId = 'N/A';
  String resetReason = 'N/A';
  String softwareVersion = 'N/A';
  String hardwareVersion = '1.0';
  String compileTime = 'N/A';
  String prodCode = "";
  final power = 100.obs;
  List<int> macAddress = [];

  void set(
      {String? deviceName,
      String? deviceId,
      int? power,
      String? softwareVersion,
      String? hardwareVersion,
      String? resetReason,
      String? compileTime,
      String? prodCode,
      BluetoothDevice? device,
      List<int>? macAddress}) {
    if (deviceName != null) this.deviceName.value = deviceName;
    if (deviceId != null) this.deviceId = deviceId;
    if (power != null) this.power.value = power;
    if (softwareVersion != null) this.softwareVersion = softwareVersion;
    if (hardwareVersion != null) this.hardwareVersion = hardwareVersion;
    if (resetReason != null) this.resetReason = resetReason;
    if (prodCode != null) this.prodCode = prodCode;
    if (compileTime != null) this.compileTime = compileTime;
    if (device != null) this.device = device;
    if (macAddress != null && macAddress.isNotEmpty) this.macAddress = macAddress;
  }

  void clear() {
    deviceName.value = 'N/A';
    deviceId = 'N/A';
    power.value = 0;
    softwareVersion = 'N/A';
    hardwareVersion = 'N/A';
    resetReason = 'N/A';
    prodCode = 'N/A';
    compileTime = 'N/A';
    macAddress.clear();
    device = null;
  }
}
