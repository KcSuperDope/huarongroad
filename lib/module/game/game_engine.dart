import 'dart:math';

class GameEngine {
  static GameEngine? _instance;

  GameEngine._internal() {
    _instance = this;
  }

  factory GameEngine() => _instance ?? GameEngine._internal();

  // 生成初始矩阵
  String generalInitMatrix(int rowNum, int colNum) {
    List<int> list = List.generate(rowNum * colNum - 1, (index) => index + 1);
    do {
      list.shuffle(Random(DateTime.now().hashCode));
    } while (!GameEngine().hasSolution(list));
    list.add(0);
    String initMatrixString = list.join(" ");
    return initMatrixString;
  }

  /// 数字华容道，必然有解，只存在于如下3个细分情形：
  /// 若格子列数为奇数，则逆序数必须为偶数；
  /// 若格子列数为偶数，且逆序数为偶数，则当前空格所在行数与初始空格所在行数的差为偶数；
  /// 若格子列数为偶数，且逆序数为奇数，则当前空格所在行数与初始空格所在行数的差为奇数。
  bool hasSolution(List<int> list) {
    final num = calculateInverseNumbers(list);
    return num % 2 == 0;
  }

  // 开局条件，计算逆序数
  int calculateInverseNumbers(List<int> list) {
    List<int> l = List.from(list);
    l.removeWhere((element) => element == 0);
    if (l.isNotEmpty) {
      int num = inversePairs(l, 0, l.length - 1);
      return num;
    }
    return -1;
  }

  int inversePairs(List<int> array, int start, int end) {
    int result = 0;
    if (start < end) {
      int mid = ((start + end) / 2).floor();
      result += inversePairs(array, start, mid);
      result += inversePairs(array, mid + 1, end);
      result += merge(array, start, mid, end);
    }
    return result;
  }

  int merge(List<int> array, int start, int mid, int end) {
    int i = start;
    int j = mid + 1;
    int k = 0;
    List<int> temp = [];

    temp = List.filled(end - start + 1, 0);
    int result = 0;
    while (i <= mid && j <= end) {
      if (array[i] > array[j]) {
        result += (end - j + 1);
        temp[k++] = array[i++];
      } else {
        temp[k++] = array[j++];
      }
    }
    while (i <= mid) {
      temp[k++] = array[i++];
    }
    while (j <= end) {
      temp[k++] = array[j++];
    }
    for (int m = start; m <= end; m++) {
      array[m] = temp[m - start];
    }
    return result;
  }
}
