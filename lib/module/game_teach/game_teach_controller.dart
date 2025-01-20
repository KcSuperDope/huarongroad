import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game_teach/game_teach_repository.dart';
import 'package:huaroad/net/env/env_config.dart';

class GameTeachController extends GetxController with GetTickerProviderStateMixin, WidgetsBindingObserver {
  GameType gameType = Get.arguments["type"];
  int hard = Get.arguments["hard"];
  bool notJumpSolution = Get.arguments["notJumpSolution"] ?? false;

  late TabController tabController;
  late TabController subTabController;

  List<String> tabs = [];
  List<String> subTabs = [];

  final currentTab = "".obs;
  final currentSubTab = "".obs;

  // List<Locale> languages = [
  //   const Locale('zh', 'CN'),
  //   const Locale('en', 'US'),
  //   const Locale('hk', 'HK'),
  //   const Locale('ja', 'JP'),
  //   const Locale('fr', 'FR'),
  //   const Locale('es', 'ES'),
  //   const Locale('de', 'DE'),
  // ];
  // var language = const Locale('en', 'US').obs;

  @override
  void onInit() async {
    super.onInit();

    tabs = [S.Basicinstructions, S.Solutionapproach];
    if (EnvConfig.env == Env.ggprod) tabs.removeLast();
    currentTab.value = tabs.first;
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      if (tabs.isEmpty || currentTab.value == tabs[tabController.index]) return;
      currentTab.value = tabs[tabController.index];
    });

    final numTitleList = ["3x3", "4x4"];
    subTabs = gameType == GameType.hrd
        ? List.generate(13, (index) => "难度${index + 1}").toList()
        : List.generate(2, (index) => numTitleList[index]).toList();
    currentSubTab.value = subTabs.first;
    subTabController = TabController(length: subTabs.length, vsync: this);
    subTabController.addListener(() {
      if (subTabs.isEmpty || currentSubTab.value == subTabs[subTabController.index]) return;
      currentSubTab.value = subTabs[subTabController.index];
    });

    await GameTeachRepo().getData(gameType);

    if (notJumpSolution) return;

    tabController.animateTo(1);
    subTabController.animateTo(min(hard - 1, 12));
  }
}
