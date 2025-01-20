import 'package:huaroad/global.dart';
import 'package:huaroad/module/game/game.dart';

mixin DbJson on Game {
  /// 游戏历史记录
  Map<String, dynamic> toDBJson() {
    final Map<String, dynamic> data = {};
    data["user_id"] = Global.userId;
    data["time"] = startTime;
    data["duration"] = getTotalTime();
    data["steps"] = history.getHistoryString();
    data["opening"] = opening;
    data["mode"] = mode.value.index;
    data["type"] = type.value.index;
    data["state"] = state.value.index;
    data["title"] = title.value;
    data["isConnect"] = isConnected.value ? 1 : 0;
    return data;
  }

  /// 用户的闯关数据
  ///
  ///  l_index : 游戏编号
  ///  starNum : 星星数量
  ///  type : hrd or num
  ///  userId 当前用户
  Map<String, dynamic> toDBLevelJson() {
    final Map<String, dynamic> data = {};
    data["user_id"] = Global.userId;
    data["l_index"] = index;
    data["starNum"] = starNum.toString();
    data["type"] = type.value.index;
    return data;
  }

  /// 用户的名局数据
  ///
  ///  time : 时间
  ///  耗时 int 毫秒
  ///  type : hrd or num
  ///  userId 当前用户
  ///  openning
  ///  step_length
  Map<String, dynamic> toDBSpecialJson() {
    final Map<String, dynamic> data = {};
    data["user_id"] = Global.userId;
    data["time"] = startTime;
    data["duration"] = getTotalTime();
    data["step_length"] = history.totalCount.value;
    data["opening"] = opening;
    data["type"] = type.value.index;
    return data;
  }

  Map<String, dynamic> toNetJson() {
    return {
      "stageId": id,
      "star": starNum.value,
      "time": state.value == GameState.success ? getTotalTime() : 0,
      "step": history.totalCount.value,
      "startTime": startTime,
      "opening": opening,
      "review": state.value == GameState.success ? history.getHistoryString() : "",
      "device": isConnected.value ? 1 : 0,
      "result": state.value == GameState.success ? 0 : 1,
    };
  }
}
