import 'dart:collection';
import 'dart:isolate';

import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_my_step.dart';
import 'package:huaroad/module/game/game_teach_model.dart';
import 'package:huaroad/module/game/hrd_game/board.dart';
import 'package:huaroad/module/game/num_game/num_game_solver.dart';
import 'package:huaroad/module/piece/piece_handler.dart';

class GameSolution {
  static GameSolution? _instance;

  GameSolution._internal() {
    _instance = this;
  }

  factory GameSolution() => _instance ?? GameSolution._internal();

  List<List<int>> dir = [
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, -1]
  ];

  HrdBoard board = HrdBoard(); // 棋盘
  List<bool> boolListForValidationChecking = List.filled(20, false);
  final List<HrdBoard> solutions = []; // 保存解的列表

  Isolate? isolate;
  SendPort? sendPort;
  ReceivePort? mainReceivePort;
  Function(List<TeachModel>)? onComplete;
  GameType _gameType = GameType.hrd;

  void compute({
    required String currentBoardString,
    required CMatrix2 currentBoardMatrix,
    required GameType gameType,
  }) async {
    mainReceivePort ??= ReceivePort();
    _gameType = gameType;

    if (sendPort != null) {
      sendPort!.send(gameType == GameType.hrd ? currentBoardString : currentBoardMatrix);
      return;
    }

    Isolate.spawn(gessssssssstSol, mainReceivePort!.sendPort);
    mainReceivePort!.listen((message) {
      if (message is SendPort) {
        sendPort = message;
        sendPort!.send(gameType == GameType.hrd ? currentBoardString : currentBoardMatrix);
      } else {
        if (onComplete != null) onComplete!(message);
      }
    });
  }

  static void gessssssssstSol(SendPort sendPort) {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    receivePort.listen((message) {
      if (message is String) {
        final res = GameSolution().sol(message);
        sendPort.send(res);
      } else {
        final res = NumGameSolver().sol(message);
        sendPort.send(res);
      }
    });
  }

  List<TeachModel> sol(String current) {
    List<TeachModel> res = [];
    HrdBoard board = HrdBoard.updateBoard(PieceHandler().createModelListFromString(current, GameType.hrd));
    hasSolution(board, successful, maxDeep: 200);
    for (HrdBoard board in solutions) {
      var step = MyStep();
      if (board.move != null) {
        Move move = Move(x: board.move!.shape.y, y: board.move!.shape.x, toX: board.move!.dirY, toY: board.move!.dirX);
        step.push(move);
      }
      res.add(TeachModel(step: step, matrix2: listToMatrix(board.getBoardList())));
    }
    return res;
  }

  // 判断是否有解
  bool hasSolution(HrdBoard board, Function check, {int maxDeep = 10000}) {
    Stopwatch sw = Stopwatch();
    sw.start();
    if (check(board)) {
      setSolutionList(board);
      return true;
    }

    final Queue<HrdBoard> queue = Queue(); // 搜索队列
    final Queue<HrdBoard> queueTmp = Queue(); // 搜索队列， 临时保存当前层的
    final Set<String> closeQueen = {};
    solutions.clear();
    board.parent = null;
    queue.addLast(board);
    int deep = 1;

    while (queue.isEmpty == false) {
      if (deep > maxDeep) {
        break;
      }
      deep += 1;
      while (queue.isEmpty == false) {
        board = queue.removeFirst();
        if (closeQueen.contains(board.getBoardListString())) continue;
        closeQueen.add(board.getBoardListString());
        List<TMove> moves = getCanMoving(board);
        for (var move in moves) {
          HrdBoard newBoard = board.copy();
          moveTo(newBoard, move.shape, move.dirX, move.dirY);
          if (!closeQueen.contains(newBoard.getBoardListString())) {
            queueTmp.addLast(newBoard);
            newBoard.move = move;
            newBoard.parent = board;
          }
          // 终点
          if (check(newBoard)) {
            setSolutionList(newBoard);
            sw.stop();
            print("time : ${sw.elapsedMilliseconds / 1000}");
            return true;
          }
        }
      }
      while (queueTmp.isEmpty == false) {
        queue.addLast(queueTmp.removeFirst());
      }
    }
    print("time : ${sw.elapsedMilliseconds / 1000}");
    return false;
  }

  // 在棋盘上移动某个shape。 board 对应棋盘， shape 待移动的shape， stepX, stepY 移动方向
  static void moveTo(HrdBoard board, Shape shape, int stepX, int stepY) {
    board.removeShape(shape);
    Shape newShape = shape.copy();
    newShape.x = shape.x + stepX;
    newShape.y = shape.y + stepY;
    bool flag = board.addShape(newShape);
  }

  // 判断是否可以移动，true 可以移动， false 不可以移动
  static bool canMoveTo(HrdBoard board, Shape shape, int stepX, int stepY) {
    int x = shape.x + stepX;
    int y = shape.y + stepY;
    if (x < 0 || x >= 5 || y < 0 || y >= 4) return false;

    bool flag1 = board.removeShape(shape);
    if (flag1 == false) return false;
    Shape newShape = shape.copy();
    newShape.x = x;
    newShape.y = y;
    bool flag = board.addShape(newShape);
    if (flag) {
      board.removeShape(newShape);
    }
    bool flag3 = board.addShape(shape);
    return flag;
  }

  // 最终状态，即2*2的格子的左上角位于(3,1)
  static bool successful(HrdBoard board) {
    for (var shape in board.list) {
      if (shape is FourShape) {
        return shape.x == 3 && shape.y == 1;
      }
    }
    return false;
  }

  bool isSuccess() {
    for (var shape in board.list) {
      if (shape is FourShape) {
        return shape.x == 3 && shape.y == 1;
      }
    }
    return false;
  }

  // 最终状态，boolList 和传过来的boolList相等
  bool checkTwoEndWithBoolList(HrdBoard board1) {
    return board1.boolList.toString() == boolListForValidationChecking.toString();
  }

  // 获得移动的候选shape， 只要和空白相邻就是候选， 后面再进行合法性判断
  static List<Shape> getMovingCandidate(HrdBoard board) {
    Set<Shape> list = {};
    List<int> spaces = getFreePlace(board);
    for (var shape in board.list) {
      bool flag = false;
      for (int i = 0; i < spaces.length && flag == false; i++) {
        int x = spaces[i] ~/ 4;
        int y = spaces[i] % 4;
        flag = neighbour(shape, x, y);
      }
      if (flag) {
        list.add(shape);
      }
    }

    return list.toList();
  }

  // 某个格子是不是在某个shape里面
  static bool pointInShape(Shape a, int x, int y) {
    return x >= a.x && x < a.x + a.h && y >= a.y && y < a.y + a.w;
  }

  // 判断shape 是不是和某个格子相邻
  static bool neighbour(Shape a, int x, int y) {
    return pointInShape(a, x - 1, y) ||
        pointInShape(a, x, y - 1) ||
        pointInShape(a, x + 1, y) ||
        pointInShape(a, x, y + 1);
  }

  // 获得棋盘上空白处
  static List<int> getFreePlace(HrdBoard board) {
    final List<int> list = [];
    final List<bool> boardList = board.boolList;
    for (int i = 0; i < boardList.length; i++) {
      if (boardList[i] == false) {
        list.add(i);
      }
    }
    return list;
  }

  List<TMove> getCanMoving(HrdBoard board) {
    List<TMove> res = [];
    List<Shape> candidates = getMovingCandidate(board);
    for (var candidateShape in candidates) {
      for (var dirs in dir) {
        if (canMoveTo(board, candidateShape, dirs[0], dirs[1])) {
          TMove move = TMove(candidateShape, dirs[0], dirs[1]);
          res.add(move);
        }
      }
    }
    return res;
  }

  bool updateBoard(List<bool> theList) {
    boolListForValidationChecking = theList;
    if (hasSolution(board, checkTwoEndWithBoolList, maxDeep: 10)) {
      board = solutions.last;
      getStep();
      return true;
    }
    return false;
  }

  void getStep() {
    for (HrdBoard board in solutions) {
      var step = MyStep();
      if (board.move != null) {
        Move move = Move(
          x: board.move!.shape.y,
          y: board.move!.shape.x,
          toX: board.move!.dirY,
          toY: board.move!.dirX,
        );
        step.push(move);
      }
      // stepQueen.add(step);
    }
  }

  // 设置解的列表，一些转换
  void setSolutionList(HrdBoard board) {
    var boardList = <HrdBoard>[];
    while (board.parent != null) {
      boardList.add(board);
      board = board.parent!;
    }
    solutions.addAll(boardList.reversed.toList());
  }

  /// 一维数组 -> 二维
  CMatrix2 listToMatrix(List<int> board) {
    CMatrix2 matrix = [];
    int start = 0;
    int end = 4;
    while (start >= 0 && end <= board.length) {
      matrix.add(List.from(board.sublist(start, end)));
      start += 4;
      end += 4;
    }
    return matrix;
  }
}
