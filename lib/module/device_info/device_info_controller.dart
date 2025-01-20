import 'package:get/get.dart';
import 'package:huaroad/module/ble/ble_data_handler.dart';
import 'package:huaroad/module/device_info/device_info_model.dart';
import 'package:huaroad/module/device_info/firmware_update_handler.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';

class DeviceInfoController extends GetxController {
  late DeviceInfoModel deviceInfoModel;
  final hasNewVersion = false.obs;

  @override
  void onInit() async {
    super.onInit();
    deviceInfoModel = FindDeviceHandler().deviceInfoModel;
    getDeviceInfo();
    hasNewVersion.value = await FirmwareUpdateHandler().hasNewVersion();
  }

  void getDeviceInfo() {
    BleDataHandler().send([0x02]);
    BleDataHandler().send([0x03]);
  }

  void disConnect() async {
    if (deviceInfoModel.device != null) {
      await deviceInfoModel.device!.disconnect();
      Get.back();
    }
  }

  void onTapUpdate() {
    FirmwareUpdateHandler().showUpdateDialog();
  }
}
