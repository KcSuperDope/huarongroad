import 'package:get/get.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/module/top_list/top_list_model.dart';
import 'package:huaroad/module/top_list/top_list_repository.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/logger.dart';
import 'package:super_tooltip/super_tooltip.dart';

class TopListController extends GetxController {
  final gameMode = Get.arguments["mode"];
  final gameType = Get.arguments["type"];
  final gameId = Get.arguments["id"];
  final gameName = Get.arguments["name"];
  final rankList = <TopListModel>[].obs;
  final myRank = TopListModel().obs;
  final isLoading = false.obs;
  final isLoadingError = false.obs;
  final seasonList = <SeasonModel>[].obs;
  final currentSeason = (SeasonModel(index: -1, title: "")).obs;
  final tipController = SuperTooltipController();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() async {
    if (Global.getUserInfo() != null) {
      myRank.value.nickname = Global.getUserInfo()!.nickName;
      myRank.value.avatar = Global.getUserInfo()!.avatar;
      myRank.value.appUserId = Global.getUserInfo()!.userId;
    } else {
      myRank.value.nickname = "--";
      myRank.value.avatar = "";
      myRank.value.appUserId = "-1";
    }
    myRank.value.rank.value = 0;
    myRank.value.shadowColor = color_main;

    try {
      isLoading.value = true;
      isLoadingError.value = false;
      final list = await TopListRepository.getPeriod();
      isLoading.value = false;
      isLoadingError.value = false;
      if (list.isNotEmpty) {
        seasonList.clear();
        seasonList.addAll(list.reversed.toList());
        currentSeason.value = seasonList.first;

        final res = await TopListRepository.getTopList(currentSeason.value.index, gameId);
        List rankListData = res["rankList"];
        final myRankData = res["myRank"];
        rankList.clear();
        rankList.addAll(rankListData.map((e) => TopListModel.fromJson(e)).toList());
        if (myRankData != null) {
          myRank.value.rank.value = myRankData["rank"] ?? 0;
          myRank.value.step.value = myRankData["step"] ?? 0;
          myRank.value.duration.value = myRankData["duration"] ?? 0;
        }
      }
    } catch (e) {
      LogUtil.d(e);
      isLoading.value = false;
      isLoadingError.value = true;
    }
  }

  void queryFromSeason() async {
    try {
      isLoading.value = true;
      isLoadingError.value = false;
      final res = await TopListRepository.getTopList(currentSeason.value.index, gameId);
      List rankListData = res["rankList"];
      final myRankData = res["myRank"];
      rankList.clear();
      rankList.addAll(rankListData.map((e) => TopListModel.fromJson(e)).toList());
      if (myRankData != null) {
        myRank.value.rank.value = myRankData["rank"] ?? 0;
        myRank.value.step.value = myRankData["step"] ?? 0;
        myRank.value.duration.value = myRankData["duration"] ?? 0;
      }
      isLoading.value = false;
      isLoadingError.value = false;
    } catch (e) {
      LogUtil.d(e);
      isLoading.value = false;
      isLoadingError.value = true;
    }
  }

  void onTapBack() {
    Get.back();
  }
}
