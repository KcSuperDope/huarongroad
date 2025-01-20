import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/module/top_list/top_list_model.dart';
import 'package:huaroad/net/http/dio_method.dart';
import 'package:huaroad/net/http/dio_util.dart';
import 'package:huaroad/net/http/urls.dart';
import 'package:huaroad/util/logger.dart';

class TopListRepository {
  static Future<List<SeasonModel>> getPeriod() async {
    const url = Urls.get_period;
    try {
      dynamic result = await DioUtil().request(url, method: DioMethod.post);
      final first = result["data"]["first"];
      final current = result["data"]["current"];
      final list = handlePeriod(first, current);
      LogUtil.d(list);
      return list;
    } catch (e) {
      LogUtil.d(e);
      rethrow;
    }
  }

  static List<SeasonModel> handlePeriod(String first, int current) {
    List<SeasonModel> seasonList = [];
    DateTime startTime = DateTime.parse(first);
    if (startTime.weekday != 1) {
      startTime = startTime.subtract(Duration(days: startTime.weekday - 1));
    }
    const startDuration = Duration(days: 7);
    const endDuration = Duration(days: 6, hours: 23, minutes: 59, seconds: 59);
    for (int i = 1; i <= current; i++) {
      final startDate = startTime.add(startDuration * (i - 1));
      final endDate = startDate.add(endDuration);
      final timeTitle = "${startDate.toString().substring(0, 10)} ~ ${endDate.toString().substring(0, 10)}";
      SeasonModel model = SeasonModel(index: i, title: timeTitle);
      seasonList.add(model);
    }
    if (seasonList.isNotEmpty) {
      seasonList.last.title = "${seasonList.last.title}(${S.Thisweek.tr})";
    }
    return seasonList;
  }

  static Future<Map<String, dynamic>> getTopList(int period, int classicResidenceId) async {
    const url = Urls.get_top_list;
    try {
      final Map<String, dynamic> params = <String, dynamic>{};
      params['period'] = period;
      params['classicResidenceId'] = classicResidenceId;
      params['appId'] = 2;
      params['appUserId'] = Global.userId;
      Map<String, dynamic> result = await DioUtil().request(url, method: DioMethod.post, data: params);
      return result["data"];
    } catch (e) {
      LogUtil.d(e);
      rethrow;
    }
  }
}
