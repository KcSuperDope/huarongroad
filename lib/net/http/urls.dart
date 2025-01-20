// ignore_for_file: constant_identifier_names

class Urls {
  /// 上传游戏
  static const String post_stage_sync = '/public/klocki/stage/syncStage';
  static const String post_stage_sync_num = '/public/klocki/stage/syncPuzzleStage';

  /// 游戏记录列表
  static const String get_record_list =
      '/public/klocki/stage/data/stageRecord/{userId}/{type}/{page}';
  static const String get_record_list_num =
      '/public/klocki/stage/data/puzzleRecord/{userId}/{type}/{page}';

  /// 游戏复盘数据
  static const String get_record_detail = '/public/klocki/user/data/lookReview/{reviewId}';

  /// 上传进度
  static const String post_level_sync = '/public/klocki/stage/syncAdvance';
  static const String post_level_sync_num = '/public/klocki/stage/syncPuzzleAdvance';

  ///我的游戏进度
  static const String get_level = '/public/klocki/stage/data/stageData/{userId}/{type}';
  static const String get_level_num = '/public/klocki/stage/data/stagePuzzleData/{userId}/{type}';

  ///排行榜
  static const String get_period = '/api/rank/classicResidence/currentPeriod';
  static const String get_top_list = '/api/rank/classicResidence/query';

  ///用户行为
  static const String get_user_action_banner = '/ad-banner/add-count?id={id}&action={action}';
  static const String get_banner = '/ad-banner/index';

  ///双人对战
  ///开始匹配
  static const String POST_BATTLE_MATCH = '/public/klocki/battle/match';

  ///退出匹配
  static const String POST_BATTLE_QUIT_MATCH = '/public/klocki/battle/quitMatch';

  ///匹配成功后的准备就绪
  static const String POST_BATTLE_READY = '/public/klocki/battle/ready';

  ///获取好友列表
  static const String POST_BATTLE_FRIEND_LIST = '/api/im/friend/list';

  ///申请好友
  static const String POST_BATTLE_FRIEND_APPLY = '/api/im/friend/apply';

  ///邀请好友
  static const String POST_BATTLE_INVITE_FRIEND = '/public/klocki/battle/process/invite';

  ///中途退出比赛
  static const String POST_BATTLE_EXIT = '/public/klocki/battle/process/exitBattle';

  ///摆放完成确定,开始观察
  static const String POST_BATTLE_START_OBSERVE = '/public/klocki/battle/process/startObserve';

  ///观察完成，开始复原
  static const String POST_BATTLE_START_RECOVER = '/public/klocki/battle/process/startRecover';

  ///复原完成
  static const String POST_BATTLE_END_RECOVER = '/public/klocki/battle/process/endRecover';

  ///主动离开房间
  static const String POST_BATTLE_LEFT_ROOM = '/public/klocki/battle/process/leftRoom';

  ///请求其他用户离开房间
  static const String POST_BATTLE_KICK = '/public/klocki/battle/process/kick';

  ///开始对战
  static const String POST_BATTLE_START = '/public/klocki/battle/process/startRoomBattle';

  ///切换难度
  static const String POST_BATTLE_CHANGE_LEVEL = '/public/klocki/battle/process/changeLevel';

  ///中途比赛超时失败
  static const String POST_BATTLE_FAIL = '/public/klocki/battle/process/failBattle';

  ///对战记录
  static const String POST_BATTLE_RECORD =
      '/public/klocki/battle/process/battleRecord/{userId}/{type}/{page}';

  ///被邀请者做准备
  static const String POST_BATTLE_DOREADY = '/v1/wislide_battle/DoReady';

  ///获取对战用户信息和胜率
  static const String GET_BATTLE_USERINFO =
      '/v1/wislide_battle/GetUserBattleInfo/{app_user_id}/{level}';

  ///上报对战胜负结果
  static const String POST_BATTLE_RESULT = '/v1/wislide_battle/ReportUserBattleInfo';
}
