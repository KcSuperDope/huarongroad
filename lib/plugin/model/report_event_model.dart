class EventId {
  ///页面交互数据
  static const int pageInteraction = 2001;

  ///棋局埋点
  static const int game = 2002;

  ///设备埋点
  static const int device = 2005;
}

class ReportEventModel {
  int? eventId;
  PageInteractionEvent? pageInteractionEvent;
  GameEvent? gameEvent;
  DeviceEvent? deviceEvent;

  ReportEventModel({this.eventId, this.pageInteractionEvent, this.gameEvent, this.deviceEvent});

  ReportEventModel.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    pageInteractionEvent =
        json['eventData'] != null ? PageInteractionEvent.fromJson(json['eventData']) : null;
    gameEvent = json['eventData'] != null ? GameEvent.fromJson(json['eventData']) : null;
    deviceEvent = json['eventData'] != null ? DeviceEvent.fromJson(json['eventData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventId'] = eventId;
    if (pageInteractionEvent != null) {
      data['eventData'] = pageInteractionEvent!.toJson();
    }
    if (gameEvent != null) {
      data['eventData'] = gameEvent!.toJson();
    }
    if (deviceEvent != null) {
      data['eventData'] = deviceEvent!.toJson();
    }
    return data;
  }
}

class PageInteractionEvent {
  int? pageId;
  int? interactionId;

  PageInteractionEvent({this.pageId, this.interactionId});

  PageInteractionEvent.fromJson(Map<String, dynamic> json) {
    pageId = json['pageId'];
    interactionId = json['interactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageId'] = pageId;
    data['interactionId'] = interactionId;
    return data;
  }
}

class GameEvent {
  int? categoryId;
  int? subApplicationId;
  int? connectStatus;
  int? gameStatus;
  int? duration;
  int? step;
  String? gameId;
  int? level;

  GameEvent(
      {this.categoryId,
      this.subApplicationId,
      this.connectStatus,
      this.gameStatus,
      this.duration = 0,
      this.step = 0,
      this.gameId = '',
      this.level});

  GameEvent.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    subApplicationId = json['subApplicationId'];
    connectStatus = json['connectStatus'];
    gameStatus = json['gameStatus'];
    duration = json['duration'];
    step = json['step'];
    gameId = json['gameId'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryId'] = categoryId;
    data['subApplicationId'] = subApplicationId;
    data['connectStatus'] = connectStatus;
    data['gameStatus'] = gameStatus;
    data['duration'] = duration;
    data['step'] = step;
    data['gameId'] = gameId;
    data['level'] = level;
    return data;
  }
}

class DeviceEvent {
  int? deviceType;
  String? deviceModel;
  String? deviceName;
  int? batteryPower;
  String? deviceMac;
  String? deviceVersion;
  int? connectState;
  int? rssi;

  DeviceEvent({
    this.deviceType = 4,
    this.deviceModel = 'Swift-B-0001',
    this.deviceName,
    this.batteryPower,
    this.deviceMac,
    this.deviceVersion,
    this.connectState,
    this.rssi,
  });

  DeviceEvent.fromJson(Map<String, dynamic> json) {
    deviceType = json['cDeviceType'];
    deviceModel = json['cDeviceModel'];
    deviceName = json['cDeviceName'];
    batteryPower = json['batteryPower'];
    deviceMac = json['cDeviceMac'];
    deviceVersion = json['cDeviceVersion'];
    connectState = json['connectState'];
    rssi = json['rsi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cDeviceType'] = deviceType;
    data['cDeviceModel'] = deviceModel;
    data['cDeviceName'] = deviceName;
    data['batteryPower'] = batteryPower;
    data['cDeviceMac'] = deviceMac;
    data['cDeviceVersion'] = deviceVersion;
    data['connectState'] = connectState;
    data['rsi'] = rssi;
    return data;
  }
}
