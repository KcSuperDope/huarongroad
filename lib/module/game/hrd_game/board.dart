import 'package:huaroad/module/piece/piece_model.dart';

class HrdBoard {
  TMove? move;
  HrdBoard? parent;
  final List<Shape> list = []; // 棋盘上的shape
  final List<bool> boolList = List.filled(20, false); // bool数组

  static HrdBoard updateBoard(List<PieceModel> pieceList) {
    HrdBoard board = HrdBoard();
    for (var element in pieceList) {
      switch (element.kind) {
        case 1:
          OneShape shape = OneShape(element.dy!, element.dx!);
          board.addShape(shape);
          break;
        case 2:
          TwoHShape shape = TwoHShape(element.dy!, element.dx!);
          board.addShape(shape);
          break;
        case 3:
          TwoVShape shape = TwoVShape(element.dy!, element.dx!);
          board.addShape(shape);
          break;
        case 4:
          FourShape shape = FourShape(element.dy!, element.dx!);
          board.addShape(shape);
          break;
      }
    }

    return board;
  }

  static HrdBoard createBoard(List<int> bl) {
    HrdBoard board = HrdBoard();
    List<int> boardList = [];
    boardList.addAll(bl);
    if (boardList.length != 20) return board;
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 4; j++) {
        int index = i * 4 + j;
        int kind = boardList[index];
        switch (kind) {
          case -1:
            break;
          case 1:
            OneShape shape = OneShape(i, j);
            board.addShape(shape);
            shape.getPlace().forEach((e) {
              boardList[e] = -1;
            });
            break;
          case 2:
            TwoHShape shape = TwoHShape(i, j);
            board.addShape(shape);
            shape.getPlace().forEach((e) {
              boardList[e] = -1;
            });
            break;
          case 3:
            TwoVShape shape = TwoVShape(i, j);
            board.addShape(shape);
            shape.getPlace().forEach((e) {
              boardList[e] = -1;
            });
            break;
          case 4:
            FourShape shape = FourShape(i, j);
            board.addShape(shape);
            shape.getPlace().forEach((e) {
              boardList[e] = -1;
            });
            break;
        }
      }
    }
    return board;
  }

  // 检查shape 是否能放下去
  bool checkPlace(Shape shape) {
    var list = shape.getPlace();
    for (var idx in list) {
      if (idx < 0 || idx >= 20) {
        return false;
      }
    }
    for (var idx in list) {
      if (boolList[idx]) {
        return false;
      }
    }
    // 高为2，不能选择最下面一排的的位置
    if (shape.x == 4 && (shape is FourShape || shape is TwoVShape)) {
      return false;
    }
    // 宽为2，不能选择最右边一排的的位置
    if (shape.y == 3 && (shape is FourShape || shape is TwoHShape)) {
      return false;
    }
    return true;
  }

  // 向棋盘加入一个shape
  bool addShape(Shape shape) {
    if (shape == Null || checkPlace(shape) == false) return false;
    fillShapeToBoard(shape);
    list.add(shape);
    return true;
  } //

  // 从棋盘移除一个shape
  bool removeShape(Shape shape) {
    if (shape == Null) return false;
    var idxList = shape.getPlace();
    for (var idx in idxList) {
      if (idx < 0 || idx >= 20) {
        return false;
      }
    }

    removeShapeFromBoard(shape);
    if (list.remove(shape) == false) {}
    return true;
  }

  // 更新bool数组，添加shape后
  void fillShapeToBoard(Shape shape) {
    var list = shape.getPlace();
    for (var index in list) {
      boolList[index] = true;
    }
  }

  // 更新bool数组，移除shape后
  void removeShapeFromBoard(Shape shape) {
    var list = shape.getPlace();
    for (var index in list) {
      boolList[index] = false;
    }
  }

  // 将棋盘转成一个列表
  List<int> getBoardList() {
    List<int> res = List.filled(20, 0);
    for (var shape in list) {
      var tmpList = shape.getPlace();
      for (var idx in tmpList) {
        res[idx] = shape.kind;
      }
    }
    return res;
  }

  // 将棋盘转成一个列表
  String getBoardListString() {
    List<int> l = getBoardList();
    String res = "";
    for (var element in l) {
      res += element.toString();
    }
    return res;
  }

  @override
  bool operator ==(Object other) {
    if (other is HrdBoard &&
        other.runtimeType == runtimeType &&
        other.list.length == list.length) {
      for (var value in list) {
        if (other.list.contains(value) == false) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(sort());

  @override
  String toString() {
    var res = "";
    for (var value in list) {
      res += value.toString();
    }
    return "{$runtimeType: $res}";
  }

  // sort函数
  Iterable<Object?> sort() {
    list.sort((Shape a, Shape b) {
      return a.compareTo(b);
    });
    return list;
  }

  // deep copy
  HrdBoard copy() {
    HrdBoard board = HrdBoard();
    for (int i = 0; i < list.length; i++) {
      board.list.add(list[i].copy());
    }
    for (int i = 0; i < boolList.length; i++) {
      board.boolList[i] = boolList[i];
    }
    return board;
  }
}

abstract class Shape extends Comparable {
  // 左上角坐标 (0, 0) -> (4, 3)
  int x = 0;
  int y = 0;
  int h = 1;
  int w = 1;
  int kind = 0;

  Shape(this.x, this.y, this.kind);

  // 重载等于号
  @override
  bool operator ==(Object other) {
    return (other is Shape &&
        other.runtimeType == runtimeType &&
        other.hashCode == hashCode);
  }

  // 获取shape块所有位置
  List<int> getPlace() {
    List<int> res = [];
    for (int i = x; i < x + h; i++) {
      for (int j = y; j < y + w; j++) {
        res.add(i * 4 + j);
      }
    }
    return res;
  }

  @override
  int get hashCode => Object.hash(x, y, kind);

  @override
  int compareTo(other) {
    if (other is Shape) {
      if (kind == other.kind) {
        if (y == other.y) {
          return x - other.x;
        }
        return y - other.y;
      }
      return other.kind - kind;
    }
    return 0;
  }

  @override
  String toString() {
    return "{$runtimeType: $x $y $kind}";
  }

  Shape copy();
}

class TwoHShape extends Shape {
  TwoHShape(int x, int y) : super(x, y, 2) {
    w = 2;
    h = 1;
  }

  @override
  Shape copy() {
    return TwoHShape(x, y);
  }
}

class TwoVShape extends Shape {
  TwoVShape(int x, int y) : super(x, y, 3) {
    w = 1;
    h = 2;
  }

  @override
  Shape copy() {
    return TwoVShape(x, y);
  }
}

class FourShape extends Shape {
  FourShape(int x, int y) : super(x, y, 4) {
    h = 2;
    w = 2;
  }

  @override
  Shape copy() {
    return FourShape(x, y);
  }
}

class OneShape extends Shape {
  OneShape(int x, int y) : super(x, y, 1);

  @override
  Shape copy() {
    return OneShape(x, y);
  }
}

class TMove {
  Shape shape; // 将要移动的shape
  int dirX; // 移动的方向
  int dirY;

  TMove(Shape shape, int x, int y)
      : shape = shape.copy(),
        dirX = x,
        dirY = y;
}
