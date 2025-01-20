import 'package:huaroad/plugin/model/user.dart';

class BattleInviteModel {
  User? player;
  int? roomId;
  int? type;
  int? level;
  bool? owner;
  bool? inviteSuccess;

  BattleInviteModel(
      {this.player,
      this.roomId,
      this.type,
      this.level,
      this.owner = true,
      this.inviteSuccess = false});

  BattleInviteModel.fromJson(dynamic json) {
    player = User();
    player?.userId = json['userId'];
    player?.avatar = json['avatar'];
    player?.nickName = json['nickName'];
    roomId = json['roomId'];
    type = json['type'];
    level = json['level'];
    owner = false;
    inviteSuccess = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['player'] = player?.toJson();
    data['roomId'] = roomId;
    data['type'] = type;
    data['level'] = level;
    return data;
  }
}
