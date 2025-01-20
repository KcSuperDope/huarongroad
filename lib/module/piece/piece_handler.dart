import 'package:flutter/material.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/piece/piece_model.dart';
import 'package:huaroad/styles/styles.dart';

class PieceHandler {
  static PieceHandler? _instance;

  PieceHandler._internal() {
    _instance = this;
  }

  factory PieceHandler() => _instance ?? PieceHandler._internal();

  PieceModel get CShape => PieceModel(width: 2, height: 2, color: color_piece_green);

  PieceModel get HShape => PieceModel(width: 2, height: 1, color: color_piece_black);

  PieceModel get VShape => PieceModel(width: 1, height: 2, color: color_piece_black);

  PieceModel get DShape => PieceModel(width: 1, height: 1, color: color_piece_green);

  PieceModel get CShapeLock => PieceModel(width: 2, height: 2, color: Colors.grey);

  PieceModel get HShapeLock => PieceModel(width: 2, height: 1, color: Colors.grey);

  PieceModel get VShapeLock => PieceModel(width: 1, height: 2, color: Colors.grey);

  PieceModel get DShapeLock => PieceModel(width: 1, height: 1, color: Colors.grey);

  List<PieceModel> createModelListFromString(String matrix, GameType type) {
    List<int> list = [];
    int colNum = type == GameType.number3x3 ? 3 : 4;
    if (type == GameType.hrd) {
      matrix.split("").forEach((element) {
        list.add(int.parse(element));
      });
    } else {
      matrix.split(" ").forEach((element) {
        list.add(int.parse(element));
      });
    }
    return PieceHandler().createModelList(listToMatrix(list, colNum), type);
  }

  List<PieceModel> createModelList(CMatrix2 cMatrix2, GameType type) {
    CMatrix2 cl = clone(cMatrix2);
    if (type == GameType.hrd) {
      return createHrdModelList(cl);
    } else {
      return createNumModelList(cl);
    }
  }

  CMatrix2 clone(CMatrix2 matrix2) {
    CMatrix2 clone = [];
    for (var element in matrix2) {
      clone.add(List.from(element));
    }
    return clone;
  }

  List<PieceModel> createHrdModelList(CMatrix2 matrix2) {
    final list = <PieceModel>[];
    var tag = 1;
    for (int i = 0; i < matrix2.length; i++) {
      for (int j = 0; j < matrix2[i].length; j++) {
        final type = matrix2[i][j];
        switch (type) {
          case -1:
            break;
          case 0:
            break;
          case 1:
            PieceModel b = DShape;
            b.id = tag++;
            b.dx = j;
            b.dy = i;
            b.kind = 1;
            b.color = color_9CBD00;
            b.image = FindDeviceHandler().deviceConnected.value
                ? "lib/assets/png/piece/piece_1.png"
                : "lib/assets/png/piece/piece_1_empty.png";
            list.add(b);
            break;
          case 2:
            PieceModel b = HShape;
            b.id = tag++;
            b.dx = j;
            b.dy = i;
            b.kind = 2;
            b.color = color_9CBD00;
            b.image = FindDeviceHandler().deviceConnected.value
                ? "lib/assets/png/piece/piece_2.png"
                : "lib/assets/png/piece/piece_2_empty.png";
            list.add(b);
            matrix2[i][j + 1] = -1;
            break;
          case 3:
            PieceModel b = VShape;
            b.id = tag++;
            b.dx = j;
            b.dy = i;
            b.kind = 3;
            b.color = color_9CBD00;
            b.image = FindDeviceHandler().deviceConnected.value
                ? "lib/assets/png/piece/piece_3.png"
                : "lib/assets/png/piece/piece_3_empty.png";
            list.add(b);
            matrix2[i + 1][j] = -1;
            break;
          case 4:
            PieceModel b = CShape;
            b.id = tag++;
            b.dx = j;
            b.dy = i;
            b.kind = 4;
            b.color = color_9CBD00;
            b.image = "lib/assets/png/piece/piece_4.png";
            list.add(b);
            matrix2[i][j + 1] = -1;
            matrix2[i + 1][j] = -1;
            matrix2[i + 1][j + 1] = -1;
            break;
        }
      }
    }

    return list;
  }

  List<PieceModel> createNumModelList(CMatrix2 lt) {
    final list = <PieceModel>[];
    int index = 0;
    for (int i = 0; i < lt.length; i++) {
      for (int j = 0; j < lt[i].length; j++) {
        index++;
        PieceModel m = DShape;
        int val = lt[i][j];
        if (val == 0) continue;
        m.isNumber = true;
        m.dx = j;
        m.dy = i;
        m.number = val;
        m.kind = 1;
        m.id = index;
        m.color = color_9CBD00;
        m.image = "lib/assets/png/piece/piece_num_empty.png";
        m.numberColor = FindDeviceHandler().deviceConnected.value ? null : color_D6D6D6;
        list.add(m);
      }
    }
    list.addAll(createLockListFromList(lt));
    return list;
  }

  /// 根据当前棋盘和正确棋盘生成空位错误棋子
  List<PieceModel> createError({required List<int> correct, required List<int> current, required GameType type}) {
    final list = <PieceModel>[];

    int rowNum = type == GameType.number3x3 ? 3 : 4;
    for (int i = 0; i < correct.length; i++) {
      if (correct[i] == 0 && current[i] != 0) {
        PieceModel m = PieceModel();
        m.kind = -2;
        m.image = "lib/assets/png/icon_piece_error_bg.png";
        m.dx = i % rowNum;
        m.dy = i ~/ rowNum;
        m.width = 1;
        m.height = 1;
        list.add(m);
      }
    }
    return list;
  }

  List<PieceModel> createLockListFromList(CMatrix2 lt) {
    final list = <PieceModel>[];
    if (lt.length == 3) {
      list.addAll(createLockList(GameType.number3x3));
    } else if (lt.length == 4) {
      list.addAll(createLockList(GameType.number4x4));
    }
    return list;
  }

  List<PieceModel> createLockList(GameType type) {
    final list = <PieceModel>[];
    if (type == GameType.number3x3) {
      PieceModel m1 = VShapeLock;
      m1.dx = 3;
      m1.dy = 0;
      m1.kind = -1;
      m1.id = -1;
      m1.isLock = true;
      m1.color = color_D1DADF;

      PieceModel m2 = VShapeLock;
      m2.dx = 3;
      m2.dy = 2;
      m2.kind = -1;
      m2.id = -1;
      m2.isLock = true;
      m2.color = color_D1DADF;

      PieceModel m3 = DShapeLock;
      m3.dx = 3;
      m3.dy = 4;
      m3.kind = -1;
      m3.id = -1;
      m3.isLock = true;
      m3.color = color_D1DADF;

      PieceModel m4 = CShapeLock;
      m4.dx = 0;
      m4.dy = 3;
      m4.kind = -1;
      m4.id = -1;
      m4.isLock = true;
      m4.color = color_D1DADF;

      PieceModel m5 = VShapeLock;
      m5.dx = 2;
      m5.dy = 3;
      m5.kind = -1;
      m5.id = -1;
      m5.isLock = true;
      m5.color = color_D1DADF;

      list.add(m1);
      list.add(m2);
      list.add(m3);
      list.add(m4);
      list.add(m5);
    } else if (type == GameType.number4x4) {
      PieceModel m1 = HShapeLock;
      m1.dx = 0;
      m1.dy = 4;
      m1.kind = -1;
      m1.id = -1;
      m1.isLock = true;
      m1.color = color_D1DADF;

      PieceModel m2 = HShapeLock;
      m2.dx = 2;
      m2.dy = 4;
      m2.kind = -1;
      m2.id = -1;
      m2.isLock = true;
      m2.color = color_D1DADF;

      list.add(m1);
      list.add(m2);
    }
    return list;
  }

  CMatrix2 createMatrix(
    int rowNum,
    int colNum,
    List<PieceModel> pieceList,
    GameType type,
  ) {
    CMatrix2 matrix = [];
    List<int> list = List.filled(rowNum * colNum, 0);
    for (int i = 0; i < rowNum; i++) {
      matrix.add(List.filled(colNum, 0));
    }
    for (var piece in pieceList) {
      if (piece.kind! < 0) continue;
      var places = piece.place(colNum);
      for (var idx in places) {
        if (type == GameType.hrd) {
          list[idx] = piece.kind!;
        } else {
          if (piece.number != null) {
            list[idx] = piece.number!;
          }
        }
        matrix[idx ~/ colNum][idx % colNum] = list[idx];
      }
    }
    return matrix;
  }

  List<int> createCurrentList(
    int rowNum,
    int colNum,
    List<PieceModel> pieceList,
    GameType type,
  ) {
    CMatrix2 matrix = createMatrix(rowNum, colNum, pieceList, type);
    final List<int> list = [];
    for (var el1 in matrix) {
      list.addAll(el1);
    }
    return list;
  }

  String createMatrixString(int rowNum, int colNum, List<PieceModel> pieceList, GameType type) {
    String res = "";
    final list = createCurrentList(rowNum, colNum, pieceList, type);
    if (type == GameType.hrd) {
      res = list.join("");
    } else {
      res = list.join(" ");
    }
    return res;
  }

  /// 一维数组 -> 二维
  CMatrix2 listToMatrix(List<int> board, int colNum) {
    CMatrix2 matrix = [];
    int start = 0;
    int end = colNum;
    while (start >= 0 && end <= board.length) {
      matrix.add(List.from(board.sublist(start, end)));
      start += colNum;
      end += colNum;
    }
    return matrix;
  }
}
