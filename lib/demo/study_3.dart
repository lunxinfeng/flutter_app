import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 平台通道
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Page1(),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PluginChannel.listenBasicMessage();
    PluginChannel.listenMethod();
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              PluginChannel.sendBasicMessage();
            },
            child: Text("BasicMessageChannel"),
          ),
          RaisedButton(
            onPressed: () {
              PluginChannel.invokeMethod();
            },
            child: Text("MethodChannel"),
          ),
          RaisedButton(
            onPressed: () {
              PluginChannel.event();
            },
            child: Text("EventChannel"),
          )
        ],
      ),
    );
  }
}

class PluginChannel {
  static const _basicMessageChannelName = "study_3/basicMessageChannel";
  static const _basicMessageChannel =
      BasicMessageChannel(_basicMessageChannelName, StandardMessageCodec());

  static const _methodChannelName = "study_3/methodChannel";
  static const _methodChannel = MethodChannel(_methodChannelName);

  static const _eventChannelName = "study_3/eventChannel";
  static const _eventChannel = EventChannel(_eventChannelName);

  static void listenBasicMessage() {
    _basicMessageChannel.setMessageHandler((result) async {
      print('flutter listen:$result');
      return "flutter response to native";
    });
  }

  static void sendBasicMessage() {
    _basicMessageChannel.send("flutter send to native").then((result) {
      print('flutter receive response:$result');
    });
  }

  static void invokeMethod() {
    _methodChannel.invokeMethod("getAge", {"name": "lili"}).then((result) {
      print('flutter receive response:$result');
    });
  }

  static void listenMethod() {
    _methodChannel.setMethodCallHandler((methodCall) async {
      print('flutter listen:$methodCall');
      return "男";
    });
  }

  static void event() {
    _eventChannel.receiveBroadcastStream("event arg")
        .listen((result) {
      print('flutter listen:$result');
    });
  }
}
