# channel_isolate

ChannelIsolate is a flutter project that enables method channel call in background isolate for flutter.
Purely implemented by Dart.

## Getting Started


#### Add a dependency in your flutter project 
    channel_isolate:
            git:
                url: 'https://github.com/loongliu/channel_isolate'

#### Replace your Isolate and ChannelMethod Implementation.

* Replace `Isolate.spawn(...)` with `ChannelIsolate.spawn(..)`
* Replace `MethodChannel("channel.name")` with `IsolateMethodChannel("channel.name");`;

#### You are done

Now you can call `invokeMethod()` in isolate created by `ChannelIsolate.spawn(..)`.

## TODO:
* Support `Isolate.spawnUri(...)`.
* Support `MethodChannel#invokeListMethod`.
* Support `MethodChannel#invokeMapMethod`
* Upload this project to https://pub.dev/.