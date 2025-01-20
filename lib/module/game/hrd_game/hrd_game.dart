import 'dart:async';

import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_solution.dart';
import 'package:huaroad/module/game/game_to_data.dart';
import 'package:huaroad/module/game/hrd_game/board.dart';

// 游戏类，生成棋盘，以及一些操作
class HrdGame extends Game with DbJson {
  HrdBoard board = HrdBoard(); // 棋盘

  /// 求解(步骤 + 棋盘)
  @override
  Future getSolutionModel() async {
    Completer completer = Completer();
    GameSolution().compute(
      currentBoardString: getCurrentMatrixString(),
      currentBoardMatrix: getCurrentMatrix(),
      gameType: GameType.hrd,
    );
    GameSolution().onComplete = (data) => completer.complete(data);
    return completer.future;
  }

  @override
  bool win() {
    for (var piece in pieceList) {
      if (piece.kind == 4 && piece.dx! == 1 && piece.dy! == 3) {
        return true;
      }
    }
    return false;
  }

  @override
  void reset() {
    List<int> list = [];
    opening.split("").forEach((element) {
      list.add(int.parse(element));
    });
    board = HrdBoard.createBoard(list);
    super.reset();
  }

  /// 指定游戏
  HrdGame.fromData(String data) {
    rowNum = 5;
    colNum = 4;
    List<int> list = [];
    data.split("").forEach((element) {
      list.add(int.parse(element));
    });
    board = HrdBoard.createBoard(list);
    openingList = list;
    openingMatrix = listToMatrix(list);
    opening = board.getBoardListString();
    type.value = GameType.hrd;
    super.init();
  }
}
