import 'package:flutter/services.dart';

class Plugin{
  //flutter 调用 native
  static const MethodChannel _methodChannel = MethodChannel("com.lxf.plugin/robot");

  Future<String> getRobotChess(String lastStep) async{
    String result = await _methodChannel.invokeMethod("getRobotChess",lastStep);
    return result;
  }

  Future<void> startGame() async{
    await _methodChannel.invokeMethod("startGame");
  }

  Future<void> aiRegret() async{
    await _methodChannel.invokeMethod("aiRegret");
  }
}