import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:huaroad/assets/game_data/game_opening_v2_code.dart';
import 'package:huaroad/assets/game_data/level_num_data.dart';
import 'package:huaroad/assets/game_data/level_openning_data.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_engine.dart';
import 'package:huaroad/module/game/game_my_step.dart';
import 'package:huaroad/module/game/game_teach_model.dart';
import 'package:huaroad/module/game/game_transform.dart';
import 'package:huaroad/module/game/hrd_game/hrd_game.dart';
import 'package:huaroad/module/game/num_game/num_game.dart';
import 'package:huaroad/module/piece/piece_handler.dart';
import 'package:huaroad/util/logger.dart';
import 'package:path_provider/path_provider.dart';

class TestPage extends StatelessWidget {
  TestPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> gameList = [];
  final tempList = <String>[];

  final List<String> gameList1 = [];
  final List<String> gameList2 = [];
  final List<String> gameList3 = [];
  final List<String> gameList4 = [];
  final List<String> gameList5 = [];

  final List<String> numList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("游戏"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SoundGestureDetector(
              onTap: () => trans(),
              child: Container(
                width: 150,
                height: 150,
                color: Colors.blue,
                alignment: Alignment.center,
                child: const Text(
                  "trans",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SoundGestureDetector(
              onTap: () => generateHrd(),
              child: Container(
                width: 150,
                height: 150,
                color: Colors.blue,
                alignment: Alignment.center,
                child: const Text(
                  "generate hrd",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SoundGestureDetector(
              onTap: () => createNum(),
              child: Container(
                width: 150,
                height: 150,
                color: Colors.blue,
                alignment: Alignment.center,
                child: const Text(
                  "create num",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SoundGestureDetector(
              onTap: () => generateNum(),
              child: Container(
                width: 150,
                height: 150,
                color: Colors.blue,
                alignment: Alignment.center,
                child: const Text(
                  "generate num",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SoundGestureDetector(
              onTap: () => write(),
              child: Container(
                width: 150,
                height: 150,
                color: Colors.blue,
                alignment: Alignment.center,
                child: const Text(
                  "write",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void createNum() {
    numList.clear();
    for (int i = 0; i < 1000; i++) {
      final res = GameEngine().generalInitMatrix(4, 4);
      numList.add(res);
    }

    final set = numList.toSet().toList();
    set.forEach((element) {
      print(element);
    });
  }

  void trans() {
    for (var element in GameOpeningV2Code.oneHundredTen) {
      GameTransform().codeToBoard(element);
    }
  }

  void generateNum() async {
    final list = LevelNumData.num4x4;
    GameType type = GameType.number4x4;
    gameList.clear();
    tempList.clear();
    for (int i = 0; i < list.length; i++) {
      final open = list[i];
      Map<String, dynamic> data = {};
      NumGame game = NumGame.fromData(open);
      game.type.value = type;
      game.pieceList.addAll(PieceHandler().createModelList(game.openingMatrix, game.type.value));
      final sol = game.getSolutionDirection();
      // if (sol.length < 10) {
      //   LogUtil.d("error");
      //   LogUtil.d(open);
      //   continue;
      // }
      data = {"open": open, "solution": sol, "length": sol.length};
      gameList.add(data);
      print("第 $i 局  length : ${sol.length}");
    }
    // gameList.sort((a, b) => a["length"].compareTo(b["length"]));
    gameList.forEach((element) {
      print("解法 ：${element["length"]}");
    });

    gameList.forEach((element) {
      print("棋局 ： ${element["open"]}");
    });
  }

  void generateHrd() async {
    final list = [];
    list.addAll(GameLevelOpening.data);
    list.addAll(GameLevelOpening.oneHundred.sublist(0, 220));
    list.addAll(GameLevelOpening.oneHundredTen.sublist(0, 500));
    gameList.clear();
    for (int i = 0; i < list.length; i++) {
      String open = list[i];
      Map<String, dynamic> data = {};
      HrdGame game = HrdGame.fromData(open);
      game.type.value = GameType.hrd;
      game.pieceList.value = PieceHandler().createModelList(game.openingMatrix, GameType.hrd);
      List<TeachModel> tms = await game.getSolutionModel();
      List<String> sol = [];
      if (tms.isEmpty) {
        LogUtil.d("error");
        continue;
      }
      for (var tm in tms) {
        sol.add(stepToString(tm.step));
      }

      data = {"open": open, "solution": sol, "length": tms.length};
      gameList.add(data);
      print("第 $i 局  length : ${sol.length}");
    }
  }

  void write() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final file = File("${appDocDir.path}/num4.json");
    print(file.path);
    // gameList.sort((a, b) => a["length"].compareTo(b["length"]));
    print(gameList);
    for (var element in gameList) {
      file.writeAsStringSync("${jsonEncode(element)},", mode: FileMode.append);
    }
  }

  // 0 上  1 下  2 左 3 右
  String stepToString(MyStep step) {
    String s = "${step.moves.first.x}${step.moves.first.y}";
    if (step.moves.first.toX == 0) {
      if (step.moves.first.toY == 1) {
        // 下
        s += "1";
      } else if (step.moves.first.toY == -1) {
        // 上
        s += "0";
      }
    }
    if (step.moves.first.toY == 0) {
      if (step.moves.first.toX == 1) {
        // 右
        s += "3";
      } else if (step.moves.first.toX == -1) {
        // 左
        s += "2";
      }
    }
    return s;
  }
}
