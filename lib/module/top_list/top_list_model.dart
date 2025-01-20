import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/styles/styles.dart';

class TopListModel {
  final rank = 0.obs;
  final step = 0.obs;
  final duration = 0.obs;
  String? appUserId;
  String? avatar;
  String? nickname;
  Color? shadowColor;

  TopListModel({
    this.appUserId,
    this.avatar,
    this.nickname,
  });

  TopListModel.fromJson(Map<String, dynamic> json) {
    rank.value = json['rank'];
    step.value = json['step'];
    duration.value = json['duration'];
    appUserId = json['appUserId'];
    avatar = json['avatar'];
    nickname = json['nickname'];
    if (rank.value == 1) {
      shadowColor = color_FBDB68;
    } else if (rank.value == 2) {
      shadowColor = color_B0CDD4;
    } else if (rank.value == 3) {
      shadowColor = color_E4B1A4;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['step'] = step;
    data['duration'] = duration;
    data['appUserId'] = appUserId;
    data['avatar'] = avatar;
    data['nickname'] = nickname;
    return data;
  }
}

class SeasonModel {
  int index;
  String title;

  SeasonModel({required this.index, required this.title});
}
