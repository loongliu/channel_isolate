import 'dart:async';
import 'dart:isolate';

import 'package:channel_isolate/src/isolate_method_channel.dart';

typedef PortEventHandler = void Function(dynamic data);

typedef UnregisterHandlerCallback = void Function();

class ChannelIsolate {
  static Future<Isolate> spawn<T>(void entryPoint(T message), T message,
      {bool paused: false,
      bool errorsAreFatal,
      SendPort onExit,
      SendPort onError,
      String debugName}) {
    SendPort sendPort = mainPort;
    if (mainPort == null) {
      IsolateMethodChannel.registerMethodChannelHandler();
      ReceivePort receivePort = new ReceivePort();
      receivePort.listen((data) {
        _handlers.forEach((handler) {
          handler(data);
        });
      });
      sendPort = receivePort.sendPort;
    }
    assert(sendPort != null);
    // var argument = _EntranceArgument(entryPoint, message, sendPort);
    return Isolate.spawn(_entryPoint, [entryPoint, message, sendPort]);
  }

  /// Main isolate's sendPort, set when isolate is spawned.
  /// null for main isolate.
  static SendPort mainPort;

  /// Whether in main isolate.
  static bool get isMainIsolate => mainPort == null;

  /// Register a handler for event from other isolate.
  /// You should only call this method in main isolate.
  /// Return a unregister callback if register action succeeds.
  static UnregisterHandlerCallback registerHandler(PortEventHandler handler) {
    if (_handlers.contains(handler)) {
      return null;
    }
    _handlers.add(handler);
    return () {
      _handlers.remove(handler);
    };
  }

  static List<PortEventHandler> _handlers = List();

  static void _entryPoint<T>(Object arg) {
    assert(arg != null);
    assert(arg is List && arg.length >= 2);
    if (arg is List) {
      mainPort = arg[2];
      arg[0].call(arg[1]);
    }
  }
}
