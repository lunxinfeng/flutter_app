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
  bool boardUnlock = false;
  ///棋盘id
  GlobalKey<LayerChessState> _keyChess = GlobalKey();
  bool _btnRegretEnabled = false;
  bool _btnShowNumEnabled = true;
  bool _btnStartGameEnabled = true;
  String hint = "";


  void _actionRegret() {
    print('_actionRegret');
    if(_keyChess.currentState.board.getCount() < 2) return;
    _keyChess.currentState.regret(2);
    Plugin().aiRegret();
  }

  void _actionShowNum() {
    print('_actionShowNum');
    if(_keyChess.currentState.tileNum == TileNum.all)
      _keyChess.currentState.tileNum = TileNum.end;
    else
      _keyChess.currentState.tileNum = TileNum.all;
  }

  void _actionStartGame(){
    print('_actionStartGame');
    Plugin().startGame().then((result){
      print("result StartGame");
      setState(() {
        boardUnlock = true;
        _btnStartGameEnabled = false;
      });
    });
  }


  void _tileListener([Object obj1,Object obj2,Object obj3]) async{
    print('_tileListener');
    setState(() {
      boardUnlock = false;
      _btnRegretEnabled = false;
    });
    String lastStep = SgfHelper.getBoardlastStr(_keyChess.currentState.board);

    Plugin().getRobotChess(lastStep).then((result){
      print("result:$result");
      setState(() {
        hint = result;
        boardUnlock = true;
        _btnRegretEnabled = true;
      });
      _keyChess.currentState.showSteps(result);
    });
    print('_tileListener end');
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
                keyChess: _keyChess,
                boardSize: 9,
                boardUnlock: boardUnlock,
                tileListener: _tileListener,
              ),
              Container(
                padding: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildButtonRegret(),
                    _buildButtonShowNum(),
                    _buildButtonStartGame()
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                    hint
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildButtonRegret(){
    return RaisedButton(
      onPressed: _btnRegretEnabled?_actionRegret:null,
      child: Text("悔棋"),
    );
  }

  Widget _buildButtonShowNum(){
    return RaisedButton(
      onPressed: _btnShowNumEnabled?_actionShowNum:null,
      child: Text("手顺"),
    );
  }

  Widget _buildButtonStartGame(){
    return RaisedButton(
      onPressed: _btnStartGameEnabled?_actionStartGame:null,
      child: Text("开始游戏"),
    );
  }
}
