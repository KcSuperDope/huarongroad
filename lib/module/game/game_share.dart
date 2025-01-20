import 'dart:io';
import 'dart:ui' as ui show Image, ImageByteFormat;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/util/logger.dart';
import 'package:path_provider/path_provider.dart';

// 1. 经典名局—— 名称结构为：经典名局+ “棋局名称”
// 2. 个人练习—— 名称结构为：个人练习+ “具体难度”
// 3. 闯关挑战—— 名称结构为：闯关挑战+ “具体关卡”
// 4. 双人对战—— 名称结构为：双人对战+ “具体难度”

class GameShare {
  static GlobalKey shareBoardKey = GlobalKey();

  static Future<Map<String, dynamic>> getShareData(Game game) async {
    Map<String, dynamic> data = {};
    String name = S.shareGame.tr;
    if (game.mode.value == GameMode.freedom) {
      name = "${S.Practice.tr} ${S.Stage.tr}${game.id}";
    } else if (game.mode.value == GameMode.level) {
      name = "${S.Stages.tr} ${S.Lv.trArgs([game.index.toString()])}";
    } else if (game.mode.value == GameMode.rank) {
      name = "${S.VS.tr} ${S.Stage.tr}${game.id}";
    } else if (game.mode.value == GameMode.famous) {
      name = "${S.Classic.tr} ${game.title.value.tr}";
    }

    try {
      if (game.uploadState == GameUploadState.uploading) {
        Fluttertoast.showToast(msg: S.UploadingPleaseWait.tr);
        throw FlutterError(S.UploadingPleaseWait.tr);
      }

      if (game.uploadState == GameUploadState.uploadFail) {
        try {
          await game.upload(retry: true);
        } catch (e) {
          Fluttertoast.showToast(msg: e.toString());
          rethrow;
        }
      }

      data = {
        "title": name,
        "time": game.getTotalTime(),
        "step": game.history.totalCount.value,
        "cover": game.openingBoardFilepath.isNotEmpty ? game.openingBoardFilepath : await captureImage(),
        "start_time": game.startTime,
        "opening": game.opening,
        "review_id": game.reviewId,
        "game_id": game.id,
        "game_mode": game.mode.value.index,
        "game_type": game.type.value.index,
      };
      return data;
    } catch (e) {
      rethrow;
    }
  }

  /// 截屏图片生成图片流ByteData
  static Future<String> captureImage() async {
    RenderRepaintBoundary boundary = shareBoardKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    MediaQueryData queryData = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first);
    var dpr = queryData.devicePixelRatio;
    var image = await boundary.toImage(pixelRatio: dpr);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    var filePath = "";
    // 获取手机存储（getTemporaryDirectory临时存储路径）
    Directory applicationDir = await getTemporaryDirectory();
    // 判断路径是否存在
    bool isDirExist = await Directory(applicationDir.path).exists();
    if (!isDirExist) Directory(applicationDir.path).create();
    // 直接保存，返回的就是保存后的文件
    File saveFile = await File("${applicationDir.path}${DateTime.now().toIso8601String()}.png").writeAsBytes(pngBytes);
    filePath = saveFile.path;
    LogUtil.d(saveFile.path);
    return filePath;
  }
}
