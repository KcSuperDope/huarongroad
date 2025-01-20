import 'package:huaroad/global.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/level/level_hard_handler.dart';
import 'package:huaroad/net/http/dio_util.dart';
import 'package:huaroad/net/http/urls.dart';
import 'package:huaroad/util/logger.dart';

class LevelSyncHandler {
  static LevelSyncHandler? _instance;

  LevelSyncHandler._internal() {
    _instance = this;
  }

  factory LevelSyncHandler() => _instance ?? LevelSyncHandler._internal();

  void sync() {
    if (Global.getUserInfo() == null) return;
    Future.delayed(const Duration(milliseconds: 200), () {
      compareLevelProgress(gameType: GameType.hrd);
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      compareLevelProgress(gameType: GameType.number3x3);
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      compareLevelProgress(gameType: GameType.number4x4);
    });
  }

  /// 比对
  void compareLevelProgress({required GameType gameType}) async {
    await LevelHardHandler().update(type: gameType);
    final resLocal = LevelHardHandler().starNumList;
    final resNet = await syncLevelProgress(gameType: gameType);
    LogUtil.d("本地进度 ---> ${resLocal.length}", resLocal);
    LogUtil.d("服务器进度 ---> ${resNet.length}", resNet);

    /// 本地进度 > 服务器进度,上传最新进度
    if (resLocal.length > resNet.length) {
      LogUtil.d("上传本地进度");
      try {
        await uploadLevelProgress(gameType: gameType, stars: resLocal);
      } catch (e) {
        LogUtil.d("进度上传失败------>>>>", e);
      }
    }

    /// 本地进度 < 服务器进度,把最新进度插入记录
    if (resLocal.length < resNet.length) {
      LogUtil.d("插入服务器进度", resNet);

      LevelHardHandler().syncDeviceLevel(gameType: gameType, stars: resNet, updatePage: false);
    }
  }

  /// 获取闯关进度--服务器
  Future<List<dynamic>> syncLevelProgress({required GameType gameType}) async {
    final userId = Global.userId;
    final type = (gameType == GameType.hrd ? 1 : (gameType == GameType.number3x3 ? 2 : 3)); //type:1 华容道, 2 数字拼图
    final url = ((gameType == GameType.hrd) ? Urls.get_level : Urls.get_level_num);
    try {
      final result = await DioUtil().get(
        url.replaceAll(RegExp(r'{userId}'), userId).replaceAll(RegExp(r'{type}'), type.toString()),
      );
      return result["data"];
    } catch (e) {
      LogUtil.d(e);
      rethrow;
    }
  }

  Future<void> uploadLevelProgress({required GameType gameType, required List stars}) async {
    final userId = Global.userId;
    final type = (gameType == GameType.hrd ? 1 : (gameType == GameType.number3x3 ? 2 : 3)); //type:1 华容道, 2 数字拼图
    final url = ((gameType == GameType.hrd) ? Urls.post_level_sync : Urls.post_level_sync_num);
    try {
      await DioUtil().post(url, data: {"userId": userId, "type": type, "star": stars});
    } catch (e) {
      LogUtil.d(e);
      rethrow;
    }
  }
}
