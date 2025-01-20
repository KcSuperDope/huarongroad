import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class DeviceConnectedEvent {
  bool isConnected;

  DeviceConnectedEvent(this.isConnected);
}

class ScreenStatusEvent {
  bool isOn;

  ScreenStatusEvent(this.isOn);
}

class AppTabbarIndexChangeEvent {
  int index;

  AppTabbarIndexChangeEvent(this.index);
}
