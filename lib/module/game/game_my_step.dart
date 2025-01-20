import 'package:huaroad/module/piece/piece_model.dart';

class MyStep {
  List<Move> get moves => _moves;

  bool get isEmpty => _moves.isEmpty;

  final _moves = <Move>[];

  void push(Move move) {
    _moves.add(move);
  }

  // 逆步
  void inverse() {
    if (_moves.isEmpty) return;
    List<Move> temp = _moves.reversed.toList();
    _moves.clear();
    for (var element in temp) {
      _moves.add(element.inverse());
    }
  }

  MyStep clone() {
    MyStep step = MyStep();
    for (var element in _moves) {
      step.moves.add(element.clone());
    }
    return step;
  }

  bool isSame(MyStep step) {
    if (_moves.length == step.moves.length) {
      for (int i = 0; i < _moves.length; i++) {
        Move m1 = _moves[i];
        Move m2 = step.moves[i];
        if (!m1.isSame(m2)) {
          return false;
        }
      }
      return true;
    }
    return false;
  }
}

class Move {
  final PieceModel? item;
  final int x, y, toX, toY;

  Move({
    this.item,
    required this.x,
    required this.y,
    required this.toX,
    required this.toY,
  });

  Move inverse() {
    return Move(x: x + toX, y: y + toY, toX: -toX, toY: -toY);
  }

  Move clone() {
    return Move(x: x, y: y, toX: toX, toY: toY);
  }

  bool isSame(Move move) {
    return x == move.x && y == move.y && toX == move.toX && toY == move.toY;
  }
}
