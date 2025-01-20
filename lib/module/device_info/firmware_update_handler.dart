import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/device_info/device_dfu_util.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/net/env/env_config.dart';
import 'package:huaroad/net/http/dio_util.dart';
import 'package:huaroad/util/dialog_util.dart';
import 'package:huaroad/util/logger.dart';
import 'package:path_provider/path_provider.dart';

class FirmwareUpdateHandler {
  static FirmwareUpdateHandler? _instance;

  FirmwareUpdateHandler._internal() {
    _instance = this;
  }

  factory FirmwareUpdateHandler() => _instance ?? FirmwareUpdateHandler._internal();

  final _downloadProgress = 0.obs;
  String _downloadUrl = "";
  double _firmwareLatestVersion = 1.21;

  Future<bool> hasNewVersion() async {
    String url =
        "https://gz-wislide-dev-1320069029.cos.ap-guangzhou.myqcloud.com/test/ota/profile.txt";
    if (EnvConfig.env == Env.prod) {
      url = "https://gz-wislide-1320069029.cos.ap-guangzhou.myqcloud.com/prod/ota/profile.txt";
    } else if (EnvConfig.env == Env.ggprod) {
      url =
          "https://gg-wislide-1320069029.cos.na-siliconvalley.myqcloud.com/ggprod/ota/profile.txt";
    }

    try {
      final res = await DioUtil().request(url);
      Map<String, dynamic> data = jsonDecode(res);
      _firmwareLatestVersion = data["version"];
      _downloadUrl = data["url"];
      LogUtil.d("云端固件最新版本号：$_firmwareLatestVersion");
      return double.parse(FindDeviceHandler().deviceInfoModel.softwareVersion) <
          _firmwareLatestVersion;
    } catch (e) {
      LogUtil.d(e);
    }
    return false;
  }

  void showUpdateDialog() {
    DialogUtils.showAlert(
      title: S.FirmwareUpgrade,
      content: '${S.Upgradefirmwareto.tr}V${_firmwareLatestVersion.toStringAsFixed(2)}',
      afterTapDismiss: false,
      onTapRight: () async {
        Get.back();
        try {
          await _updateFirmWare();
        } catch (e) {
          Fluttertoast.showToast(msg: e.toString());
        }
      },
    );
  }

  /// 点击更新
  Future<void> _updateFirmWare() async {
    // 检测本地是否包含最新版本的固件，如果没有则进入下载流程，如果有直接进入升级流程
    // 1.检测本地是否有ota目录
    Directory applicationDir = await getTemporaryDirectory();
    String otaFolder =
        '${applicationDir.path}${Platform.pathSeparator}wiSlide${Platform.pathSeparator}ota';
    bool isDirExist = await Directory(otaFolder).exists();
    if (!isDirExist) Directory(applicationDir.path).create();
    // 2.检测本地是否有最新包
    final filePath =
        "$otaFolder${Platform.pathSeparator}OTA_v${_firmwareLatestVersion}_Klotski.zip";
    File file = File(filePath);
    if (file.existsSync()) {
      // 3.存在，直接升级
      await _startDfu(filePath);
    } else {
      // 4.不存在，进入下载流程
      _downloadOtaFile(filePath, autoUpdate: true);
    }
  }

  void _downloadOtaFile(String filePath, {bool autoUpdate = false}) async {
    if (_downloadUrl.isEmpty) return;
    Get.dialog(
      Obx(() => DialogUtils.progress(title: S.Downloading.tr, progress: _downloadProgress.value)),
      barrierDismissible: false,
    );
    try {
      await Dio().download(
        _downloadUrl,
        filePath,
        onReceiveProgress: (count, total) async {
          _downloadProgress.value = (count / total * 100).round();
          if (count == total && Get.isDialogOpen!) {
            Get.back();
            Fluttertoast.showToast(msg: S.Downloaded.tr);
            DeviceDfuUtil().saveOtaFilePath(filePath);
            if (autoUpdate) {
              _startDfu(filePath);
            }
          }
        },
      );
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
    }
  }

  Future<void> _startDfu(String? filePath) async {
    try {
      await DeviceDfuUtil().handle();
      await DeviceDfuUtil().doDfu(filePath: filePath);
    } catch (e) {
      LogUtil.d("startDfu --------------------- e");
    }
  }
}
