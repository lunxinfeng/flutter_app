import 'package:flutter/material.dart';
import 'package:tile/LayerChess.dart';
import 'package:tile/tile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  GlobalKey<LayerChessState> keyChess = GlobalKey();
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
                tileListener: _tileListener,
              ),
              Container(
                padding: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: _actionRegret,
                      child: Text("悔棋"),
                    ),
                    RaisedButton(
                      onPressed: _actionShowNum,
                      child: Text("手顺"),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  void _actionRegret() {
    print('_actionRegret');
    keyChess.currentState.regret(1);
  }

  void _actionShowNum() {
    print('_actionShowNum');
    if(keyChess.currentState.tileNum == TileNum.all)
      keyChess.currentState.tileNum = TileNum.end;
    else
      keyChess.currentState.tileNum = TileNum.all;
  }

  void _tileListener([Object obj1,Object obj2,Object obj3]){
    print('_tileListener');
  }
}
