class GameStep {
  int index = 0;
  int timestamp = 0;
  int pieceMoveCount = 0;
  String pieceMoveInfo = "";
  String boardInfo = "";
  List<GamePieceMove> moves = [];

  void addPieceMoveInfo({required String info}) {
    pieceMoveInfo = info;
    final list = splitStep(info);
    if (list.isEmpty) return;
    for (var el in list) {
      GamePieceMove move = GamePieceMove();
      move.addMove(el);
      moves.add(move);
    }
  }

  List<String> splitStep(String input) {
    List<String> resultList = [];
    RegExp pattern = RegExp(r'\d+[A-Za-z]+');
    Iterable<Match> matches = pattern.allMatches(input);
    for (Match match in matches) {
      resultList.add(match.group(0)!);
    }
    return resultList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index; // 序号
    data['timestamp'] = timestamp; //时间戳
    data['pieceMoveCount'] = pieceMoveCount; //本次(index)棋子变化数量
    data['pieceMoveInfo'] = pieceMoveInfo; //本次(index)棋子移动信息
    data["boardString"] = boardInfo; //本次(index)棋盘状态
    return data;
  }

  static GameStep fromJson(Map<String, dynamic> data) {
    GameStep step = GameStep();
    step.index = data['index'];
    step.timestamp = data['timestamp']; //时间戳
    step.pieceMoveCount = data['pieceMoveCount']; //本次(index)棋子变化数量
    step.boardInfo = data["boardString"]; //本次(index)棋盘状态
    step.pieceMoveInfo = data["pieceMoveInfo"];
    step.addPieceMoveInfo(info: data['pieceMoveInfo']); //本次(index)棋子移动信息
    return step;
  }

  GameStep inverse() {
    GameStep step = GameStep();
    step.index = index;
    step.timestamp = timestamp;
    step.pieceMoveCount = pieceMoveCount;
    step.boardInfo = boardInfo;
    step.addPieceMoveInfo(info: inverseInfo(pieceMoveInfo));
    return step;
  }

  String inverseInfo(String info) {
    final list = info.split("");
    for (int i = 0; i < list.length; i++) {
      if (list[i] == "U") {
        list[i] = "D";
        continue;
      }
      if (list[i] == "D") {
        list[i] = "U";
        continue;
      }
      if (list[i] == "L") {
        list[i] = "R";
        continue;
      }
      if (list[i] == "R") {
        list[i] = "L";
        continue;
      }
    }
    return list.join();
  }
}

class GamePieceMove {
  int id = 0;
  int toX = 0;
  int toY = 0;
  int dx = 0;
  int dy = 0;

  void addMove(String input) {
    final list = splitMove(input);
    id = int.parse(list.first);
    if (list.last == "U") toY = -1;
    if (list.last == "D") toY = 1;
    if (list.last == "L") toX = -1;
    if (list.last == "R") toX = 1;
  }

  List<String> splitMove(String input) {
    List<String> resultList = [];
    RegExp pattern = RegExp(r'\d+|\D+');
    Iterable<Match> matches = pattern.allMatches(input);
    for (Match match in matches) {
      resultList.add(match.group(0)!);
    }
    return resultList;
  }
}
