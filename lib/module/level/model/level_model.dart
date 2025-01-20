import 'package:get/get.dart';
import 'package:huaroad/module/game/game.dart';

class LevelTreeModel {
  String bgName = "";
  String cartoonName = "";
  bool showCartoon = false;
  bool isLastBottom = false;
  bool isEnd = false;
  bool isBoss = false;
  double height = 0.0;
  List<LevelItemModel> items = [];

  LevelTreeModel();
}

class LevelItemModel {
  int index = 0;
  int hardLevel = 0;
  String opening = "";
  bool empty = false;
  bool isBoss = false;
  bool isLevelLast = false;
  final starNum = 0.obs;
  GameType type = GameType.hrd;
  double height = 80;
  double width = 80;
  String pngName = "lib/assets/png/level/level_item_bg.png";

  LevelItemModel();
}
