class ProtoId {
  ///心跳包
  static const int c2s_heartbeat = 10001;

  static const int s2c_heartbeat = 10002;

  ///身份验证c2s
  static const int c2s_auth = 10007;

  ///身份验证s2c
  static const int s2c_auth = 10008;

  ///开始战斗推送
  static const int s2c_battle_start = 20001;

  ///用户战斗状态变化
  static const int s2c_battle_status = 20002;

  ///战斗倒计时
  static const int s2c_battle_countdown = 20003;

  ///战斗结果
  static const int s2c_battle_result = 20004;

  ///匹配成功
  static const int s2c_match_suc = 20005;

  ///匹配成功后对方就绪取消
  static const int s2c_match_exit = 20006;

  ///好友接受邀请进入房间推送
  static const int s2c_battle_room_enter = 20008;

  ///好友拒绝邀请推送
  static const int s2c_battle_refuse = 20009;

  ///离开房间推送
  static const int s2c_battle_left = 20010;

  ///房间切换难度推送
  static const int s2c_battle_level = 20011;


  ///对战准备状态推送
  static const int s2c_battle_ready_state = 20012;
}
