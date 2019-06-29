import 'package:flutter/services.dart';

MethodChannel _channel = MethodChannel("me.liujilong.demo");

class DemoChannel {
  DemoChannel._();

  static Future<String> sayHi() {
    print("sayHi");
    return _channel.invokeMethod<String>("sayHi");
  }
}
