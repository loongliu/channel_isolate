package com.example.example;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

public class DemoChannel implements MethodCallHandler {
    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel methodChannel = new MethodChannel(registrar.messenger(), "me.liujilong.demo");
        final DemoChannel instance = new DemoChannel(registrar);
        methodChannel.setMethodCallHandler(instance);
    }

    DemoChannel(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
    }

    private final PluginRegistry.Registrar registrar;

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("sayHi")) {
            result.success("Hi");
        } else {
            result.notImplemented();
        }
    }
}