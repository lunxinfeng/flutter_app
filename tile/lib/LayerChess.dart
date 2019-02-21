import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tile/Board.dart';
import 'package:tile/Coordinate.dart';
import 'package:tile/Function.dart';

class LayerChess extends StatefulWidget {
  GlobalKey<LayerChessState> keyChess;
  bool boardUnlock;
  Board board;
  int boardSize;
  int putType;
  TileNum tileNum;
  Func tileListener;


  LayerChess({
    this.keyChess,
    this.boardUnlock = true,
    this.board,
    this.boardSize = 19,
    this.putType = 0,
    this.tileNum = TileNum.end,
    this.tileListener
  }):super(key: keyChess);

  @override
  State<StatefulWidget> createState() {
    return LayerChessState();
  }
}

class LayerChessState extends State<LayerChess>{
  double _startX;//左上角x坐标
  double _startY;//左上角y坐标
  double _tileSize;
  double _xOffset;
  double _yOffset;

  @override
  void initState() {
    if(widget.board == null)
      widget.board = Board(widget.boardSize);
    print('layer chess initState');
  }

  void regret(int num){
    if ( widget.board.getCount() < num) return;
    widget.board = widget.board.getSubBoard(widget.board.getCount() - num);
    rePaintChess();
  }

  TileNum get tileNum => widget.tileNum;

  set tileNum(TileNum tileNum) {
    widget.tileNum = tileNum;
    rePaintChess();
  }

  void _onTapUp(TapUpDetails event) {
    print('onTapUp：${event.globalPosition}');
    if (!widget.boardUnlock) return;
    if(_startX == null || _startY == null){
      RenderBox renderBox = widget.keyChess.currentContext.findRenderObject();
      Offset offset = renderBox.localToGlobal(Offset.zero);
      print('start coordinate:$offset');
      _startX = offset.dx;
      _startY = offset.dy;
    }
    if (_tileSize == null) {
      Size size = widget.keyChess.currentContext.size;
      double width = min(size.width, size.height);
      _tileSize = width / (widget.boardSize + 1);
      _xOffset = _tileSize * 1;
      _yOffset = _tileSize * 1;
    }
    int x = x2Coordinate(event.globalPosition.dx - _startX);
    int y = y2Coordinate(event.globalPosition.dy - _startY);

    if (x == 0 || x > widget.boardSize || y == 0 || y > widget.boardSize) return;

    // 自信模式，直接落子
    if (widget.putType == 0) {
      doPutPiece(x, y);
    } else if (widget.putType == 2) {
//      topicx = x2Coordinate(xf + currentX);
//      topicy = y2Coordinate(yf + currentY);
//      TopicBank(topicx, topicy);
    } else {
      // 谨慎模式，预备落子
//      prePutPiece(x, y);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('layer chess build');
    return GestureDetector(
        onTapUp: _onTapUp,
        child: Container(
          child: CustomPaint(
              painter: _LayerChessPainter(widget.board,widget.boardSize,widget.tileNum)
          ),
        ));
  }

  //  void removePiece(int x, int y) {
//    board.currentGrid.a[x - 1][y - 1] = 0;
//    for (int i = 0, n = board.getCount(); i < n; i++) {
//      PieceProcess p = board.getPieceProcess(i);
//      if (p.c.x == x && p.c.y == y) {
//        board.getList().remove(i);
//        break;
//      }
//    }
//    rePaintChess();
//  }

  void rePaintChess(){
    setState(() {

    });
  }

  bool doPutPiece(int x, int y) {
    Board.hasPickother = false;

    if (widget.board.put(x, y, widget.boardSize)) {
      print('doPutPiece：$x,$y');
      rePaintChess();
      if (widget.tileListener != null)
        widget.tileListener();
      return true;
    }

    return false;
  }

  int x2Coordinate(double x) {
    return ((x - _xOffset) / _tileSize).round() + 1;
  }

  int y2Coordinate(double y) {
    return widget.boardSize - ((y - _yOffset) / _tileSize).round();
  }
}

enum TileNum{
  all,
  end,
  none
}

class _LayerChessPainter extends CustomPainter {
  Board board;
  int boardSize;
  TileNum tileNum;
  double _tileSize;
  double _xOffset;
  double _yOffset;
  Paint _paintBlack = Paint()..color = Colors.black;
  Paint _paintWhite = Paint()..color = Colors.white;

  _LayerChessPainter(this.board,this.boardSize,this.tileNum);

  @override
  void paint(Canvas canvas, Size size) {
    print('chess size：$size');
    if (_tileSize == null) {
      double width = min(size.width, size.height);
      _tileSize = width / (boardSize + 1);
      _xOffset = _tileSize * 1;
      _yOffset = _tileSize * 1;
    }
    _drawChess(canvas);
    _drawNum(canvas,tileNum);
  }

  void _drawChess(Canvas canvas){
    for(int x = 1;x<=boardSize;x++){
      for(int y = 1;y<=boardSize;y++){
        int bw = board.getValue(x, y);
        if(bw == Board.None) continue;
        switch(bw){
          case Board.Black:
            canvas.drawOval(Rect.fromCircle(center: Offset(x2Screen(x), y2Screen(y)),radius: _tileSize/2), _paintBlack);
            break;
          case Board.White:
            canvas.drawOval(Rect.fromCircle(center: Offset(x2Screen(x), y2Screen(y)),radius: _tileSize/2), _paintWhite);
            break;
        }
      }
    }
  }

  void _drawNum(Canvas canvas,TileNum tileNum){
    switch (tileNum) {
      case TileNum.all:
        int count = board.getCount();
        var paintList = List<Coordinate>();
        for(int i = count;i>=1;i--){
          Coordinate c = board.getPieceProcess(i - 1).c;

          if(c.x == 0 || c.y == 0) continue;
          if(paintList.contains(c)) continue;
          paintList.add(c);

          Offset offset = Offset(x2Screen(c.x), y2Screen(c.y));
          Color color;
          if(i == count){
            color = Colors.red;
          }else{
            color = i % 2 == 1?Colors.white:Colors.black;
          }
          _drawText(canvas, i.toString(), color, offset);
        }
        break;
      case TileNum.end:
        Coordinate coorLast = board.getLastPosition();
        if(coorLast == null) return;
        Offset offset = Offset(x2Screen(coorLast.x), y2Screen(coorLast.y));
        _drawText(canvas, board.getCount().toString(), Colors.red, offset);
        break;
      case TileNum.none:

        break;
    }
  }

  ///offset:文字的中心点
  void _drawText(Canvas canvas,String text,Color textColor,Offset offset){
    TextSpan textSpan = TextSpan(
        style: TextStyle(
            color: textColor,
            fontSize: 10
        ),
        text: text
    );
    TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr
    );
    //x
    textPainter.layout();
    textPainter.paint(canvas, Offset(offset.dx - textPainter.width/2, offset.dy - textPainter.height/2));
  }

  double x2Screen(int x) {
    return (x - 1) * _tileSize + _xOffset;
  }

  double y2Screen(int y) {
    return (boardSize - y) * _tileSize + _xOffset;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}