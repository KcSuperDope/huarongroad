import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/ble/ble_data_handler.dart';
import 'package:huaroad/module/device_info/device_dfu_util.dart';
import 'package:huaroad/module/device_info/device_info_model.dart';
import 'package:huaroad/module/device_info/device_name_edit_dialog.dart';
import 'package:huaroad/module/device_info/firmware_update_handler.dart';
import 'package:huaroad/plugin/model/report_event_model.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/util/dialog_util.dart';
import 'package:huaroad/util/eventbus_utils.dart';

class FindDeviceHandler {
  static FindDeviceHandler? _instance;

  final deviceInfoModel = DeviceInfoModel();
  final deviceConnected = false.obs;
  BluetoothDevice? bluetoothDevice;
  BluetoothCharacteristic? _writeCharacteristic;
  BluetoothCharacteristic? _notifyCharacteristic;
  StreamSubscription<List<int>>? _dataSubscription;
  StreamSubscription<BluetoothConnectionState>? _stateSubscription;
  bool _isConnected = false;
  var connectedDeviceId = ''.obs;
  final bleLocalName = "wiSlide";
  Timer? _timer;

  FindDeviceHandler._internal() {
    _instance = this;
  }

  factory FindDeviceHandler() => _instance ?? FindDeviceHandler._internal();

  Future<List<BluetoothDevice>> checkDevices() async {
    final list = FlutterBluePlus.connectedDevices;
    final res = list.where((device) => device.platformName.startsWith(bleLocalName)).toList();
    return res;
  }

  // Future<void> update() async {
  //   final connectDevices = await checkDevices();
  //   if (connectDevices.isNotEmpty) {
  //     bluetoothDevice = connectDevices.first;
  //     deviceConnected.value = true;
  //     deviceInfoModel.set(deviceName: DeviceNameHandler().deviceName(bluetoothDevice!));
  //     deviceInfoModel.set(deviceId: bluetoothDevice!.remoteId.toString());
  //     deviceInfoModel.device = bluetoothDevice;
  //     addDeviceStateListener(bluetoothDevice!);
  //   }
  // }

  Future startNotify() async {
    cancelNotify();
    deviceConnected.value = true;
    deviceInfoModel.set(deviceName: DeviceNameHandler().deviceName(bluetoothDevice!));
    deviceInfoModel.set(deviceId: bluetoothDevice!.remoteId.toString());
    deviceInfoModel.device = bluetoothDevice;
    return notify();
  }

  void cancelNotify() {
    if (_dataSubscription != null) {
      _dataSubscription!.cancel();
      _dataSubscription = null;
    }
  }

  void cancelDeviceStateListener() {
    if (_stateSubscription != null) {
      _stateSubscription!.cancel();
      _stateSubscription = null;
    }
  }

  void onTapConnectDevice() async {
    FlutterBluePlus.adapterState.listen((event) {
      BluetoothAdapterState state = event;
      if (state == BluetoothAdapterState.on) {
        if (!Get.isDialogOpen!) {
          Get.toNamed(Routes.find_device_page);
        }
      } else if (state == BluetoothAdapterState.off ||
          state == BluetoothAdapterState.unavailable ||
          state == BluetoothAdapterState.unauthorized) {
        if (!Get.isDialogOpen!) {
          DialogUtils.showTitleImageDialog(
            title: S.Bluetoothnotenabled,
            image: "lib/assets/png/tip_bluetooth_off.png",
            buttonTitle: S.Enablebluetooth,
            onTap: () => AppSettings.openAppSettings(type: AppSettingsType.bluetooth),
          );
        }
      } else {}
    });
  }

  void addDeviceStateListener(BluetoothDevice device) {
    cancelDeviceStateListener();
    _stateSubscription = device.connectionState.listen((state) async {
      if (state == BluetoothConnectionState.connected) {
        if (!_isConnected) {
          Fluttertoast.cancel();
          _isConnected = true;
          connectedDeviceId.value = device.remoteId.toString();
          bluetoothDevice = device;
          await startNotify();
          eventBus.fire(DeviceConnectedEvent(true));
          startTimer();

          Get.back();
          _checkFirmwareUpdate();
          Future.delayed(
              3.seconds,
              () async => reportEvent(
                  deviceInfoModel.deviceName.value,
                  deviceInfoModel.power.value,
                  deviceInfoModel.deviceId,
                  deviceInfoModel.softwareVersion,
                  2,
                  await device.readRssi()));
        }
      }
      if (state == BluetoothConnectionState.disconnected) {
        reportEvent(deviceInfoModel.deviceName.value, deviceInfoModel.power.value,
            deviceInfoModel.deviceId, deviceInfoModel.softwareVersion, 4, 0);
        try {
          await device.disconnect();
        } catch (e) {}
        Fluttertoast.cancel();
        _isConnected = false;
        connectedDeviceId.value = "";
        deviceConnected.value = false;
        deviceInfoModel.clear();
        cancelNotify();
        cancelDeviceStateListener();
        cancelTimer();
        eventBus.fire(DeviceConnectedEvent(false));
      }
    });
  }

  Future notify() async {
    Completer completer = Completer();
    if (bluetoothDevice == null) completer.completeError("设备不存在");
    List<BluetoothService> totalServices = await bluetoothDevice!.discoverServices();
    List<BluetoothService> services = totalServices
        .where((s) => s.uuid.toString().toUpperCase().substring(4, 8) == '000A')
        .toList();
    if (services.isNotEmpty) {
      List<BluetoothCharacteristic> characteristics = services.first.characteristics;
      _notifyCharacteristic = characteristics
          .firstWhere((c) => c.uuid.toString().toUpperCase().substring(4, 8) == '000B');
      _writeCharacteristic = characteristics
          .firstWhere((c) => c.uuid.toString().toUpperCase().substring(4, 8) == '000C');
      await _notifyCharacteristic!.setNotifyValue(true);
      if (_writeCharacteristic != null) {
        BleDataHandler().initCharacteristic(_writeCharacteristic!);
      }
      _dataSubscription = _notifyCharacteristic!.lastValueStream.listen((value) {
        BleDataHandler().decode(value);
      });
    } else {
      await DeviceDfuUtil().doDfu();
    }
    completer.complete();
    return completer.future;
  }

  void startTimer() {
    _timer ??= Timer.periodic(1.minutes, (t) => BleDataHandler().send([0x03]));
  }

  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _checkFirmwareUpdate() async {
    if (await FirmwareUpdateHandler().hasNewVersion()) {
      FirmwareUpdateHandler().showUpdateDialog();
    }
  }

  ///设备埋点
  void reportEvent(String deviceName, int batteryPower, String deviceMac, String deviceVersion,
      int connectState, int rssi) {
    DeviceEvent deviceEvent = DeviceEvent(
        deviceName: deviceName,
        batteryPower: batteryPower,
        deviceMac: deviceMac,
        deviceVersion: deviceVersion,
        connectState: connectState,
        rssi: rssi);
    ReportEventModel reportEventModel =
        ReportEventModel(eventId: EventId.device, deviceEvent: deviceEvent);
    NativeFlutterPlugin.instance.reportEvent(reportEventModel);
  }
}
