import 'dart:isolate';

import 'package:flutter/material.dart';

import 'demo_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ChannelIsoalte Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String response;
  String isolateResponse;
  ReceivePort port = ReceivePort();

  @override
  void initState() {
    port.listen((data) {
      setState(() {
        isolateResponse = data.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Hello, ChannelIsolate.  ${response ?? ""}'),
            Text('Hello, Isolate.   ${isolateResponse ?? ""}'),
            FlatButton(
              child: Text("Isolate"),
              onPressed: () {
                print("onPressed");
                Isolate.spawn(entry, "1", onError: port.sendPort);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DemoChannel.sayHi().then((val) {
            setState(() {
              response = val;
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void entry(String params) {
  print("in entry");
  DemoChannel.sayHi().then((_) {
    print(_);
  });
  Future.delayed(Duration(seconds: 1)).then((_) {
    print("delayed");
  });
}
