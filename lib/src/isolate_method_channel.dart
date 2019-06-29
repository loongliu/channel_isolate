import 'dart:async';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:channel_isolate/src/isolate.dart';

class IsolateMethodChannel extends MethodChannel {
  const IsolateMethodChannel(String name,
      [MethodCodec codec = const StandardMethodCodec()])
      : super(name, codec);

  Future<T> invokeMethod<T>(String method, [dynamic arguments]) async {
    if (ChannelIsolate.isMainIsolate) {
      return super.invokeMethod(method, arguments);
    }
    Completer<T> completer = Completer();
    ReceivePort port = ReceivePort();
    port.listen((data) {
      completer.complete(data);
    });
    _ChannelArgument arg = _ChannelArgument(
      method,
      arguments,
      port.sendPort,
      this,
    );
    ChannelIsolate.mainPort.send(arg);
    return completer.future;
  }

  static void _handleChannelArgument(dynamic arg) {
    if (arg is _ChannelArgument) {
      Future future = arg.channel.invokeMethod(arg.method, arg.arguments);
      future.then((data) {
        arg.sendPort.send(data);
      });
    }
  }

  static void registerMethodChannelHandler() {
    ChannelIsolate.registerHandler(_handleChannelArgument);
  }
}

class _ChannelArgument {
  final String method;
  final dynamic arguments;
  final SendPort sendPort;
  final MethodChannel channel;
  _ChannelArgument(this.method, this.arguments, this.sendPort, this.channel);
}
