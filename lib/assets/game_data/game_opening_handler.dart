import 'package:huaroad/assets/game_data/game_open_3*3.dart';
import 'package:huaroad/assets/game_data/game_open_4*4.dart';
import 'package:huaroad/assets/game_data/game_opening_v2.dart';
import 'package:huaroad/assets/game_data/level_openning_data.dart';
import 'package:huaroad/module/game/game.dart';

enum PageGame { home, level, challenge }

class GameOpeningHandler {
  static GameOpeningHandler? _instance;

  GameOpeningHandler._internal() {
    _instance = this;

    l1.addAll(GameOpeningV2.H3V0);
    l2.addAll(GameOpeningV2.H0V3);
    l3.addAll(GameOpeningV2.H2V1);
    l4.addAll(GameOpeningV2.H1V2);
    l5.addAll(GameOpeningV2.H4V0);
    l5.addAll(GameOpeningV2.H5V0);
    l6.addAll(GameOpeningV2.H0V4);
    l7.addAll(GameOpeningV2.H3V1);
    l8.addAll(GameOpeningV2.H1V3);
    l9.addAll(GameOpeningV2.H2V2);
    l10.addAll(GameOpeningV2.H4V1);
    l11.addAll(GameOpeningV2.H1V4);
    l12.addAll(GameOpeningV2.H3V2);
    l13.addAll(GameOpeningV2.H2V3);
    l14.addAll(GameLevelOpening.oneHundred);
    l14.addAll(GameLevelOpening.oneHundredTen);
  }

  factory GameOpeningHandler() => _instance ?? GameOpeningHandler._internal();

  /// 首页游戏数据
  final List<String> l1 = [];
  final List<String> l2 = [];
  final List<String> l3 = [];
  final List<String> l4 = [];
  final List<String> l5 = [];
  final List<String> l6 = [];
  final List<String> l7 = [];
  final List<String> l8 = [];
  final List<String> l9 = [];
  final List<String> l10 = [];
  final List<String> l11 = [];
  final List<String> l12 = [];
  final List<String> l13 = [];
  final List<String> l14 = [];

  List<String> getLevels(int hard, PageGame page, GameType type) {
    List<String> list = [];
    if (page == PageGame.home) {
      switch (hard) {
        case 1:
          return type == GameType.hrd ? l1 : OpenGame8.level1;
        case 2:
          return type == GameType.hrd ? l2 : OpenGame15.level1;
        case 3:
          return l3;
        case 4:
          return l4;
        case 5:
          return l5;
        case 6:
          return l6;
        case 7:
          return l7;
        case 8:
          return l8;
        case 9:
          return l9;
        case 10:
          return l10;
        case 11:
          return l11;
        case 12:
          return l12;
        case 13:
          return l13;
        case 14:
          return l14;
      }
    }
    return list;
  }
}
