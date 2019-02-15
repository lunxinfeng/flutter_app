import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tile/Board.dart';

class LayerChess extends StatefulWidget {
  GlobalKey keyChess;
  bool boardUnlock;
  Board board;
  int boardSize;
  int putType;

  LayerChess({this.keyChess, this.boardUnlock = true, this.board, this.boardSize = 19,
    this.putType = 0});

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

  void onTapUp(TapUpDetails event) {
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
        key: widget.keyChess,
        onTapUp: onTapUp,
        child: Container(
          child: CustomPaint(
            painter: LayerChessPainter(widget.board,widget.boardSize)
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
//    String c = board.getCurBW();
//    if (y < 10)
//      c += "0$y";
//    else
//      c += y.toString();
//    if (x < 10)
//      c += "0$x";
//    else
//      c += x.toString();

    Board.hasPickother = false;

    if (widget.board.put(x, y, widget.boardSize)) {
      print('doPutPiece：$x,$y');
      rePaintChess();
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

class LayerChessPainter extends CustomPainter {
  Board board;
  int boardSize;
  double _tileSize;
  double _xOffset;
  double _yOffset;
  Paint _paintBlack = Paint()..color = Colors.black;
  Paint _paintWhite = Paint()..color = Colors.white;

  LayerChessPainter(this.board,this.boardSize);

  @override
  void paint(Canvas canvas, Size size) {
    print('chess size：$size');
    if (_tileSize == null) {
      double width = min(size.width, size.height);
      _tileSize = width / (boardSize + 1);
      _xOffset = _tileSize * 1;
      _yOffset = _tileSize * 1;
    }
    drawChess(canvas);
  }

  void drawChess(Canvas canvas){
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
