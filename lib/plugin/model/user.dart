class User {
  String? userId;
  String? nickName;
  String? avatar;
  String? token;
  String? mainId;
  int? level;
  int? regTime;
  int? unionUserId;

  User({this.userId, this.nickName, this.avatar, this.token, this.mainId, this.level});

  User.fromJson(dynamic json) {
    mainId = json['mainId'];
    userId = json['userId'];
    nickName = json['nickName'];
    avatar = json['avatar'];
    token = json['token'];
    regTime = json['regTime'];
    unionUserId = json['unionUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['mainId'] = mainId;
    data['userId'] = userId;
    data['nickName'] = nickName;
    data['avatar'] = avatar;
    data['regTime'] = regTime;
    data['unionUserId'] = unionUserId;
    return data;
  }
}
