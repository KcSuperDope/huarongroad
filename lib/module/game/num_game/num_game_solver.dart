import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game/game_my_step.dart';
import 'package:huaroad/module/game/game_teach_model.dart';

class NumGameSolver {
  final MAX_STEP = 200;
  final INT_MAX = 2147483647;

  List<String> solution = List.filled(200, "0");

  List<TeachModel> sol(CMatrix2 bord) {
    solution = List.filled(200, "0");
    int threshold = 0;

    while (true) {
      threshold = cal(0, -1, 0, 0, threshold, true, bord);
      if (threshold > 0) {
      } else {
        break;
      }
    }

    return handleSol(bord);
  }

  int cal(int depth, int x, int y, int hScore, int threshold, bool fast, CMatrix2 bord) {
    int i, j;
    int fScore;
    int newHScore;
    int newX = 0, newY = 0;
    int piece;
    int min;
    int oldLeft, oldRight, oldTop, oldBot;
    int newLeft, newRight, newTop, newBot;
    int x0, y0;
    int bordX = bord.first.length;
    int bordY = bord.length;

    String move = "0";

    assert(depth < MAX_STEP);
    if (x == -1) {
      for (i = 0; i < bordX; i++) {
        for (j = 0; j < bordY; j++) {
          if (bord[j][i] == 0) {
            x = i;
            y = j;
          }
        }
      }
    }

    if (hScore == 0) {
      for (i = 0; i < bordX; i++) {
        for (j = 0; j < bordY; j++) {
          if (bord[j][i] != 0) {
            x0 = (bord[j][i] - 1) % bordX;
            y0 = (bord[j][i] - 1) ~/ bordY;
            hScore += (i - x0).abs() + (j - y0).abs();
          }
        }
      }
      if (fast) {
        for (i = 0; i < bordX; i++) {
          for (j = 0; j < bordY; j++) {
            if (bord[j][i] != 0) {
              if (i > 0) {
                if (bord[j][i - 1] > bord[j][i]) hScore += 2;
              }
              if (j > 0) {
                if (bord[j - 1][i] > bord[j][i]) hScore += 2;
              }
            }
          }
        }
      }
    }

    fScore = depth + hScore;
    if (fScore > threshold) return fScore;

    min = INT_MAX;
    for (i = 0; i < 4; i++) {
      switch (i) {
        case 0:
          if (y == (bordY - 1)) {
            continue;
          }
          if ((depth != 0) && (solution[depth - 1] == 'd')) continue;
          move = 'u';
          newX = x;
          newY = y + 1;
          break;
        case 1:
          if (y == 0) {
            continue;
          }
          if ((depth != 0) && (solution[depth - 1] == 'u')) continue;
          move = 'd';
          newX = x;
          newY = y - 1;
          break;
        case 2:
          if (x == (bordX - 1)) {
            continue;
          }
          if ((depth != 0) && (solution[depth - 1] == 'r')) continue;
          move = 'l';
          newX = x + 1;
          newY = y;
          break;
        case 3:
          if (x == 0) {
            continue;
          }
          if ((depth != 0) && (solution[depth - 1] == 'l')) continue;
          move = 'r';
          newX = x - 1;
          newY = y;
          break;
      }
      solution[depth] = move;
      bord[y][x] = bord[newY][newX];
      bord[newY][newX] = 0;
      newHScore = hScore;
      piece = bord[y][x];
      if ((move == 'u') || (move == 'd')) {
        piece = (piece - 1) ~/ bordX;
        if ((piece - y).abs() > (piece - newY).abs()) {
          newHScore++;
        } else {
          newHScore--;
        }
      } else {
        piece = (piece - 1) % bordX;
        if ((piece - x).abs() > (piece - newX).abs()) {
          newHScore++;
        } else {
          newHScore--;
        }
      }
      if (fast) {
        piece = bord[y][x];

        if (newX == 0) {
          oldLeft = -1;
        } else {
          oldLeft = bord[newY][newX - 1];
        }

        if (newX == bordX - 1) {
          oldRight = INT_MAX;
        } else {
          oldRight = bord[newY][newX + 1];
        }
        if (newY == 0) {
          oldTop = -1;
        } else {
          oldTop = bord[newY - 1][newX];
        }
        if (newY == bordY - 1) {
          oldBot = INT_MAX;
        } else {
          oldBot = bord[newY + 1][newX];
        }

        if (x == 0) {
          newLeft = -1;
        } else {
          newLeft = bord[y][x - 1];
        }
        if (x == bordX - 1) {
          newRight = INT_MAX;
        } else {
          newRight = bord[y][x + 1];
        }
        if (y == 0) {
          newTop = -1;
        } else {
          newTop = bord[y - 1][x];
        }
        if (y == bordY - 1) {
          newBot = INT_MAX;
        } else {
          newBot = bord[y + 1][x];
        }

        if ((oldLeft > piece) && (oldLeft != 0)) newHScore -= 2;
        if ((newLeft > piece) && (newLeft != 0)) newHScore += 2;
        if ((oldRight < piece) && (oldRight != 0)) newHScore -= 2;
        if ((newRight < piece) && (newRight != 0)) newHScore += 2;
        if ((oldTop > piece) && (oldTop != 0)) newHScore -= 2;
        if ((newTop > piece) && (newTop != 0)) newHScore += 2;
        if ((oldBot < piece) && (oldBot != 0)) newHScore -= 2;
        if ((newBot < piece) && (newBot != 0)) newHScore += 2;
      }

      if (newHScore > 0) {
        fScore = cal(depth + 1, newX, newY, newHScore, threshold, fast, bord);
      }
      switch (move) {
        case 'u':
          bord[y + 1][x] = bord[y][x];
          break;
        case 'd':
          bord[y - 1][x] = bord[y][x];
          break;
        case 'l':
          bord[y][x + 1] = bord[y][x];
          break;
        case 'r':
          bord[y][x - 1] = bord[y][x];
          break;
      }
      bord[y][x] = 0;
      if (newHScore == 0) {
        solution[depth + 1] = "0";
        return 0;
      } else if (fScore == 0) {
        return 0;
      }
      if (fScore < min) {
        min = fScore;
      }
    }

    return min;
  }

  List<TeachModel> handleSol(CMatrix2 bord) {
    List<TeachModel> list = [];
    int x = 0;
    int y = 0;
    for (int i = 0; i < bord.first.length; i++) {
      for (int j = 0; j < bord.length; j++) {
        if (bord[j][i] == 0) {
          x = i;
          y = j;
        }
      }
    }

    CMatrix2 T = clone(bord);
    for (int i = 0; i < solution.length; i++) {
      String moveDir = solution[i];
      if (moveDir == "0") break;
      CMatrix2 matrix2 = [];
      MyStep step = MyStep();
      Move move = Move(x: 0, y: 0, toX: 0, toY: 0);
      if (moveDir == "u") {
        T[y][x] = T[y + 1][x];
        T[y + 1][x] = 0;
        matrix2 = clone(T);
        move = Move(x: x, y: y + 1, toX: 0, toY: -1);
        y++;
      } else if (moveDir == "d") {
        T[y][x] = T[y - 1][x];
        T[y - 1][x] = 0;
        matrix2 = clone(T);
        move = Move(x: x, y: y - 1, toX: 0, toY: 1);
        y--;
      } else if (moveDir == "l") {
        T[y][x] = T[y][x + 1];
        T[y][x + 1] = 0;
        matrix2 = clone(T);
        move = Move(x: x + 1, y: y, toX: -1, toY: 0);
        x++;
      } else if (moveDir == "r") {
        T[y][x] = T[y][x - 1];
        T[y][x - 1] = 0;
        matrix2 = clone(T);
        move = Move(x: x - 1, y: y, toX: 1, toY: 0);
        x--;
      }
      step.push(move);
      list.add(TeachModel(step: step, matrix2: matrix2));
    }
    return list;
  }

  CMatrix2 clone(CMatrix2 matrix2) {
    CMatrix2 clone = [];
    for (var element in matrix2) {
      clone.add(List.from(element));
    }
    return clone;
  }

  String solString(CMatrix2 bord) {
    solution = List.filled(200, "0");
    int threshold = 0;
    while (true) {
      threshold = cal(0, -1, 0, 0, threshold, true, bord);
      if (threshold > 0) {
      } else {
        break;
      }
    }
    String res = "";
    for (var element in solution) {
      if (element != "0") {
        res += element;
      } else {
        break;
      }
    }
    return res;
  }
}
