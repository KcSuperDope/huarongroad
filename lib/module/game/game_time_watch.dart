import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:huaroad/util/time_util.dart';

class MyStopWatch {
  Timer? _timer;
  final _stopwatch = Stopwatch();
  int? maxTime;

  int get elapsedMilliseconds => _stopwatch.elapsedMilliseconds;
  final timerString = "00:00:00".obs;

  VoidCallback? onTimeOut;

  void reset() {
    _stopwatch.reset();
    _timer?.cancel();
    _timer = null;
    timerString.value = "00:00:00";
  }

  void start() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      int s = _stopwatch.elapsedMilliseconds;
      timerString.value = TimeUtil.transformMilliSeconds(s);
      if (maxTime != null && s >= maxTime!) {
        timer.cancel();
        onTimeOut != null ? onTimeOut!() : () {};
      }
    });
    _stopwatch.start();
  }

  void stop() {
    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;
  }
}
