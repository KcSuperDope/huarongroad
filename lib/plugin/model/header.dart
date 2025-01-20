class Header {
  String? deviceId;
  String? appId;
  String? channel;
  String? osVersion;
  String? deviceModel;
  String? language;
  String? originLanguage;
  String? clientVersion;
  String? osType;
  String? brand;
  int? clientEventTime;
  int? regTime;
  int? unionUserId;
  int? networkType;
  String? env;
  String? token;

  Header(
      {this.deviceId,
      this.appId,
      this.channel,
      this.osVersion,
      this.deviceModel,
      this.language,
      this.originLanguage,
      this.clientVersion,
      this.osType,
      this.brand,
      this.clientEventTime,
      this.regTime,
      this.unionUserId,
      this.networkType,
      this.env,
      this.token});

  Header.fromJson(dynamic json) {
    deviceId = json['deviceId'];
    appId = json['appId'];
    channel = json['channel'];
    osVersion = json['osVersion'];
    deviceModel = json['deviceModel'];
    language = json['language'];
    originLanguage = json['originLanguage'];
    clientVersion = json['clientVersion'];
    osType = json['osType'];
    brand = json['brand'];
    networkType = json['networkType'];
    env = json['env'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceId'] = deviceId;
    data['appId'] = appId;
    data['channel'] = channel;
    data['osVersion'] = osVersion;
    data['deviceModel'] = deviceModel;
    data['language'] = language;
    data['originLanguage'] = originLanguage;
    data['clientVersion'] = clientVersion;
    data['osType'] = osType;
    data['brand'] = brand;
    data['clientEventTime'] = clientEventTime;
    data['regTime'] = regTime;
    data['unionUserId'] = unionUserId;
    data['networkType'] = networkType;
    data['token'] = token;
    return data;
  }
}
