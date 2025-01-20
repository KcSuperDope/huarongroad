import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game_teach/game_solution_card.dart';
import 'package:huaroad/net/env/env_config.dart';

class GameTeachRepo {
  static GameTeachRepo? _instance;

  GameTeachRepo._internal() {
    _instance = this;
  }

  factory GameTeachRepo() => _instance ?? GameTeachRepo._internal();

  List<GameDescSectionModel> sections = [];

  final _hrdGroupId1 = {'zh': '67', 'hk': '68', 'en': '69', 'es': '70', 'fr': '71', 'de': '72', 'jr': '73'};
  final _hrdGroupId2 = {'zh': '53', 'hk': '54', 'en': '55', 'es': '56', 'fr': '57', 'de': '58', 'jr': '59'};
  final _hrdGroupId3 = {'zh': '60', 'hk': '61', 'en': '62', 'es': '63', 'fr': '64', 'de': '65', 'jr': '66'};
  final _numGroupId1 = {'zh': '74', 'hk': '75', 'en': '76', 'es': '77', 'fr': '78', 'de': '79', 'jr': '80'};

  final solutionSections = <List<GameSolutionInfoModel>>[].obs;

  GameType currentGameType = GameType.hrd;

  late Map<String, dynamic> totalData;

  final topOrBottom = 0.obs;

  final testDomain = "https://gz-wislide-dev-1320069029.cos.ap-guangzhou.myqcloud.com/";
  final prodDomain = "https://gz-wislide-1320069029.cos.ap-guangzhou.myqcloud.com/prod/";

  String get solImageUrl =>
      "${EnvConfig.env == Env.prod ? prodDomain : testDomain}solution_images/${currentGameType == GameType.hrd ? "hrd" : "num"}/";

  Future<void> getData(GameType gameType) async {
    currentGameType = gameType;
    getSectionData(gameType);
    await getSolutionData(gameType);
  }

  Future<void> getSolutionData(GameType gameType) async {
    solutionSections.clear();
    String contents = await rootBundle.loadString('lib/assets/game_solution_data.json');
    totalData = jsonDecode(contents);
    List<List<GameSolutionInfoModel>> res = [];
    final key = gameType == GameType.hrd ? "hrd" : "num";
    final list = totalData[key] as List;
    for (var element in list) {
      List<GameSolutionInfoModel> list = [];
      for (var data in element) {
        list.add(GameSolutionInfoModel.fromJson(data));
      }
      res.add(list);
      solutionSections.value = res;
    }
  }

  void buttonTop(BuildContext context) {
    topOrBottom.value = 1;
    final list = solutionSections[7];
    if (list.length > 2) list.removeRange(2, list.length);
    final topList = totalData["buttonTop"] as List;
    for (var element in topList) {
      list.add(GameSolutionInfoModel.fromJson(element));
    }
    context.findAncestorStateOfType<GameSolutionCardState>()?.update(list);
  }

  void buttonBottom(BuildContext context) {
    topOrBottom.value = 2;
    final list = solutionSections[7];
    if (list.length > 2) list.removeRange(2, list.length);
    final bottomList = totalData["buttonBottom"] as List;
    for (var element in bottomList) {
      list.add(GameSolutionInfoModel.fromJson(element));
    }
    context.findAncestorStateOfType<GameSolutionCardState>()?.update(list);
  }

  void getSectionData(GameType gameType) {
    final suffix = gameType == GameType.hrd ? "" : "Num";
    sections.clear();
    sections.add(GameDescSectionModel(
      title: S.Rules,
      imagePath: "lib/assets/png/1.0.5/game_teach_${gameType == GameType.hrd ? 'hrd' : 'num'}.gif",
      smallSections: {'': S.RulesDetail + suffix},
    ));
    sections.add(GameDescSectionModel(title: S.HowtoPlay, smallSections: {'': S.HowtoPlayDetail + suffix}));
    sections.add(GameDescSectionModel(title: S.Modes, smallSections: {'': S.ModesDetail + suffix}));
    sections.add(GameDescSectionModel(title: S.Results, smallSections: {'': S.ResultsDetail + suffix}));
    sections.add(GameDescSectionModel(
      title: S.CommonTerminology,
      smallSections: {'': S.CommonTerminologyDetail + suffix},
    ));

    final currentLCode = Get.locale?.languageCode;
    final hrdGroupId1 = EnvConfig.env == Env.ggprod ? _hrdGroupId1[currentLCode] : '51';
    final hrdGroupId2 = EnvConfig.env == Env.ggprod ? _hrdGroupId2[currentLCode] : '49';
    final hrdGroupId3 = EnvConfig.env == Env.ggprod ? _hrdGroupId3[currentLCode] : '50';
    final numGroupId1 = EnvConfig.env == Env.ggprod ? _numGroupId1[currentLCode] : '52';

    Map<String, String> smallSection = {numGroupId1!: S.SharingandLearningDetail + suffix};

    if (gameType == GameType.hrd) {
      smallSection = {
        hrdGroupId1!: S.SharingandLearningDetail + suffix,
        hrdGroupId2!: S.SharingandLearningDetail2 + suffix,
        hrdGroupId3!: S.SharingandLearningDetail3 + suffix,
      };
    } else {
      smallSection = {numGroupId1: S.SharingandLearningDetail + suffix};
    }

    sections.add(GameDescSectionModel(title: S.SharingandLearning, smallSections: smallSection));

    if (EnvConfig.env != Env.ggprod) {
      sections.add(GameDescSectionModel(
          title: S.ContactUs,
          imagePath: 'lib/assets/png/1.0.5/contact_us_qr_code.png',
          smallSections: {'': S.ContactUsDetail}));
    }
  }
}

// 内容类型，单图，多图，按钮，轮播
enum GameSolutionInfoType { image, images, button, cycle }

class GameSolutionInfoModel {
  String? title;
  String? contentText;
  String? bottomText;
  List<dynamic>? images;
  List<dynamic>? cycleData;
  GameSolutionInfoType? type = GameSolutionInfoType.image;

  GameSolutionInfoModel.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    contentText = json["contentText"];
    bottomText = json["bottomText"];
    if (json["images"] != null) images = json["images"];
    if (json["cycleData"] != null) cycleData = json["cycleData"];
    if (json["type"] != null) type = GameSolutionInfoType.values[json["type"]];
  }
}

class GameDescSectionModel {
  String? title;
  String? imagePath;
  Map<String, String> smallSections;

  GameDescSectionModel({this.title, this.imagePath, required this.smallSections});
}
