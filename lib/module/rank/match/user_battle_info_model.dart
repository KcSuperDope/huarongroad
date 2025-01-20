class UserBattleInfoModel {
  String? name;
  String? avatar;
  String? birthday;
  String? country;
  String? province;
  String? city;
  int? relationType;
  int? sex;
  int? weekTotalBattleNum;
  int? weekTotalBattleWinNum;

  UserBattleInfoModel(
      {this.name,
      this.avatar,
      this.birthday,
      this.country,
      this.province,
      this.city,
      this.relationType,
      this.sex,
      this.weekTotalBattleNum,
      this.weekTotalBattleWinNum});

  UserBattleInfoModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatar = json['avatar'];
    birthday = json['birthday'];
    country = json['country'];
    province = json['province'];
    city = json['city'];
    relationType = json['relation_type'];
    sex = json['sex'];
    weekTotalBattleNum = json['week_total_battle_num'];
    weekTotalBattleWinNum = json['week_total_battle_win_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['avatar'] = avatar;
    data['birthday'] = birthday;
    data['country'] = country;
    data['province'] = province;
    data['city'] = city;
    data['relation_type'] = relationType;
    data['sex'] = sex;
    data['week_total_battle_num'] = weekTotalBattleNum;
    data['week_total_battle_win_num'] = weekTotalBattleWinNum;
    return data;
  }
}
