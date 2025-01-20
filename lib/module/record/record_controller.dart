import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_record.dart';
import 'package:huaroad/module/rank/report/rank_report_model.dart';
import 'package:huaroad/module/record/record_model.dart';
import 'package:huaroad/module/record/record_replay_page.dart';
import 'package:huaroad/route/routes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RecordController extends GetxController {
  final gameMode = Get.arguments["mode"];
  final gameType = Get.arguments["type"];
  final dataList = <RecordModel>[].obs;
  final isLoadingError = false.obs;
  final isEmptyData = false.obs;
  final refreshController = RefreshController();
  int pageIndex = 0;
  int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshController.requestRefresh(duration: const Duration(milliseconds: 200));
    });
  }

  Future<void> query({bool isRefresh = false}) async {
    try {
      isLoadingError.value = false;
      isEmptyData.value = false;
      if (isRefresh) dataList.clear();
      final list = await GameRecordTool().getRecordList(gameType: gameType, gameMode: gameMode, pageIndex: pageIndex);
      if (list.isNotEmpty) {
        for (var element in list) {
          dataList.add(RecordModel.fromJson(data: element, gameMode: gameMode, gameType: gameType));
        }
      }
      if (!isRefresh) {
        if (list.length < pageSize) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
      } else {
        refreshController.refreshCompleted(resetFooterState: list.length < pageSize);
        isEmptyData.value = dataList.isEmpty;
      }
    } catch (e) {
      isLoadingError.value = true;
    }
  }

  void onRefresh() async {
    pageIndex = 1;
    await query(isRefresh: true);
  }

  void onLoadMore() async {
    pageIndex++;
    await query();
  }

  void toRecordDetail(RecordModel item) {
    if (gameMode == GameMode.rank) {
      RankReportModel model = RankReportModel();
      model.redResult = item.redResult;
      model.blueResult = item.blueResult;
      model.owner = false;
      model.finishTime = item.startTime! * 1000;
      model.opening = item.opening;
      model.gameType = item.gameType;
      Get.toNamed(Routes.rank_report_page, arguments: model);
    } else {
      if (item.result == 1) return;
      Get.to(() => RecordReplayPage(), arguments: item);
    }
  }

  String getTitle() {
    switch (gameMode) {
      case GameMode.freedom:
        return S.Practicerecord;
      case GameMode.famous:
        return S.recordofClassic;
      case GameMode.level:
        return S.stagerecords;
      case GameMode.rank:
        return S.vsrecords;
      default:
        return 'records';
    }
  }
}
