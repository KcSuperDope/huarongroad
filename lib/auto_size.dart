import 'dart:core';

import 'package:flutter/material.dart';

class AutoSize {
  /// 屏幕宽高
  static double screenWidth = 0;
  static double screenHeight = 0;

  /// 设计宽度，默认 375dp
  static double designWidth = 375;

  /// 当屏幕宽度 < 设计宽度的时候，需要按比例缩小
  /// 当屏幕宽度 >= 设计宽度时，不缩放
  static double scaleRate = 1;

  /// 屏幕宽高，像素
  static double screenWidthPx = 0;
  static double screenHeightPx = 0;

  static init({double designWidth = 375}) {
    MediaQueryData queryData = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first);
    Size size = queryData.size;

    screenWidth = size.width;
    AutoSize.designWidth = designWidth;

    if (screenWidth < designWidth) {
      scaleRate = screenWidth / designWidth;
    }

    screenHeight = size.height;

    screenWidthPx = size.width * queryData.devicePixelRatio;
    screenHeightPx = size.height * queryData.devicePixelRatio;
  }
}

extension AutoSizeExt on num {
  /// 自动适配，小屏缩放，大屏不变
  dynamic get a => this * AutoSize.scaleRate;

  /// 缩放
  dynamic get s => this * AutoSize.screenWidth / AutoSize.designWidth;
}

extension NumToDir on int {
  String get dir => getDir();

  String getDir() {
    String dir = "R";
    if (this == 0) {
      dir = "U";
    } else if (this == 1) {
      dir = "D";
    } else if (this == 2) {
      dir = "L";
    } else if (this == 3) {
      dir = "R";
    }
    return dir;
  }
}
