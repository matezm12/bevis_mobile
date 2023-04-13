import 'package:event_bus/event_bus.dart';

class NotificationCenter {
  EventBus eventBus = new EventBus();

  static final NotificationCenter _singleton = new NotificationCenter._internal();

  static NotificationCenter shared() {
    return _singleton;
  }

  NotificationCenter._internal();

  factory NotificationCenter() {
    return _singleton;
  }
}