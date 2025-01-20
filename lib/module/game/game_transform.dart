import 'package:huaroad/module/game/game.dart';

class GameTransform {
  static GameTransform? _instance;

  GameTransform._internal() {
    _instance = this;
  }

  factory GameTransform() => _instance ?? GameTransform._internal();

  void codeToBoard(String code) {
    final list = code.split("");
    CMatrix2 matrix = [];
    for (int i = 0; i < 5; i++) {
      matrix.add(List.filled(4, -1));
    }
    for (int i = 0; i < list.length; i++) {
      final location = list[i];
      final a = int.parse(location, radix: 16);
      if (i == 0) {
        final dx = a ~/ 4;
        final dy = a % 4;
        matrix[dx][dy] = 4;
        matrix[dx + 1][dy] = 4;
        matrix[dx][dy + 1] = 4;
        matrix[dx + 1][dy + 1] = 4;
      } else {
        final b = a.toRadixString(2).padLeft(4, "0");
        final b1 = int.parse(b.substring(0, 2), radix: 2);
        final b2 = int.parse(b.substring(2, 4), radix: 2);
        insert(matrix, b1);
        insert(matrix, b2);
      }
    }
    String v = "";
    matrix.forEach((el1) {
      el1.forEach((el2) {
        v += el2.toString();
      });
    });
    print(v);
  }

  void insert(CMatrix2 matrix, int value) {
    int position = 0;
    if (position ~/ 4 > (matrix.length - 1) || position % 4 > (matrix.first.length - 1)) return;
    while (matrix[position ~/ 4][position % 4] >= 0) {
      position++;
      if (position >= 20) break;
    }
    if (position >= 20) return;
    final dx = position ~/ 4;
    final dy = position % 4;
    if (value == 0) {
      // empty
      matrix[dx][dy] = 0;
    } else if (value == 1) {
      // 2 * 1
      matrix[dx][dy] = 2;
      matrix[dx][dy + 1] = 2;
    } else if (value == 2) {
      // 1 * 2
      matrix[dx][dy] = 3;
      matrix[dx + 1][dy] = 3;
    } else if (value == 3) {
      // 1 * 1
      matrix[dx][dy] = 1;
    }
  }
}
