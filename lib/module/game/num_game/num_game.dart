import 'dart:math';

import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_engine.dart';
import 'package:huaroad/module/game/game_my_step.dart';
import 'package:huaroad/module/game/game_teach_model.dart';
import 'package:huaroad/module/game/game_to_data.dart';
import 'package:huaroad/module/game/num_game/num_game_solver.dart';

class NumGame extends Game with DbJson {
  CMatrix2 target = [];
  CMatrix2 currentMatrix = [];
  List<Node> openQueen = [];
  late Node initNode;

  NumGame.fromData(String data) {
    List<int> list = [];
    data.split(" ").forEach((element) {
      list.add(int.parse(element));
    });
    if (list.length == 9) {
      rowNum = 3;
      colNum = 3;
      type.value = GameType.number3x3;
    } else if (list.length == 16) {
      rowNum = 4;
      colNum = 4;
      type.value = GameType.number4x4;
    } else if (list.length == 20) {
      rowNum = 5;
      colNum = 4;
      type.value = GameType.number4x5;
    }
    CMatrix2 matrix = listToMatrix(list);
    openingList = list;
    openingMatrix = matrix;
    initNode = generalNode(openingMatrix);
    initNode.parent = null;
    opening = data;
    currentMatrix = matrix;
    target = generalTargetMatrix();
    calculateCost(initNode);
    super.init();
  }

  /// 求解(步骤 + 棋盘)
  @override
  Future<List<TeachModel>> getSolutionModel() async {
    // return handleSolutionStep(getSolution());
    return NumGameSolver().sol(getCurrentMatrix());
  }

  String getSolutionDirection() {
    if (type.value == GameType.number4x5) {
      return handleSolutionString(getSolution());
    } else {
      return NumGameSolver().solString(openingMatrix);
    }
  }

  @override
  HallState getHallSate() {
    List<bool> hall = [];
    for (int i = 0; i < rowNum; i++) {
      for (int j = 0; j < colNum; j++) {
        hall.add(currentMatrix[i][j] != 0);
      }
    }
    return hall;
  }

  @override
  bool canUpdate(HallState hall, [int maxDeep = 10]) {
    return canUpdateGameBoard(maxDeep, hall);
  }

  @override
  bool win() {
    return getCurrentMatrix().toString() == target.toString();
  }

  // 生成node
  Node generalNode(CMatrix2 matrix) {
    int zeroRow = 0;
    int zeroCol = 0;
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        if (matrix[i][j] == 0) {
          zeroRow = i;
          zeroCol = j;
        }
      }
    }
    Node node = Node(zeroRow, zeroCol, matrix);
    calculateCost(node);
    return node;
  }

  // 生成目标矩阵
  CMatrix2 generalTargetMatrix() {
    CMatrix2 matrix = [];
    int i = 0;
    while (i < rowNum) {
      matrix.add(List.generate(colNum, (index) => index + 1 + (colNum * i)));
      i++;
    }
    matrix[rowNum - 1][colNum - 1] = 0;
    return matrix;
  }

  // 生成初始矩阵
  generalInitMatrix() {
    List<int> list = List.generate(rowNum * colNum - 1, (index) => index + 1);
    do {
      list.shuffle(Random(DateTime.now().hashCode));
    } while (GameEngine().hasSolution(list));
    list.add(0);
    openingMatrix = listToMatrix(list);
    for (var element in list) {
      opening += "$element ";
    }
  }

  //计算代价
  calculateCost(Node node) {
    int cost = 0;
    CMatrix2 matrix = node.matrix;
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        int val = matrix[i][j];
        //当前值不是空白 也不是目标值
        if (val != 0 && val != colNum * i + j + 1) {
          int targetRow = matrix[i][j] ~/ colNum;
          int targetCol = matrix[i][j] % colNum - 1;
          if (targetCol == -1) {
            targetRow -= 1;
            targetCol = colNum - 1;
          }
          int c = (targetRow - i).abs() + (targetCol - j).abs();
          cost += c;
        }
      }
    }
    node.cost = cost * 3 + node.gn;
  }

  // 在maxDeep内可以变换到目标状态
  bool canUpdateGameBoard(int maxDeep, HallState hallState) {
    Node initNode = generalNode(currentMatrix);
    if (isSameHall(initNode.getBoolList(), hallState)) {
      return true;
    }

    Set<String> closeQueen = {};
    List<Node> tempQueen = [];
    int deep = 0;

    openQueen.clear();
    openQueen.add(initNode);
    while (openQueen.isNotEmpty) {
      if (deep > maxDeep) {
        break;
      }
      deep++;
      print("------------------$deep -------------------");
      while (openQueen.isNotEmpty) {
        Node firstNode = openQueen.first;
        openQueen.removeAt(0);
        if (closeQueen.contains(firstNode.matrix.toString())) continue;
        closeQueen.add(firstNode.matrix.toString());
        List<Node> childNode = firstNode.getNeighbor();
        for (int i = 0; i < childNode.length; i++) {
          Node node = childNode[i];
          if (closeQueen.contains(node.matrix.toString())) continue;
          tempQueen.add(node);
          if (isSameHall(node.getBoolList(), hallState)) {
            print("---------------------- success ---------------------");
            node.printMatrix();
            currentMatrix = node.matrix;
            getPath(node);
            return true;
          }
        }
      }
      while (tempQueen.isNotEmpty) {
        openQueen.add(tempQueen.first);
        tempQueen.removeAt(0);
      }
    }
    return false;
  }

  void getPath(Node node) {
    List<MyStep> list = [];
    while (node.parent != null) {
      MyStep step = MyStep();
      if (node.move != null) {
        step.push(node.move!);
      }
      node = node.parent!;
      list.add(step);
    }
    // stepQueen.addAll(list.reversed);
  }

  Node getSolution() {
    Stopwatch sw = Stopwatch();
    sw.start();
    openQueen.clear();
    Set<String> closeSet = {};
    int deep = 0;

    Node initNode = generalNode(getCurrentMatrix());
    if (condition(initNode.matrix)) return initNode;
    openQueen.add(initNode);

    double a = 0;
    double b = 0;
    double c = 0;
    double d = 0;
    double e = 0;

    while (openQueen.isNotEmpty) {
      if (deep == 10000) a = sw.elapsedMilliseconds / 1000;
      if (deep == 20000) b = sw.elapsedMilliseconds / 1000;
      if (deep == 30000) c = sw.elapsedMilliseconds / 1000;
      if (deep == 40000) d = sw.elapsedMilliseconds / 1000;
      if (deep == 50000) e = sw.elapsedMilliseconds / 1000;

      if (deep == 60000) {
        print(a);
        print(b);
        print(c);
        print(d);
        print(e);
        print("------------------------- 超时 耗时：${sw.elapsedMilliseconds / 1000}s-----------------------------");
        break;
      }
      deep++;
      Node firstNode = openQueen.first;
      // print("------------------ $deep cost : ${firstNode.cost}-------------------");

      openQueen.removeAt(0);
      if (closeSet.contains(firstNode.matrix.toString())) continue;
      closeSet.add(firstNode.matrix.toString());
      if (condition(firstNode.matrix)) {
        print("--------------- success 耗时：${sw.elapsedMilliseconds / 1000}s --------------");
        return firstNode;
      }
      List<Node> childNode = firstNode.getNeighbor();
      for (int i = 0; i < childNode.length; i++) {
        Node node = childNode[i];
        if (condition(node.matrix)) {
          print("--------------- success 耗时：${sw.elapsedMilliseconds / 1000}s --------------");
          return node;
        }
        insertSort(openQueen, node);
      }
    }
    return initNode;
  }

  bool condition(CMatrix2 matrix) {
    return matrix.toString() == target.toString();
  }

  List<MyStep> handleSolutionStep(Node node) {
    List<MyStep> list = [];
    while (node.parent != null) {
      MyStep step = MyStep();
      if (node.move != null) {
        step.push(node.move!);
      }
      node = node.parent!;
      list.add(step);
    }
    return list.reversed.toList();
  }

  String handleSolutionString(Node node) {
    List<MyStep> solStep = handleSolutionStep(node);
    List<String> solStringList = List.filled(200, "0");

    for (int i = 0; i < solStep.length; i++) {
      MyStep step = solStep[i];
      if (step.moves.first.toX == 1) {
        solStringList[i] = "l";
      } else if (step.moves.first.toX == -1) {
        solStringList[i] = "r";
      } else if (step.moves.first.toY == 1) {
        solStringList[i] = "d";
      } else if (step.moves.first.toY == -1) {
        solStringList[i] = "u";
      }
    }

    String res = "";
    for (var element in solStringList) {
      if (element != "0") {
        res += element;
      } else {
        break;
      }
    }

    return res;
  }

  void insertSort(List<Node> list, Node node) {
    int left = 0, right = list.length;
    while (left < right) {
      int mid = left + (right - left) ~/ 2;
      if (list[mid].cost! <= node.cost!) {
        left = mid + 1;
      } else {
        right = mid;
      }
    }
    list.insert(left, node);
  }
}

class Node {
  int row = 0;
  int col = 0;
  int? cost;
  int gn = 0;
  Node? parent;
  CMatrix2 matrix;
  Move? move;

  Node(this.row, this.col, this.matrix);

  List<bool> getBoolList() {
    int row = matrix.length;
    int col = matrix[0].length;
    List<bool> list = List.filled(col * row, true);
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        list[i * col + j] = (matrix[i][j] != 0);
      }
    }
    return list;
  }

  List<Node> getNeighbor() {
    int rowNum = matrix.length;
    int colNum = matrix[0].length;
    List<Node> list = [];
    if (row > 0) {
      Node n = generateNeighborNode(this, row - 1, col);
      n.move = Move(x: col, y: row - 1, toX: 0, toY: 1);
      list.add(n);
    }
    if (row < rowNum - 1) {
      Node n = generateNeighborNode(this, row + 1, col);
      n.move = Move(x: col, y: row + 1, toX: 0, toY: -1);
      list.add(n);
    }
    if (col > 0) {
      Node n = generateNeighborNode(this, row, col - 1);
      n.move = Move(x: col - 1, y: row, toX: 1, toY: 0);
      list.add(n);
    }
    if (col < colNum - 1) {
      Node n = generateNeighborNode(this, row, col + 1);
      n.move = Move(x: col + 1, y: row, toX: -1, toY: 0);
      list.add(n);
    }
    return list;
  }

  Node generateNeighborNode(Node parentNode, int row, int col) {
    CMatrix2 matrix = cloneMatrix(parentNode.matrix);
    int temp = parentNode.matrix[row][col];
    matrix[row][col] = matrix[parentNode.row][parentNode.col];
    matrix[parentNode.row][parentNode.col] = temp;
    Node node = Node(row, col, matrix);
    node.parent = parentNode;
    node.gn = parentNode.gn + 1;
    calculateCost(node);
    return node;
  }

  CMatrix2 cloneMatrix(CMatrix2 matrix) {
    CMatrix2 newMatrix = [];
    for (int i = 0; i < matrix.length; i++) {
      newMatrix.add(List.from(matrix[i]));
    }
    return newMatrix;
  }

  calculateCost(Node node) {
    int manhattan = 0, geometric = 0, wrongNext = 0, wrong = 0;
    CMatrix2 matrix = node.matrix;
    int colNum = node.matrix[0].length;
    List<int> list = [];
    Set<int> tempTarget = {1, 2, 3, 4};
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        int val = matrix[i][j];
        list.add(val);
        //当前值不是空白 也不是目标值
        // if (!tempTarget.contains(val)) continue;
        if (val != 0 && val != colNum * i + j + 1) {
          int targetRow = matrix[i][j] ~/ colNum;
          int targetCol = matrix[i][j] % colNum - 1;
          if (targetCol == -1) {
            targetRow -= 1;
            targetCol = colNum - 1;
          }
          int dr = (targetRow - i).abs();
          int dc = (targetCol - j).abs();
          manhattan += dr + dc;
          geometric += sqrt(dr * dr + dc * dc).toInt();
          wrong++;
        }
      }
    }
    for (int i = 0; i < list.length - 1; i++) {
      if (list[i] + 1 != list[i + 1]) {
        wrongNext++;
      }
    }
    // node.cost = manhattan * 3 + node.gn;
    node.cost = (manhattan * 3 + wrongNext + geometric) * 2 + node.gn * 2;
    // node.cost = (manhattan * 2 + wrongNext + geometric) * 3 + node.gn;
  }

  printMatrix() {
    print("*************COST:$cost ****************");
    String res = "\n";
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        int v = matrix[i][j];
        res = "$res$v ";
      }
      res += '\n';
    }
    print(res);
    print("*****************************");
  }
}
