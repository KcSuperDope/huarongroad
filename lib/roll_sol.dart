enum RollDirection { up, down, left, right }

enum BoxState { empty, white, black, lwrb, lbrw, twdb, tbdw }

class Roll {
  List<int> state;

  Roll(this.state);

  int m = 0;
  int n = 0;

  int get score => getScore();

  final Map<int, List<int>> regular = {
    1: [5, 6, 3, 4],
    2: [6, 5, 4, 3],
    3: [3, 3, 2, 1],
    4: [4, 4, 1, 2],
    5: [2, 1, 5, 5],
    6: [1, 2, 6, 6],
  };

  final rows = 2;

  Roll? parent;
  int? dir;

  int getScore() {
    int count1 = 0;
    for (var element in state) {
      if (element != 1) {
        count1++;
      }
    }
    return count1;
  }

  bool isEqual(List<int> other) => state.toString() == other.toString();

  bool isGoalState(List<int> goalState) {
    return isCountReached(5) || isEqual(goalState);
  }

  bool isCountReached(int targetCount) {
    final list = List.from(state);
    int count = 0;
    for (int number in list) {
      if (number == 1) count++;
      if (count >= targetCount) {
        return true;
      }
    }

    return false;
  }

  //
  List<int> canFlipDirections() {
    List<int> res = [];

    List<int> newState = List.from(state);
    List<List<int>> temp1 = List.generate(3, (i) => newState.sublist(i * 2, (i + 1) * 2));
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 2; j++) {
        if (temp1[i][j] == 0) {
          m = i;
          n = j;
          break;
        }
      }
    }

    if (m - 1 >= 0) res.add(0);
    if (m + 1 < 3) res.add(1);
    if (n - 1 >= 0) res.add(2);
    if (n + 1 < 2) res.add(3);

    return res;
  }

  // 交换后获取新的状态
  List<int> flip(int dir) {
    List<int> newState = List.from(state);
    List<List<int>> temp1 = List.generate(3, (i) => newState.sublist(i * 2, (i + 1) * 2));

    // ↑
    if (dir == 0) {
      final val = temp1[m - 1][n];
      temp1[m][n] = regular[val]![1];
      temp1[m - 1][n] = 0;
    }

    // ↓
    if (dir == 1) {
      final val = temp1[m + 1][n];
      temp1[m][n] = regular[val]![0];
      temp1[m + 1][n] = 0;
    }

    // ←
    if (dir == 2) {
      final val = temp1[m][n - 1];
      temp1[m][n] = regular[val]![3];
      temp1[m][n - 1] = 0;
    }

    // →
    if (dir == 3) {
      final val = temp1[m][n + 1];
      temp1[m][n] = regular[val]![2];
      temp1[m][n + 1] = 0;
    }

    return temp1.expand((element) => element).toList();
  }
}

List<int> sol(List<int> initialState, List<int> goalState) {
  Stopwatch watch = Stopwatch();
  watch.start();

  List<int> path = [];
  Roll roll = Roll(initialState);
  if (roll.isGoalState(goalState)) return path;

  List<Roll> openQueue = [roll]; //搜索队列
  Set<String> closeQueen = {}; //速度更快
  while (openQueue.isNotEmpty) {
    if (watch.elapsedMilliseconds >= 10000) return path;
    roll = openQueue.removeAt(0);
    if (closeQueen.contains(roll.state.toString())) continue;
    closeQueen.add(roll.state.toString());
    final allCanFlipDirs = roll.canFlipDirections();
    for (var dir in allCanFlipDirs) {
      Roll child = Roll(roll.flip(dir));
      child.parent = roll;
      child.dir = dir;
      if (child.isGoalState(goalState)) {
        while (child.parent != null) {
          path.add(child.dir!);
          child = child.parent!;
        }
        watch.stop();
        print("time : ${watch.elapsedMilliseconds / 1000}s   长度：${path.length}");
        return path.reversed.toList();
      }
      if (closeQueen.contains(child.state.toString())) continue;
      // openQueue.add(child);
      insertSort(openQueue, child); //速度更快
      // queue.sort((a, b) => b.score.compareTo(a.score));
    }
  }

  return path;
}

void insertSort(List<Roll> list, Roll roll) {
  int left = 0, right = list.length;
  while (left < right) {
    int mid = left + (right - left) ~/ 2;
    if (list[mid].score <= roll.score) {
      left = mid + 1;
    } else {
      right = mid;
    }
  }
  list.insert(left, roll);
}
