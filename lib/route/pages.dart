import 'package:get/get.dart';
import 'package:huaroad/module/appliction/application_page.dart';
import 'package:huaroad/module/code_scan/code_scan_page.dart';
import 'package:huaroad/module/custom_game/custom_game_page.dart';
import 'package:huaroad/module/device_info/device_info.dart';
import 'package:huaroad/module/find_device/find_devices.dart';
import 'package:huaroad/module/game_teach/game_teach_page.dart';
import 'package:huaroad/module/home/free_page.dart';
import 'package:huaroad/module/level/level_game/level_game_page.dart';
import 'package:huaroad/module/level/level_num_page.dart';
import 'package:huaroad/module/level/level_page.dart';
import 'package:huaroad/module/mine/mine_page.dart';
import 'package:huaroad/module/rank/battle/rank_vs_page.dart';
import 'package:huaroad/module/rank/match/rank_match_page.dart';
import 'package:huaroad/module/rank/report/rank_report_page.dart';
import 'package:huaroad/module/record/record_page.dart';
import 'package:huaroad/module/record/record_replay_page.dart';
import 'package:huaroad/module/special_game/special_game_page.dart';
import 'package:huaroad/module/special_game/special_page.dart';
import 'package:huaroad/module/top_list/top_list_page.dart';
import 'package:huaroad/route/routes.dart';

abstract class AppPages {
  static List<GetPage> pages = [
    GetPage(name: Routes.application_page, page: () => ApplicationPage()),
    GetPage(name: Routes.home_page, page: () => FreePage()),
    GetPage(name: Routes.mine_page, page: () => MinePage()),
    GetPage(name: Routes.level_page, page: () => LevelPage()),
    GetPage(name: Routes.level_num_page, page: () => LevelNumPage()),
    GetPage(name: Routes.device_info_page, page: () => DeviceInfoPage()),
    GetPage(name: Routes.device_sync_page, page: () => CustomGamePage()),
    GetPage(name: Routes.level_game_page, page: () => LevelGamePage()),
    GetPage(name: Routes.qr_scan_page, page: () => const QRScanPage()),
    GetPage(name: Routes.find_device_page, page: () => FindDevicesPage()),
    GetPage(
      name: Routes.rank_matching_page,
      page: () => const RankMatchPage(),
      binding: RankMatchBinding(),
    ),
    GetPage(
      name: Routes.rank_report_page,
      page: () => const RankReportPage(),
      binding: RankReportBinding(),
    ),
    GetPage(
      name: Routes.rank_vs_page,
      page: () => const RankVsPage(),
      binding: RankVsBinding(),
    ),
    GetPage(name: Routes.special_page, page: () => SpecialPage()),
    GetPage(name: Routes.special_game_page, page: () => SpecialGamePage()),
    GetPage(name: Routes.record_page, page: () => RecordPage()),
    GetPage(name: Routes.record_replay_page, page: () => RecordReplayPage()),
    GetPage(name: Routes.top_list_page, page: () => TopListPage()),
    GetPage(name: Routes.game_desc_page, page: () => GameTeachPage()),
  ];
}
