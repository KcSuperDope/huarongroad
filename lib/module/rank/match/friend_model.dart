import 'package:get/get.dart';

class FriendModel {
  int? id;
  String? mainId;
  String? subId;
  int? type;
  String? applyMsg;
  String? relationTime;
  int? toppingTime;
  String? gmtCreate;
  String? gmtModified;
  int? userId;
  String? nickName;
  String? avatar;
  int? onLineStatus;
  var inviting = RxBool(false);
  var count = RxInt(30);

  FriendModel(
      {this.id,
      this.mainId,
      this.subId,
      this.type,
      this.applyMsg,
      this.relationTime,
      this.toppingTime,
      this.gmtCreate,
      this.gmtModified,
      this.userId,
      this.nickName,
      this.avatar,
      this.onLineStatus});

  FriendModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainId = json['mainId'];
    subId = json['subId'];
    type = json['type'];
    applyMsg = json['applyMsg'];
    relationTime = json['relationTime'];
    toppingTime = json['toppingTime'];
    gmtCreate = json['gmtCreate'];
    gmtModified = json['gmtModified'];
    userId = json['userId'];
    nickName = json['nickName'];
    avatar = json['avatar'];
    onLineStatus = json['onLineStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mainId'] = mainId;
    data['subId'] = subId;
    data['type'] = type;
    data['applyMsg'] = applyMsg;
    data['relationTime'] = relationTime;
    data['toppingTime'] = toppingTime;
    data['gmtCreate'] = gmtCreate;
    data['gmtModified'] = gmtModified;
    data['userId'] = userId;
    data['nickName'] = nickName;
    data['avatar'] = avatar;
    data['onLineStatus'] = onLineStatus;
    return data;
  }
}
