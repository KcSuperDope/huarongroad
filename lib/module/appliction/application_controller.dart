import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/module/appliction/application_repository.dart';
import 'package:huaroad/module/device_info/device_info_model.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/rank/match/battle_invite_model.dart';
import 'package:huaroad/plugin/model/header.dart';
import 'package:huaroad/plugin/model/report_event_model.dart';
import 'package:huaroad/plugin/model/user.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/util/dialog_util.dart';
import 'package:huaroad/util/eventbus_utils.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ApplicationController extends GetxController
    with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController tabController;
  final items = <List<ApplicationItem>>[].obs;
  final tabs = <String>[].obs;
  final guideEntryTypes = <GameType>[].obs;
  final banners = <BannerModel>[].obs;
  final currentTab = "".obs;
  var isShow = false.obs;
  List<Locale> languages = [
    const Locale('zh', 'CN'),
    const Locale('en', 'US'),
    const Locale('hk', 'HK'),
    const Locale('ja', 'JP'),
    const Locale('fr', 'FR'),
    const Locale('es', 'ES'),
    const Locale('de', 'DE'),
  ];
  var language = const Locale('en', 'US').obs;
  StreamSubscription? _subscription;
  int _lastTabIndex = -1;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    NativeFlutterPlugin.instance.initChannel();

    initData();

    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      if (tabs.isEmpty || currentTab.value == tabs[tabController.index]) return;
      currentTab.value = tabs[tabController.index];
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isShow.value = true;
    });

    _subscription = eventBus.on<AppTabbarIndexChangeEvent>().listen((event) async {
      if (_lastTabIndex != 0 && event.index == 0) banners.value = await ApplicationRepo.getBanner();
      _lastTabIndex = event.index;
    });

    try {
      await NativeFlutterPlugin.instance.setEnvConfig();
      banners.value = await ApplicationRepo.getBanner();
    } catch (e) {
      banners.value = await ApplicationRepo.getBanner();
    }
  }

  void initData() async {
    // Global.setUserInfo = User(
    //   userId: '1746805599867375616',
    //   token:
    //       '81xIOdaopX23memNlcqrpjT0+wSRMI5oucqMEAeHaAr7qTxGCCK80WtB5Y3wNmYj/Cd9IpQNjGwFM2Hs8OI0FQ==',
    //   mainId: 'u_1746805599867375616',
    //   nickName: 'Coco',
    //   // avatar:
    //   //     "https:\/\/cube-gz-1257291114.cos.ap-guangzhou.myqcloud.com\/test\/user-center\/avatar\/1705305919173iIsQl.png"
    // );
    // Header header = Global.header;
    // header.token = Global.getUserInfo()?.token ?? '';
    // Global.setHeader = header;
    tabs.value = [S.Klotski, S.NumberPuzzle];

    guideEntryTypes.value = [GameType.hrd, GameType.number3x3];

    currentTab.value = tabs.first;

    items.value = [
      [
        ApplicationItem(
            title: S.Classic,
            slogan: S.FamousGameSlogan,
            onTap: () {
              NativeFlutterPlugin.instance.updateUserInfo();
              Get.toNamed(Routes.special_page);
              reportEvent(1);
            },
            bg: "lib/assets/png/module_gif_special.gif",
            color: const Color(0xffB1E6FF)),
        ApplicationItem(
            title: S.Practice,
            slogan: S.FreeGameSlogan,
            onTap: () {
              NativeFlutterPlugin.instance.updateUserInfo();
              Get.toNamed(Routes.home_page, arguments: GameType.hrd);
              reportEvent(2);
            },
            bg: "lib/assets/png/module_gif_free.gif",
            color: const Color(0xffB5EF77)),
        ApplicationItem(
            title: S.Stages,
            slogan: S.LevelGameSlogan,
            onTap: () {
              NativeFlutterPlugin.instance.updateUserInfo();
              Get.toNamed(Routes.level_page, arguments: GameType.hrd);
              reportEvent(3);
            },
            bg: "lib/assets/png/module_gif_level.gif",
            color: const Color(0xffD7ED53)),
        ApplicationItem(
            title: S.VS,
            slogan: S.RankGameSlogan,
            onTap: () {
              reportEvent(4);
              NativeFlutterPlugin.instance.updateUserInfo();
              Get.toNamed(Routes.rank_matching_page, arguments: BattleInviteModel(type: 1));
            },
            bg: "lib/assets/png/module_gif_vs.gif",
            color: const Color(0xffFAC0C0)),
      ],
      [
        ApplicationItem(
            title: S.Practice,
            slogan: S.FreeGameSlogan,
            onTap: () {
              NativeFlutterPlugin.instance.updateUserInfo();
              Get.toNamed(Routes.home_page, arguments: GameType.number3x3);
              reportEvent(5);
            },
            bg: "lib/assets/png/module_gif_free.gif",
            color: const Color(0xffB5EF77)),
        ApplicationItem(
            title: S.stage3x3,
            slogan: S.LevelNumGameSlogan,
            onTap: () {
              NativeFlutterPlugin.instance.updateUserInfo();
              Get.toNamed(Routes.level_num_page, arguments: GameType.number3x3);
              reportEvent(6);
            },
            bg: "lib/assets/png/module_gif_level_num3.gif",
            color: const Color(0xffB1E6FF)),
        ApplicationItem(
            title: S.stage4x4,
            slogan: S.LevelNumGameSlogan,
            onTap: () {
              NativeFlutterPlugin.instance.updateUserInfo();
              Get.toNamed(Routes.level_num_page, arguments: GameType.number4x4);
              reportEvent(7);
            },
            bg: "lib/assets/png/module_gif_level_num4.gif",
            color: const Color(0xffB1E6FF)),
        ApplicationItem(
            title: S.VS,
            slogan: S.RankGameSlogan,
            onTap: () {
              reportEvent(8);
              NativeFlutterPlugin.instance.updateUserInfo();
              Get.toNamed(Routes.rank_matching_page, arguments: BattleInviteModel(type: 2));
            },
            bg: "lib/assets/png/module_gif_vs_num.gif",
            color: const Color(0xffFAC0C0)),
      ],
    ];
  }

  void onTapDisconnect() {
    DialogUtils.showAlert(
      title: S.Disconnect,
      content: S.Disconnectdevice,
      showClose: false,
      afterTapDismiss: false,
      onTapRight: () async {
        Get.back();
        disConnect();
      },
    );
  }

  void disConnect() async {
    DeviceInfoModel infoModel = FindDeviceHandler().deviceInfoModel;
    if (infoModel.device != null) {
      await infoModel.device!.disconnect();
    }
  }

  void onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 0) {
      NativeFlutterPlugin.instance.hiddenTabBar(true);
    } else {
      NativeFlutterPlugin.instance.hiddenTabBar(false);
    }
  }

  ///页面交互数据埋点
  void reportEvent(int interactionId) {
    PageInteractionEvent pageInteractionEvent =
        PageInteractionEvent(pageId: 1, interactionId: interactionId);
    ReportEventModel reportEventModel = ReportEventModel(
        eventId: EventId.pageInteraction, pageInteractionEvent: pageInteractionEvent);
    NativeFlutterPlugin.instance.reportEvent(reportEventModel);
  }
}

class ApplicationItem {
  final String title;
  final String slogan;
  final VoidCallback onTap;
  final String bg;
  final Color color;

  ApplicationItem({
    required this.title,
    required this.slogan,
    required this.onTap,
    required this.bg,
    required this.color,
  });
}
