import 'package:flutter/material.dart';
import 'package:flutter_app/plugin.dart';
import 'package:tile/LayerChess.dart';
import 'package:tile/tile.dart';
import 'package:tile/util/SgfHelper.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp>{
  GlobalKey<LayerChessState> keyChess = GlobalKey();

  void _actionRegret() {
    print('_actionRegret');
    keyChess.currentState.regret(2);
  }

  void _actionShowNum() {
    print('_actionShowNum');
    if(keyChess.currentState.tileNum == TileNum.all)
      keyChess.currentState.tileNum = TileNum.end;
    else
      keyChess.currentState.tileNum = TileNum.all;
  }

  void _actionStartGame(){
    print('_actionStartGame');
    Plugin().startGame().then((result){
      print("result StartGame");
    });
  }


  void _tileListener([Object obj1,Object obj2,Object obj3]) async{
    print('_tileListener');
    String lastStep = SgfHelper.getBoardlastStr(keyChess.currentState.widget.board);

//    String result = await Plugin().getRobotChess(lastStep);
//    print("result:$result");
//    keyChess.currentState.showSteps(result);

    Plugin().getRobotChess(lastStep).then((result){
      print("result:$result");
      keyChess.currentState.showSteps(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
          padding: EdgeInsets.only(top: 30),
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: <Widget>[
              TileView(
                keyChess: keyChess,
                boardSize: 9,
                tileListener: _tileListener,
              ),
              Container(
                padding: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      key: Key("btnRegret"),
                      onPressed: _actionRegret,
                      child: Text("悔棋"),
                    ),
                    RaisedButton(
                      onPressed: _actionShowNum,
                      child: Text("手顺"),
                    ),
                    RaisedButton(
                      onPressed: _actionStartGame,
                      child: Text("开始游戏"),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

}
