import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:huaroad/module/game/game_step.dart';

class GameHistory {
  final List<GameStep> _steps = [];
  final totalCount = (0).obs;
  int maxStepCount = 1000;

  String get historyString => getHistoryString();

  List<GameStep> get steps => _steps;

  VoidCallback? onStepCountOut;

  bool _isNotCallStepOut = true;

  void clear() {
    _steps.clear();
    totalCount.value = 0;
    _isNotCallStepOut = true;
  }

  void add(GameStep step) {
    _steps.add(step);
    totalCount.value += step.pieceMoveCount;

    if (totalCount.value >= maxStepCount && _isNotCallStepOut) {
      if (onStepCountOut != null) {
        onStepCountOut!();
        _isNotCallStepOut = false;
      }
    }
    sort();
  }

  /// step -> json
  String getHistoryString() {
    final res = json.encode(steps.map((e) => e.toJson()).toList());
    return res;
  }

  void generalStep(String s) {
    if (s.isEmpty) return;
    final list = json.decode(s) as List;
    if (list.isEmpty) return;
    _steps.clear();
    for (var element in list) {
      final step = GameStep.fromJson(element);
      if (_steps.isNotEmpty) {
        final last = _steps.last;
        if (last.timestamp ~/ 10 == step.timestamp ~/ 10) {
          last.addPieceMoveInfo(info: step.pieceMoveInfo);
          last.pieceMoveCount += step.pieceMoveCount;
        } else {
          _steps.add(step);
        }
      } else {
        _steps.add(step);
      }
      totalCount.value += step.pieceMoveCount;
    }
  }

  void sort() {
    _steps.sort(((a, b) => a.timestamp.compareTo(b.timestamp)));
  }
}
