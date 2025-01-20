import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_record.dart';
import 'package:huaroad/module/game/game_step.dart';
import 'package:huaroad/module/game/hrd_game/hrd_game.dart';
import 'package:huaroad/module/game/num_game/num_game.dart';
import 'package:huaroad/module/piece/piece_handler.dart';
import 'package:huaroad/module/record/record_model.dart';
import 'package:huaroad/util/logger.dart';
import 'package:huaroad/util/time_util.dart';
import 'package:reliable_interval_timer/reliable_interval_timer.dart';

class RecordReplayController extends GetxController {
  Game? game;
  RecordModel? recordModel;
  final isPlaying = false.obs;
  final currentIndex = 0.obs;
  final currentPieceMove = 0.obs;
  final totalPieceMove = 0;
  final timerString = "".obs;
  final sliderValue = 0.0.obs;
  late ReliableIntervalTimer timer;
  double ticks = 0.0;
  final videoSpeed = "1".obs;
  final videoSpeedList = ["2", "1", "0.5"].obs;
  final interval = 10;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      recordModel = Get.arguments;
      game = recordModel!.gameType == GameType.hrd
          ? HrdGame.fromData(recordModel!.opening!)
          : NumGame.fromData(recordModel!.opening!);
      game!.mode.value = recordModel!.gameMode!;
      game!.animationDuration.value = 80;
      game!.allowPlay.value = false;
      game!.totalTime = recordModel!.time!;
      game!.startTime = recordModel!.startTime!;
      timerString.value = TimeUtil.transformMilliSeconds(0);
    }

    getDetail();
    createTimer();
  }

  void createTimer() {
    timer = ReliableIntervalTimer(
        interval: Duration(milliseconds: interval),
        callback: (elapsedMilliseconds) async {
          if (currentIndex.value >= game!.history.steps.length) {
            LogUtil.d("步数超过最大值");
            stop();
            return;
          }

          if (isPlaying.value) {
            final currentStep = game!.history.steps[currentIndex.value];
            final time = currentStep.timestamp ~/ interval;
            final tickTime = ticks.round() ~/ interval;
            if (time == tickTime || time + 1 == tickTime || time - 1 == tickTime) {
              game!.playStep(currentStep);
              currentIndex.value++;
              currentPieceMove.value += currentStep.pieceMoveCount;
            }
            ticks = ticks + double.parse(videoSpeed.value) * interval;
            sliderValue.value = min(1.0, ticks / game!.totalTime);
            timerString.value = TimeUtil.transformMilliSeconds(min(ticks.round(), game!.totalTime));
          } else {
            stop();
          }
        });
  }

  void getDetail() async {
    try {
      final res = await GameRecordTool().getRecordDetail(reviewId: recordModel!.reviewId!) as Map<String, dynamic>;
      game!.history.generalStep(res["data"]);
    } catch (e) {
      LogUtil.d(e);
      Fluttertoast.showToast(msg: S.Networkissue.tr);
    }
  }

  void play() {
    final history = game!.history;
    final steps = history.steps;
    if (steps.isEmpty) {
      return;
    }

    isPlaying.value = !isPlaying.value;
    if (isPlaying.value) {
      if (currentIndex.value == history.steps.length) {
        currentIndex.value = 0;
        currentPieceMove.value = 0;
        game!.pieceList.value = PieceHandler().createModelList(game!.openingMatrix, game!.type.value);
        ticks = 0;
        createTimer();
      }
      timer.start();
    } else {
      stop();
    }
  }

  void stop() async {
    await timer.stop();
    isPlaying.value = false;
  }

  void nextStep() {
    isPlaying.value = false;
    if (currentIndex.value >= game!.history.steps.length) return;
    final index = currentIndex.value;
    final step = game!.history.steps[index];
    game!.playStep(step);
    updateValue(step);
    currentIndex.value = index + 1;
    currentPieceMove.value += step.pieceMoveCount;
  }

  void preStep() {
    isPlaying.value = false;
    if (currentIndex.value < 1) return;
    final index = currentIndex.value - 1;
    final step = game!.history.steps[index].inverse();
    game!.playStep(step);
    updateValue(step);
    currentIndex.value = index;
    currentPieceMove.value -= step.pieceMoveCount;
  }

  void updateValue(GameStep step) {
    sliderValue.value = min(1.0, step.timestamp / game!.totalTime);
    timerString.value = TimeUtil.transformMilliSeconds(step.timestamp);
    ticks = step.timestamp.toDouble();
  }

  void addVideoSpeed() {
    final index = videoSpeedList.indexOf(videoSpeed.value);
    if (index > 0) {
      videoSpeed.value = videoSpeedList[index - 1];
    }
  }

  void decreaseVideoSpeed() {
    final index = videoSpeedList.indexOf(videoSpeed.value);
    if (index < videoSpeedList.length - 1) {
      videoSpeed.value = videoSpeedList[index + 1];
    }
  }

  @override
  void onClose() {
    super.onClose();
    if (timer.isRunning) {
      timer.stop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (timer.isRunning) {
      timer.stop();
    }
  }
}
