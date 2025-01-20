import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';

class SpecialGameData {
  static final openings = [
    "14413441311131133003",
    "04403443322311111111",
    "34403440111122221111",
    "14411441222222220220",
    "04401441133133333113",
    "44034413122113311330",
    "34433443322331131001",
    "44334433311031102222",
    "30103313133344314422",
  ];

  static final names = [
    S.Puttingoneselfinsomeoneelsesshoes,
    S.ThreeHeroesSwearBrotherhoodInThePeachGarden,
    S.FuXisEightTrigramsWaterKanTrigram,
    S.PassFiveLevels,
    S.Domineeringandtyrannical,
    S.TheThreeBrothersFightAgainstLuBu,
    S.Drawingaswordandmountingahorse,
    S.LiuBeiPaysThreeVisitsToZhugeLiangscottage,
    S.Settingfiretotheconnectedcamps,
  ];

  static List<SpecialListItem> list = [
    SpecialListItem(opening: openings[0], title: names[0], hard: 2, showNewHand: true),
    SpecialListItem(opening: openings[1], title: names[1], hard: 3, showNewHand: true),
    SpecialListItem(opening: openings[2], title: names[2], hard: 4, showNewHand: true),
    SpecialListItem(opening: openings[3], title: names[3], hard: 5, showMiddle: true),
    SpecialListItem(opening: openings[4], title: names[4], hard: 6, showMiddle: true),
    SpecialListItem(opening: openings[5], title: names[5], hard: 8, showMiddle: true),
    SpecialListItem(opening: openings[6], title: names[6], hard: 11, showHigh: true),
    SpecialListItem(opening: openings[7], title: names[7], hard: 13, showHigh: true),
    SpecialListItem(opening: openings[8], title: names[8], hard: 11, showHigh: true),
  ];
}

class SpecialListItem {
  String? title;
  String? opening;
  bool? showNewHand;
  bool? showMiddle;
  bool? showHigh;
  bool? showNewRecord;
  final scoreTime = (-1).obs;
  final scoreStepLength = (-1).obs;
  int? hard;

  SpecialListItem({
    this.title,
    this.opening,
    this.showNewHand,
    this.showNewRecord,
    this.showMiddle,
    this.showHigh,
    this.hard,
  });
}
