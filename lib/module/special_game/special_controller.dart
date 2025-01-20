import 'package:get/get.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/special_game/specail_game_data.dart';

class SpecialController extends GetxController {
  Game game = Game();

  var games = SpecialGameData.list;

  @override
  void onInit() {
    super.onInit();
  }
}
