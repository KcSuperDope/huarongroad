import 'package:huaroad/net/env/gateway.dart';
import 'package:huaroad/net/http/dio_method.dart';
import 'package:huaroad/net/http/dio_util.dart';
import 'package:huaroad/net/http/urls.dart';
import 'package:huaroad/util/logger.dart';

class ApplicationRepo {
  static Future<List<BannerModel>> getBanner() async {
    try {
      final res = await DioUtil().request(GateWay.sns + Urls.get_banner, method: DioMethod.get);
      final data = res["data"] as List;
      return data.map((e) => BannerModel.fromJson(e)).toList();
    } catch (e) {
      LogUtil.d(e.toString());
    }
    return [];
  }

  static reportBannerShow(int id) async {
    await DioUtil().request(
        GateWay.sns +
            Urls.get_user_action_banner
                .replaceAll(RegExp(r'{id}'), id.toString())
                .replaceAll(RegExp(r'{action}'), "view"),
        method: DioMethod.get);
  }

  static reportBannerClick(int id) async {
    await DioUtil().request(
        GateWay.sns +
            Urls.get_user_action_banner
                .replaceAll(RegExp(r'{id}'), id.toString())
                .replaceAll(RegExp(r'{action}'), "click"),
        method: DioMethod.get);
  }
}

class BannerModel {
  int? id;
  String? title;
  String? tag;
  String? image;
  String? jumpType;
  String? jumpContent;
  int? sort;
  bool? isUse;
  String? language;

  BannerModel({
    this.id,
    this.title,
    this.tag,
    this.image,
    this.jumpType,
    this.jumpContent,
    this.sort,
    this.isUse,
    this.language,
  });

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    tag = json['tag'];
    image = json['image'];
    jumpType = json['jump_type'];
    jumpContent = json['jump_content'];
    sort = json['sort'];
    isUse = json['is_use'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['tag'] = tag;
    data['image'] = image;
    data['jump_type'] = jumpType;
    data['jump_content'] = jumpContent;
    data['sort'] = sort;
    data['is_use'] = isUse;
    data['language'] = language;
    return data;
  }
}
